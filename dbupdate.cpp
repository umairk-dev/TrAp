#include "dbupdate.h"
#include "dbmanager.h"
#include "cyclone.h"
#include "cyclonetrack.h"
#include "UpdateThread.h"
DBUpdate::DBUpdate(QObject *parent) : QObject(parent)
{
   // cycloneList = new QList<Cyclone>();
    nam = new QNetworkAccessManager(this);
    QObject::connect(nam, SIGNAL(finished(QNetworkReply*)),
             this, SLOT(updateServiceFinished(QNetworkReply*)));

}


void DBUpdate::checkVersion(){
    QObject * mapView = _engine->rootObjects().at(0)->findChild<QObject*>("map");
    QString msg = "Checking for updates";
    if(!QMetaObject::invokeMethod(mapView, "showStatus", Q_ARG(QVariant, QVariant::fromValue(msg))))
        qDebug() << "Failed to invoke showStatus";

    QUrl url("http://130.56.253.211/api2/web/index.php?r=cyclone/version");
    nam->get(QNetworkRequest(url));

}


void DBUpdate::setEngine(QQmlApplicationEngine * engine){
    _engine = engine;
}



void DBUpdate::updateDB(int v){

    //DbManager db = DbManager::get();
   // db.clearDB();
  //  qDebug() << "clearing database";

    QObject * mapView = _engine->rootObjects().at(0)->findChild<QObject*>("map");
    QString msg = "Downloading Cyclone Data.. Please Wait";
    if(!QMetaObject::invokeMethod(mapView, "showStatus", Q_ARG(QVariant, QVariant::fromValue(msg))))
        qDebug() << "Failed to invoke showStatus";




    QDateTime local(QDateTime::currentDateTime());
    int current = local.toString("yyyy").toInt();


    //for(int year = 1970; year <= current; year++ ){
        QString y = QString::number(1970);
       // QUrl url("http://130.56.253.211/api2/web/index.php?r=cyclone/searchbyyear&key=" + y +"&_format=json&source=2");
        QUrl url("http://130.56.253.211/api2/web/index.php?r=cyclone/searchbyyears&yearfrom="+y+"&yearto="+ QString::number(current) +"&_format=json&source=2");
        nam->get(QNetworkRequest(url));


      //  QTime dieTime= QTime::currentTime().addSecs(1);
      //  while (QTime::currentTime() < dieTime)
        //    QCoreApplication::processEvents(QEventLoop::AllEvents, 1000);

    //}



    DbManager db = DbManager::get();
    db.updateVersion(v);

}


void DBUpdate::updateElLa(){

    QObject * mapView = _engine->rootObjects().at(0)->findChild<QObject*>("map");
    QString msg = "Checking updates for El Niño La El Niña .. Please Wait";
    if(!QMetaObject::invokeMethod(mapView, "showStatus", Q_ARG(QVariant, QVariant::fromValue(msg))))
        qDebug() << "Failed to invoke showStatus";

    QDateTime local(QDateTime::currentDateTime());
    int current = local.toString("yyyy").toInt();
    //update El-La

    ellaList = new QList<ElLa*>();

    for(int year = 1970; year<=current;year++){
        for(int month = 1; month <=12; month++){
            QString m = QString::number(month);
            QUrl url("http://130.56.253.211/api2/web/index.php?r=cyclone/el&year="+QString::number(year)+"&gap=" + m + "&_format=json" );

            nam->get(QNetworkRequest(url));
            QTime dieTime= QTime::currentTime().addSecs(1);
            while (QTime::currentTime() <= dieTime)
                QCoreApplication::processEvents(QEventLoop::AllEvents,1000);
        }
    }

}

