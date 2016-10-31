#ifndef FORECASTTHREAD_H
#define FORECASTTHREAD_H
#include <QThread>
#include "prediction.h"
#include "presult.h"
#include "mathexpr.h"
#include "presult.h"

class ForecastThread : public QThread
{

public:
    ForecastThread(Prediction *prediction);
protected:
    void run();
private:
    Prediction *prediction;
    QList<QString> * getMonitorValues(QString name);
    void saveResult(int year, QList<double>* data);
    PResult *  processLambda(int year, QList<double>* data);
    int roundLambda(double);
    void doForecast();
    void freeMemory();
    QVariantList forecastResult;

};

#endif // FORECASTTHREAD_H
