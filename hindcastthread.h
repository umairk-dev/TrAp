#ifndef HINDCASTTHREAD_H
#define HINDCASTTHREAD_H
#include <QThread>
#include "prediction.h"
#include "presult.h"
class HindcastThread : public QThread
{

    Q_OBJECT
    public:
        HindcastThread(Prediction *prediction);
    protected:
        void run();
    private:
        Prediction *prediction;
        QList<QString> * getMonitorValues(QString name);
        void saveResult(int year, QList<double>* data);
        PResult *  processLambda(int year, QList<double>* data);
        int roundLambda(double);
        void doHindcast();
};

#endif // HINDCASTTHREAD_H
