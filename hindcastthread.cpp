#include "hindcastthread.h"
#include "plotpoint.h"
#include "prediction.h"
#include "mathexpr.h"
#include "presult.h"

#if defined Q_OS_BLACKBERRY || defined Q_OS_ANDROID || defined Q_OS_IOS || defined Q_OS_WP
#define Q_OS_MOBILE
#else
#define Q_OS_DESKTOP
#endif

HindcastThread::HindcastThread(Prediction *prediction)
{
    this->prediction = prediction;
}


void HindcastThread::run()
{
    freeMemory();
    doHindcast();
}


void HindcastThread::freeMemory(){
    if(hindcastResult.size() > 0){
        for(int i = 0; i < hindcastResult.size(); i ++){
             delete qvariant_cast<PResult*>( hindcastResult.at(i));
        }
    }
    hindcastResult.clear();
}

QList<QString> * HindcastThread::getMonitorValues(QString name){

    QString fname = QCoreApplication::applicationDirPath() + "/"+name + "CODAchain1.txt";
    QFile file(fname);
    if(!file.open(QIODevice::ReadOnly)) {
        //QMessageBox::information(0, "error", file.errorString());
    }

    QTextStream in(&file);

    QList<QString> * values = new QList<QString>();
    while(!in.atEnd()) {
        QString line = in.readLine();
        QStringList fields = line.split(" ");
        values->append(fields.at(1));
    }

    file.close();

    return values;

}


void HindcastThread::doHindcast(){
    #ifdef  Q_OS_DESKTOP
    QObject * mapView = prediction->getEngine()->rootObjects().at(0)->findChild<QObject*>("map");
    QString msg = "loading Monitors";

    DbManager db = DbManager::get();
    QHash<QString, QList<QString> *> * monitors = new QHash<QString, QList<QString> *> ();
    QStringList list = db.getMonitorList(prediction->_modelID.toInt());

    int size  = 0;

    if(mapView && !QMetaObject::invokeMethod(mapView, "showStatus", Q_ARG(QVariant, QVariant::fromValue(msg))))
        qDebug() << "Failed to invoke showStatus";

    RVar* vararray[list.size()+1];
    RVar * xvar = new RVar();
    xvar->name = "Nino34[i]";
    vararray[0] = xvar;

    Model * m = db.getModel(prediction->_modelID);
    char * eq = strdup(m->getModelEquation().toStdString().c_str());

    for(int i = 0; i < list.size(); i++ ){
        monitors->insert(list.at(i), getMonitorValues(list.at(i))) ;
        char * vname = new CHAR(list.at(i).size()+1);
        strcpy(vname, list.at(i).toStdString().c_str());

        RVar * xvar = new RVar();

        xvar->name = vname;
        xvar->pval = 0;

        vararray[i+1] = xvar;
    }

    QList<ElLa*> ella = db.getElLa(prediction->_elSeason.toInt());
    QDateTime local(QDateTime::currentDateTime());
    int current = local.toString("yyyy").toInt();

    msg = "Calculating lambda.. ";
    if(mapView && !QMetaObject::invokeMethod(mapView, "showStatus", Q_ARG(QVariant, QVariant::fromValue(msg))))
        qDebug() << "Failed to invoke showStatus";

    QHash<int, QList<double>*> * result = new QHash<int, QList<double>*>();
    size = monitors->value(list.at(0))->size();
    for(int i = 0; i < size; i++){
        for(int j =0; j < ella.size() ; j++){

            if(ella.at(j)->getYear() < current){
                double lambda = 0;
              //  mu::Parser p;
                double el = ella.at(j)->getValue();
                vararray[0]->pval = &el;
              //  p.DefineVar( "Nino34[i]",&el) ;
                for(int k = 0; k < list.size(); k++){
                    double v = monitors->value(list.at(k))->at(i).toDouble();
                    vararray[k+1]->pval = &v;

                   /* if(list.at(k) == "beta1")
                        lambda += monitors->value(list.at(k))->at(i).toDouble() * ella.at(j)->getValue() ;
                    else if(list.at(k) == "beta0")
                        lambda += monitors->value(list.at(k))->at(i).toDouble() ;
                    */
                }

                ROperation op ( eq,(list.size()+1), vararray );

                lambda = op.Val();//p.Eval();
                lambda = exp(lambda);

                if(lambda < 0)
                    lambda = 0;


                if(result->contains(ella.at(j)->getYear())){
                    result->value(ella.at(j)->getYear())->append(lambda);
                }else{
                    QList<double> * lambdas = new QList<double>();
                    lambdas->append(lambda);
                    result->insert(ella.at(j)->getYear(), lambdas);
                }
            }

        }
    }

    for(int i = 0; i < list.size(); i++ ){
        delete monitors->value(list.at(i));
    }

    delete monitors;

    //save result & free memory


    for(int i = 0; i < ella.size(); i++){
        if(ella.at(i)->getYear() != current){


            PResult * r = processLambda(ella.at(i)->getYear(), result->value(ella.at(i)->getYear()));
            QVariant p;
            p.setValue(r);
            hindcastResult.append(p);

            //saveResult(ella.at(i)->getYear(), result->value(ella.at(i)->getYear()));
            result->value(ella.at(i)->getYear())->clear();
            result->remove(ella.at(i)->getYear());


        }
    }

    if(!QMetaObject::invokeMethod(mapView, "plotHindCastResult", Q_ARG(QVariant, QVariant::fromValue(hindcastResult))))
        qDebug() << "Failed to invoke push";




    for(int i = 0; i < ella.size(); i++){
        ella.removeAt(i);
    }

    delete result;

    delete m;
   // delete mapView;
#endif
}

