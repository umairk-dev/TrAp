#include "controls.h"
#include <QtGui>
#include <QtQuick>
#include <QDialog>
#include <QObject>
#include <qfile.h>


#include "cyclone.h"
#include "cyclonetrack.h"
Controls::Controls(QObject  *parent) : QObject (parent)
{

}


void Controls::onHello(){

}

void Controls::setEngine(QQmlApplicationEngine * engine){
    _engine = engine;
}


void Controls::handleSubmitTextField(const QString &in)
{
    qDebug() << "c++: HandleTextField::handleSubmitTextField:" << in;
    emit setTextField(in.toUpper());
}


void Controls::searchCycloneByName(const QString &name)
{

       QNetworkAccessManager * nam = new QNetworkAccessManager(this);
       QObject::connect(nam, SIGNAL(finished(QNetworkReply*)),
                this, SLOT(searchCycloneServiceFinished(QNetworkReply*)));

     //  QUrl url("http://smarttechsoft.com/trap/index.php?type=cname&name=" + name );
       QUrl url("http://130.56.253.211/api2/web/index.php?r=cyclone/searchbyname&key="+ name +"&_format=json&source=2");
       QNetworkReply* reply = nam->get(QNetworkRequest(url));


      // emit setTextField(in.toUpper());
}


void Controls::searchCycloneByArea(const QString &lat1, const QString &lng1,const QString &lat2, const QString &lng2)
{

       QNetworkAccessManager * nam = new QNetworkAccessManager(this);
       QObject::connect(nam, SIGNAL(finished(QNetworkReply*)),
                this, SLOT(searchCycloneServiceFinished(QNetworkReply*)));

//       "http://smarttechsoft.com/trap/index.php?type=area&lat=" + lat +"&lng=" + lng + "&radius=" + radius

       QUrl url( "http://130.56.253.211/api2/web/index.php?r=cyclone/searchbyregion&latfrom="+lat1+"&lntfrom="+lng1+"&latto="+lat2+"&lntto="+lng2);
       QNetworkReply* reply = nam->get(QNetworkRequest(url));

      // emit setTextField(in.toUpper());
}


void Controls::searchCycloneByYear(const QString &year)
{

       QNetworkAccessManager * nam = new QNetworkAccessManager(this);
       QObject::connect(nam, SIGNAL(finished(QNetworkReply*)),
                this, SLOT(searchCycloneServiceFinished(QNetworkReply*)));
//       QUrl url("http://smarttechsoft.com/trap/index.php?type=cyear&year=" + year );

       QUrl url("http://130.56.253.211/api2/web/index.php?r=cyclone/searchbyyear&key="+ year +"&_format=json&source=2");
       QNetworkReply* reply = nam->get(QNetworkRequest(url));
}


void Controls::searchCycloneByWind(const QString &windFrom, const QString &windTo)
{

       QNetworkAccessManager * nam = new QNetworkAccessManager(this);
       QObject::connect(nam, SIGNAL(finished(QNetworkReply*)),
                this, SLOT(searchCycloneServiceFinished(QNetworkReply*)));
       QUrl url("http://130.56.253.211/api2/web/index.php?r=cyclone/searchbywind&windfrom="+ windFrom +"&windto="+windTo+"&_format=json&source=2");
       QNetworkReply* reply = nam->get(QNetworkRequest(url));
}

void Controls::searchCycloneByYears(const QString &yearFrom,const QString &yearTo)
{

       QNetworkAccessManager * nam = new QNetworkAccessManager(this);
       QObject::connect(nam, SIGNAL(finished(QNetworkReply*)),
                this, SLOT(searchCycloneServiceFinished(QNetworkReply*)));
       QUrl url("http://130.56.253.211/api2/web/index.php?r=cyclone/searchbyyears&yearfrom="+yearFrom+"&yearto="+ yearTo +"&_format=json&source=2");
       QNetworkReply* reply = nam->get(QNetworkRequest(url));
}


