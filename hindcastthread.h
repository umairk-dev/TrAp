#ifndef HINDCASTTHREAD_H
#define HINDCASTTHREAD_H
#include <QThread>
#include "plotpoint.h"
#include "prediction.h"
#include "mathexpr.h"
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
        void freeMemory();
        QVariantList hindcastResult;

};

#endif // HINDCASTTHREAD_H
