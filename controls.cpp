#include "controls.h"
#include <QtGui>
#include <QtQuick>
#include <QDialog>
#include <QObject>
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


void Controls::searchCycloneByArea(const QString &lat, const QString &lng,const QString &radius)
{

       QNetworkAccessManager * nam = new QNetworkAccessManager(this);
       QObject::connect(nam, SIGNAL(finished(QNetworkReply*)),
                this, SLOT(searchCycloneServiceFinished(QNetworkReply*)));

       QUrl url("http://smarttechsoft.com/trap/index.php?type=area&lat=" + lat +"&lng=" + lng + "&radius=" + radius);
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
                Cyclone * cyclone = new Cyclone;
                cyclone->setCycloneName(obj["name"].toString());
                cyclone->setCycloneID(obj["id"].toString());
                cyclone->setSeasonYear(obj["year"].toString());
                cyclone->setNum(obj["serial_num"].toString());
                cyclone->setSource(obj["source"].toString());



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
            if(!QMetaObject::invokeMethod(webView, "searchResult", Q_ARG(QVariant, QVariant::fromValue(cyclones))))
               qDebug() << "Failed to invoke push";

        }else{
            qDebug() << "notfound";
        }
    } else {
        qDebug() << "ERROR";
    }

    delete reply;
}







