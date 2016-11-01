#include "forecastthread.h"
#include "plotpoint.h"

#if defined Q_OS_BLACKBERRY || defined Q_OS_ANDROID || defined Q_OS_IOS || defined Q_OS_WP
#define Q_OS_MOBILE
#else
#define Q_OS_DESKTOP
#endif

ForecastThread::ForecastThread(Prediction *prediction)
{
        this->prediction = prediction;
}


void ForecastThread::run()
{
    freeMemory();
    doForecast();
}


void ForecastThread::freeMemory(){
    if(forecastResult.size() > 0){
        for(int i = 0; i < forecastResult.size(); i ++){
             delete qvariant_cast<PResult*>( forecastResult.at(i));
        }
    }
    forecastResult.clear();
}

QList<QString> * ForecastThread::getMonitorValues(QString name){

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


void ForecastThread::doForecast(){
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

    QDateTime local(QDateTime::currentDateTime());
    int current = local.toString("yyyy").toInt();

    ElLa* ella = db.getSingleElLa(current, prediction->_elSeason.toInt());

    if(ella == NULL){
        msg = "ElNino LaNina data is not available for selected season";
        if(mapView && !QMetaObject::invokeMethod(mapView, "showStatus", Q_ARG(QVariant, QVariant::fromValue(msg))))
            qDebug() << "Failed to invoke showStatus";
        return;
    }

    msg = "Calculating lambda.. ";
    if(mapView && !QMetaObject::invokeMethod(mapView, "showStatus", Q_ARG(QVariant, QVariant::fromValue(msg))))
        qDebug() << "Failed to invoke showStatus";

    QList<double> * result = new QList<double>();
    size = monitors->value(list.at(0))->size();
    for(int i = 0; i < size; i++){
        double lambda = 0;
        double el = ella->getValue();
        vararray[0]->pval = &el;
        for(int k = 0; k < list.size(); k++){
              double v = monitors->value(list.at(k))->at(i).toDouble();
              vararray[k+1]->pval = &v;
        }

        ROperation op ( eq,(list.size()+1), vararray );

        lambda = op.Val();
        lambda = exp(lambda);

        if(lambda < 0)
            lambda = 0;


        result->append(lambda);

    }

    for(int i = 0; i < list.size(); i++ ){
        delete monitors->value(list.at(i));
    }

    delete monitors;

    //save result & free memory


    PResult * r = processLambda(ella->getYear(), result);
    QVariant p;
    p.setValue(r);
    forecastResult.append(p);


    if(!QMetaObject::invokeMethod(mapView, "plotForeCastResult", Q_ARG(QVariant, QVariant::fromValue(forecastResult))))
        qDebug() << "Failed to invoke push";


    delete ella;
    delete result;
    delete m;
    #endif
}

int ForecastThread::roundLambda( double value )
{
#ifdef  Q_OS_DESKTOP
  return INT32_C(floor( value + 0.5 ));
#endif
}

PResult *  ForecastThread::processLambda(int year, QList<double>* data){

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


void ForecastThread::saveResult(int year, QList<double>* data){
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
