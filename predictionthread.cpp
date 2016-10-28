#include "predictionthread.h"

#include "prediction.h"
PredictionThread::PredictionThread(Prediction *prediction)
{
    this->prediction = prediction;
}


void PredictionThread::run()
{

    prediction->getYearCount().clear();

    DbManager db = DbManager::get();
    db.setEngine(prediction->getEngine());

    QHash<QString, int> data = db.searchArea(prediction->getFromLat(),prediction->getFromLng(), prediction->getToLat(), prediction->getToLng());
    prediction->setYearCount(data);

    /*  for(int i = 1950; i <= 2016; i++){
            qDebug()<<i <<" - "<<prediction->getYearCount().value(QString::number(i))<<endl;
        }
    */


    prediction->generateData();

    prediction->doPrdiction(2016);

}
