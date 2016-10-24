#include "UpdateThread.h"
#include "cyclone.h"
#include "cyclonetrack.h"
#include "dbmanager.h"

UpdateThread::UpdateThread( QQmlApplicationEngine * engine,QList<Cyclone*>* cyclones, bool isLast){

    _engine = engine;
    _isLast = isLast;
    _cyclones = cyclones;
    _ellaList = NULL;
}


UpdateThread::UpdateThread( QQmlApplicationEngine * engine,QList<ElLa*>* ellaList){
     _engine = engine;
     _ellaList = ellaList;
     _cyclones = NULL;
}

void UpdateThread::run()
{
      if(_cyclones != NULL && _cyclones->size()>0){
          updateCyclones();
      }else if(_ellaList != NULL && _ellaList->size()>0){
            updateElLa();
      }

}

void UpdateThread::updateElLa()
{


    DbManager db = DbManager::get();
    db.setEngine(this->_engine);

    for(int i = 0; i < _ellaList->size(); i++)
        db.addElLa(_ellaList->at(i));

    delete _ellaList;
}



void UpdateThread::updateCyclones()
{

    DbManager db = DbManager::get();

    db.setEngine(this->_engine);

    for(int i = 0; i < _cyclones->size(); i++){
        qDebug() << "Adding cyclone ";

        db.addCyclone(_cyclones->at(i));
        db.addTracks(_cyclones->at(i)->getTracks());


    }


    //delete _cyclones;
    if(_isLast){
         QObject * mapView = _engine->rootObjects().at(0)->findChild<QObject*>("map");

         QString msg = "";
         if(mapView && !QMetaObject::invokeMethod(mapView, "showStatus", Q_ARG(QVariant, QVariant::fromValue(msg))))
             qDebug() << "Failed to invoke showStatus";
    }




  //  delete this;
}





