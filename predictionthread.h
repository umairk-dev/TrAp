#ifndef PREDICTIONTHREAD_H
#define PREDICTIONTHREAD_H
#include <QThread>
#include "prediction.h"

class PredictionThread : public QThread
{

    Q_OBJECT
public:
    PredictionThread(Prediction *prediction);
    protected:
        void run();
    private:
        Prediction *prediction;
};

#endif // PREDICTIONTHREAD_H
