#include "controls.h"
#include <QtGui>
#include <QtQuick>
#include <QDialog>


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


void Controls::searchCyclone(const QString &name)
{

       QNetworkAccessManager * nam = new QNetworkAccessManager(this);
       QObject::connect(nam, SIGNAL(finished(QNetworkReply*)),
                this, SLOT(serviceRequestFinished(QNetworkReply*)));

       QUrl url("http://date.jsontest.com/?name=" + name );
       QNetworkReply* reply = nam->get(QNetworkRequest(url));

      // emit setTextField(in.toUpper());
}


void Controls::serviceRequestFinished(QNetworkReply* reply)
{
    if(reply->error() == QNetworkReply::NoError) {

        QStringList propertyNames;
        QStringList propertyKeys;

        QString strReply = reply->readAll();

        qDebug() << strReply;

        QJsonDocument jsonResponse = QJsonDocument::fromJson(strReply.toUtf8());

        QJsonObject jsonObject = jsonResponse.object();

   //     QJsonArray jsonArray = jsonObject["time"].toArray();

        qDebug() << jsonObject["time"].toString();

        qDebug() << jsonObject["date"].toString();

/*        foreach (const QJsonValue & value, jsonArray)
        {
            QJsonObject obj = value.toObject();
            qDebug() << value.toString();
        }
*/


    } else {
        qDebug() << "ERROR";
    }

    delete reply;
}