void DBUpdate::updateServiceFinished(QNetworkReply* reply)
{

    if(reply->error() == QNetworkReply::NoError) {
        //UpdateThread *  thread = new UpdateThread(_engine, reply->readAll());
        //thread->start();
        QString r = reply->readAll();
        QJsonDocument jsonResponse = QJsonDocument::fromJson(r.toUtf8());
        QJsonObject jsonObject = jsonResponse.object();
        QDateTime local(QDateTime::currentDateTime());
        int current = local.toString("yyyy").toInt();


        bool isLast = false;
        if(jsonObject.contains("cyclones")){
            QJsonArray jsonArray = jsonObject["cyclones"].toArray();

             DbManager db = DbManager::get();
             int year = 0;

             QList<Cyclone*> * cyclones = new QList<Cyclone*>();
             foreach (const QJsonValue & value, jsonArray)
             {
                 QJsonObject obj = value.toObject();
                 QJsonObject objC = obj["cyclone"].toObject();


                 QString id = QString::number(objC["id"].toInt());
                 if(!db.checkCyclone(id)){
                     Cyclone * cyclone = new Cyclone;
                     cyclone->setCycloneName(objC["name"].toString());
                     cyclone->setCycloneID(id);
                     cyclone->setSeasonYear(objC["year"].toString());
                     cyclone->setNum(objC["serial_num"].toString());
                     cyclone->setSource(QString::number(objC["source"].toInt()));
                     cyclone->setCType(objC["ctype"].toString());

                     year = objC["year"].toString().toInt();
                     QVariantList cycloneTracks;
                     if(obj.keys().contains("tracks")){

                         QJsonArray tracksArray = obj["tracks"].toArray();

                         foreach (const QJsonValue & valueT, tracksArray)
                         {
                             QJsonObject objT = valueT.toObject();

                             QString id = objT["id"].toString();
                             QString lng = objT["longitude"].toString();
                             QString lat = objT["latitude"].toString();
                             QString wind = objT["wind"].toString();
                             QString pressure = objT["pressure"].toString();

                             CycloneTrack * tracks = new CycloneTrack;
                             tracks->setCycloneID(objT["cyclone"].toString());
                             tracks->setTrackID(id.toInt());
                             tracks->setLongitude(lng.toDouble());
                             tracks->setLatitude(lat.toDouble());
                             tracks->setPressure(pressure.toDouble());
                             tracks->setWindSpeed(wind.toDouble());
                             tracks->setBasin(objT["basin"].toString());
                             tracks->setSubBasin(objT["sub_basin"].toString());
                             tracks->setDateTime(objT["track_date"].toString());

                             QVariant varT;
                             varT.setValue(tracks);
                             cycloneTracks.append(varT);
                         }

                         cyclone->setTracks(cycloneTracks);
                     }


                     cyclones->append(cyclone);
                 }
             }

                qDebug() << year << ": " + cyclones->size();
             if(year == current)
             {
                  isLast = true;
             }

             if(cyclones->size()>0){
                 UpdateThread * update = new UpdateThread(_engine, cyclones, isLast);

                 update->start();
             }else{

                 delete cyclones;
             }

        }else if(jsonObject.keys().contains("year") && jsonObject.keys().contains("color")){
            int year = jsonObject["year"].toString().toInt();




            ElLa * ella = new ElLa;
            ella->setYear(jsonObject["year"].toString().toInt());
            ella->setMonth(jsonObject["gap"].toInt());
            ella->setValue(jsonObject["level"].toDouble());
            ella->setColor(jsonObject["color"].toString());
            DbManager db = DbManager::get();
            db.setEngine(this->_engine);
            if(!db.checkElLa(ella->getYear(), ella->getMonth()))
                ellaList->append(ella);
            else
                delete ella;

            qDebug() << year << " - " << jsonObject["gap"].toInt();
            if( year == current && jsonObject["gap"].toInt() == 6  )
            {
                 UpdateThread * update = new UpdateThread(_engine, ellaList);
                 update->start();
                 isLast = true;
            }

        }




        if(isLast){
            QObject * mapView = _engine->rootObjects().at(0)->findChild<QObject*>("map");
            QString msg = "";
            if(!QMetaObject::invokeMethod(mapView, "showStatus", Q_ARG(QVariant, QVariant::fromValue(msg))))
                qDebug() << "Failed to invoke showStatus";

        }


        if(jsonObject.keys().contains("ver")){

            int v = jsonObject["ver"].toInt();
            QObject * mapView = _engine->rootObjects().at(0)->findChild<QObject*>("map");

            DbManager db = DbManager::get();
            if( v > db.getVersion()){
                qDebug() << "reload database";
                QString msg = "new version available.. updating";

                if(mapView && !QMetaObject::invokeMethod(mapView, "showStatus", Q_ARG(QVariant, QVariant::fromValue(msg))))
                    qDebug() << "Failed to invoke showStatus";
                updateDB(v);
            }else{
                qDebug() << "latest database";
                QString msg = "no updates available..";

                if(mapView && !QMetaObject::invokeMethod(mapView, "showStatus", Q_ARG(QVariant, QVariant::fromValue(msg))))
                    qDebug() << "Failed to invoke showStatus";

            }

        }
    }
    delete reply;
}