void Controls::searchCycloneByPressure(const QString &pressureFrom,const QString &pressureTo)
{

       QNetworkAccessManager * nam = new QNetworkAccessManager(this);
       QObject::connect(nam, SIGNAL(finished(QNetworkReply*)),
                this, SLOT(searchCycloneServiceFinished(QNetworkReply*)));
       QUrl url("http://130.56.253.211/api2/web/index.php?r=cyclone/searchbypressure&pressurefrom="+pressureFrom+"&pressureto="+ pressureTo +"&_format=json&source=2");
       QNetworkReply* reply = nam->get(QNetworkRequest(url));
}

void Controls::clearMap()
{
    QObject *map = _engine->rootObjects().at(0)->findChild<QObject*>("map");
    if(map)
    {
         if(!QMetaObject::invokeMethod(map, "clearMap" ))
             qDebug() << "Failed to clear";
    }
}

void Controls::controlMapMouse(const bool& status)
{
    QObject *map = _engine->rootObjects().at(0)->findChild<QObject*>("map");
    if(map)
    {
        if(status == true){
            if(!QMetaObject::invokeMethod(map, "enableMouse" ))
                qDebug() << "Failed to enable map";
        }else{
            if(!QMetaObject::invokeMethod(map, "disableMouse" ))
                qDebug() << "Failed to disable map";
        }
    }
}


void Controls::generateReport(const QString &path,const  QVariant &cyclones)
{

    QString fileName = path.mid(8,path.length());
    if(fileName.mid(fileName.length()-4) != ".csv")
        fileName.append(".csv");
    QFile file( fileName ); // Write the text to a file
    if ( file.open( QIODevice::WriteOnly ) )
    {
        QTextStream stream( &file );
        QList<QVariant> list = cyclones.toList();
        for(int i = 0; i < list.size(); i++){
           Cyclone * c = qvariant_cast<Cyclone*>(list.at(i));
           stream << "Serial Num"<<","<<"Cyclone Name" << "," << "Year"<<"\n";
           stream << c->getNum()<<","<<c->getCycloneName()<<","<<c->getSeasonYear()<<"\n";
           stream << "TrackID"<<","<<"Date/Time" << "," << "Latitude"<<"," << "Longitude"<<"," << "Wind Speed"<<"," << "Pressure"<<"," << "Basin"<<"," << "Sub Basin"<<"\n";
           for(int j = 0; j < c->getTracks().size(); j++){
               CycloneTrack * track = qvariant_cast<CycloneTrack*>(c->getTracks().at(j));
               stream << track->getTrackID()  <<","<<track->getDateTime() << "," << track->getLatitude()<<"," << track->getLongitude()<<"," << track->getWindSpeed()<<"," << track->getPressure()<<"," << track->getBasin()<<"," << track->getSubBasin()<<"\n";
           }
           //qDebug() <<  c->getCycloneName();
        }
        QObject *webView = _engine->rootObjects().at(0)->findChild<QObject*>("map");
        if(webView)
        {
           // qDebug() << "ERROR";
            QString msg = "Report Generated Successfully..";
            if(!QMetaObject::invokeMethod(webView, "reportGenerated",  Q_ARG(QVariant,QVariant::fromValue( msg))))
               qDebug() << "Failed to invoke push";
        }
    }else{
        QObject *webView = _engine->rootObjects().at(0)->findChild<QObject*>("map");
        if(webView)
        {
           // qDebug() << "ERROR";
            QString msg = "Error: Unable to create file";
            if(!QMetaObject::invokeMethod(webView, "reportGenerated", Q_ARG(QVariant, QVariant::fromValue(msg))))
               qDebug() << "Failed to invoke push";
        }
        qDebug() << "unable to open";

    }


}