int HindcastThread::roundLambda( double value )
{
  #ifdef  Q_OS_DESKTOP
  return INT32_C(floor( value + 0.5 ));
  #else
    return 0;
  #endif
}

PResult *  HindcastThread::processLambda(int year, QList<double>* data){

     QHash<int, int> * plotData = new QHash<int, int>();

     QObject * mapView = prediction->getEngine()->rootObjects().at(0)->findChild<QObject*>("map");
     QString msg = "Calculating points of " + QString::number(year);
     if(mapView && !QMetaObject::invokeMethod(mapView, "showStatus", Q_ARG(QVariant, QVariant::fromValue(msg))))
         qDebug() << "Failed to invoke showStatus";

     for(int i = 0; i < 10; i++)
         plotData->insert(i,0);

     for(int i = 0; i < data->size(); i++){
         int val = roundLambda(data->at(i));
         if(plotData->contains(val))
             plotData->insert(val, plotData->value(val)+  1);
         else
             plotData->insert(val,1);
     }

     msg = "finalizing points for " + QString::number(year);
     if(mapView && !QMetaObject::invokeMethod(mapView, "showStatus", Q_ARG(QVariant, QVariant::fromValue(msg))))
         qDebug() << "Failed to invoke showStatus";


     PResult * result = new PResult();
     QVariantList list ;
     for(int i = 0; i < plotData->size(); i++){
         PlotPoint * point = new PlotPoint;

         point->setX(i);
         double y = (plotData->value(i) / prediction->_update.toDouble());
         point->setY(y);
         QVariant p;
         p.setValue(point);
         list.append(p);
     }

     result->setResult(list);
     msg = "";
     if(mapView && !QMetaObject::invokeMethod(mapView, "showStatus", Q_ARG(QVariant, QVariant::fromValue(msg))))
         qDebug() << "Failed to invoke showStatus";


    // delete data;
     delete plotData;
     return result;
}


void HindcastThread::saveResult(int year, QList<double>* data){
    QString dataFile = QCoreApplication::applicationDirPath()+"/result/" + QString::number(year)+".txt";
    QFile file(dataFile);
    file.remove();
    if (file.open(QIODevice::WriteOnly | QIODevice::Text)) {
        QTextStream stream(&file);
        for(int i = 0; i < data->size(); i++)
            stream <<data->at(i)<< '\n';
    }

    file.close();
}
