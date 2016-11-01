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

     int count = 0;
     int year = 1970;
     for(int i = 0; i <= data.size(); i++){
          count += prediction->getYearCount().value(QString::number(year));
          year++;
     }


     if(count> 5){
        prediction->generateData();
        prediction->doPrdiction(2016);
     }

}