void Controls::searchCycloneServiceFinished(QNetworkReply* reply)
{
    if(reply->error() == QNetworkReply::NoError) {

        QStringList propertyNames;
        QStringList propertyKeys;

        QString strReply = reply->readAll();

        //

        QJsonDocument jsonResponse = QJsonDocument::fromJson(strReply.toUtf8());

        QJsonObject jsonObject = jsonResponse.object();


        QVariantList cyclones;

        if(jsonObject.keys().contains("cyclones")){
            qDebug() << strReply;
            QJsonArray jsonArray = jsonObject["cyclones"].toArray();
            foreach (const QJsonValue & value, jsonArray)
            {

                QJsonObject obj = value.toObject();
                QJsonObject objC = obj["cyclone"].toObject();
                Cyclone * cyclone = new Cyclone;

                QString id = QString::number(objC["id"].toInt());
                cyclone->setCycloneName(objC["name"].toString());
                cyclone->setCycloneID(id);
                cyclone->setSeasonYear(objC["year"].toString());
                cyclone->setNum(objC["serial_num"].toString());
                cyclone->setSource(objC["source"].toString());

//                qDebug()<<obj["cyclone"];

                qDebug()<<objC["name"];


                QVariantList cycloneTracks;
                if(obj.keys().contains("tracks")){

                    QJsonArray tracksArray = obj["tracks"].toArray();
                    qDebug() << tracksArray.size();
                    foreach (const QJsonValue & valueT, tracksArray)
                    {
                        QJsonObject objT = valueT.toObject();

                        QString id = objT["id"].toString();
                        QString lng = objT["longitude"].toString();
                        QString lat = objT["latitude"].toString();
                        QString wind = objT["wind"].toString();
                        QString pressure = objT["pressure"].toString();

                        CycloneTrack * tracks = new CycloneTrack;
                        tracks->setCycloneID(obj["cyclone"].toString());
                        tracks->setTrackID(id.toInt());
                        tracks->setLongitude(lng.toDouble());
                        tracks->setLatitude(lat.toDouble());
                        tracks->setPressure(pressure.toDouble());
                        tracks->setWindSpeed(wind.toDouble());
                        tracks->setBasin(objT["basin"].toString());
                        tracks->setSubBasin(objT["sub_basin"].toString());
                        //tracks->setNature(objT["nature"].toString());
                        tracks->setDateTime(objT["track_date"].toString());
                       // tracks->increaseAccuracy();
                        QVariant varT;
                        varT.setValue(tracks);
                        cycloneTracks.append(varT);
                    }
                        qDebug() << "tracks" << cycloneTracks.size();

                        cyclone->setTracks(cycloneTracks);
                }
                QVariant varC;
                varC.setValue(cyclone);
                cyclones.append(varC);
            }
        }


      //  qDebug() << cyclones.size();
        QObject *webView = _engine->rootObjects().at(0)->findChild<QObject*>("map");
        if(webView)
        {
            if(cyclones.size() > 0){
                for(int i = 0; i < cyclones.size(); i++){
                    if(!QMetaObject::invokeMethod(webView, "searchResult", Q_ARG(QVariant, QVariant::fromValue(cyclones.at(i)))
                                                                            ,Q_ARG(QVariant, QVariant::fromValue(i)),Q_ARG(QVariant,
                                                                             QVariant::fromValue(cyclones.size()))))
                        qDebug() << "Failed to invoke push";

                    delay();
                }
            }else{
                if(!QMetaObject::invokeMethod(webView, "noResult"))
                    qDebug() << "Failed to invoke push";
            }
        }
    } else {
        QObject *webView = _engine->rootObjects().at(0)->findChild<QObject*>("map");
        if(webView)
        {
            qDebug() << "ERROR";
            if(!QMetaObject::invokeMethod(webView, "searchError"))
               qDebug() << "Failed to invoke push";
        }
    }

    delete reply;
}



void Controls::delay()
{
    QTime dieTime= QTime::currentTime().addMSecs(1);
    while (QTime::currentTime() < dieTime)
        QCoreApplication::processEvents(QEventLoop::AllEvents, 100);
}








