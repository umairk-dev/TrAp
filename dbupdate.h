#ifndef DBUPDATE_H
#define DBUPDATE_H

#include <QObject>

#include <QQmlApplicationEngine>
#include <QtNetwork>
#include "cyclone.h"
#include "ella.h"
class DBUpdate : public QObject
{
    Q_OBJECT
public:
    explicit DBUpdate(QObject *parent = 0);

    Q_INVOKABLE  void setEngine(QQmlApplicationEngine *engine);



signals:

public slots:
    void checkVersion();
    void updateElLa();
    void updateServiceFinished(QNetworkReply* reply);
private:
             QQmlApplicationEngine* _engine;

            void updateDB(int v);
            QList<Cyclone> * cycloneList;
            QList<ElLa*> * ellaList;

             QNetworkAccessManager * nam;
};

#endif // DBUPDATE_H
