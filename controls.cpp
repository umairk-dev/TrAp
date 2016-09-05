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

       QUrl url("http://smarttechsoft.com/trap/index.php?type=cname&name=" + name );
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
       QUrl url("http://smarttechsoft.com/trap/index.php?type=cyear&year=" + year );
       QNetworkReply* reply = nam->get(QNetworkRequest(url));
}


void Controls::controlMapMouse(const bool& status)
{
    QObject *map = _engine->rootObjects().at(0)->findChild<QObject*>("map");
    if(map)
    {
        if(status == true){
            if(!QMetaObject::invokeMethod(map, "enableMouse" ))
                qDebug() << "Failed to invoke push";
        }else{
            if(!QMetaObject::invokeMethod(map, "disableMouse" ))
                qDebug() << "Failed to invoke push";
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
                cyclone->setCycloneName(obj["cycloneName"].toString());
                cyclone->setCycloneID(obj["cycloneID"].toString());
                cyclone->setBasin(obj["basin"].toString());
                cyclone->setSubBasin(obj["subBasin"].toString());
                cyclone->setSeasonYear(obj["seasonYear"].toString());
           //     cyclone.setNum(obj["num"].toString());



                QVariantList cycloneTracks;
                if(obj.keys().contains("tracks")){



                    QJsonArray tracksArray = obj["tracks"].toArray();
                    qDebug() << tracksArray.size();
                    foreach (const QJsonValue & valueT, tracksArray)
                    {
                        QJsonObject objT = valueT.toObject();
                        CycloneTrack * tracks = new CycloneTrack;
                        tracks->setCycloneID(obj["cycloneID"].toString());
                        tracks->setTrackID(objT["trackID"].toInt());
                        tracks->setLongitude(objT["longitude"].toDouble());
                        tracks->setLatitude(objT["latitude"].toDouble());
                        tracks->setPressure(objT["pressure"].toDouble());
                        tracks->setWindSpeed(objT["windSpeed"].toDouble());
                        tracks->setNature(objT["nature"].toString());
                        //tracks->setDateTime(objT["dateTime"].toString());
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







