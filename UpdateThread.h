#ifndef MYTHREAD_H
#define MYTHREAD_H

#include <QThread>

#include <QQmlApplicationEngine>
#include <QtNetwork>
#include "ella.h"
#include "cyclone.h"
#include "cyclonetrack.h"

class UpdateThread : public QThread
{
    Q_OBJECT
public:
    UpdateThread( QQmlApplicationEngine * _engine,QList<Cyclone*>* cyclones, bool isLast);
    UpdateThread( QQmlApplicationEngine * _engine,QList<ElLa*>* ellaList);
    protected:
        void run();
        void updateCyclones();
        void updateElLa();
    private:
        QQmlApplicationEngine * _engine;
        QJsonObject _data;
        QList<ElLa*> *_ellaList;
        QList<Cyclone*>* _cyclones;
        bool _isLast;
};
#endif // MYTHREAD_H
