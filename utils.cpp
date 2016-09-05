#include "utils.h"
#include <QObject>
#include <QtQuick>
#include <QtMath>
#include "CycloneTrack.h"
Utils::Utils(QObject *parent) : QObject(parent)
{

}

void Utils::selectMapItem(QPointF select, QVariant points){
    //var select = map.fromCoordinate(p)
    //console.log(" p = " + map.fromCoordinate(p))

   //  QVariant pointList;
    //// qDebug() << points.toList().size();
    // if(points.toList().size() > 0)
      //  pointList  = points.toList()[0];

    // if(pointList.toList().size() > 0)
      //  pointList  = pointList.toList()[0];

   //  QPointF point = list.toList()[0].toPointF();
     //qDebug() <<  point;
   // qDebug() << pointList;

    //  QPointF point = list.toList()[0].toPointF();
    // qDebug() <<  point;

     for(int i = 0 ; i < points.toList().size(); i++){

       QPointF point = points.toList()[i].toList()[0].toPointF();
       CycloneTrack * track =  qvariant_cast<CycloneTrack*>(points.toList()[i].toList()[1]);

     //  qDebug() << points.toList()[i].toList()[1];

       if( qFabs(point.x() - select.x()) <=5 && qFabs(point.y() - select.y()) <=5){



         //  var c = getCycloneByID(track->cycloneID)
              QString info = "";//Cyclone Name : " + c.cycloneName + "\n"
              info.append("TrackID : ");
              info.append(QString::number(track->getTrackID()));
              info.append("\nWind Speed : ");
              info.append(QString::number(track->getWindSpeed()));
              info.append("\nPressure : ");
              info.append(QString::number(track->getPressure()));
              info.append("\nLatitude : ");
              info.append(QString::number(track->getLatitude()));
              info.append("\nLongitude : ");
              info.append(QString::number(track->getLongitude()));
              info.append("\nNature : ");
              info.append(track->getNature());
              showTrackInfo(info, select.x(), select.y());

        }

    }
}

void Utils::setMapPoints(const  QVariant mapPoints)
{

   // QVariant list = mapPoints.toList()[0];
   //  QPointF point = list.toList()[0].toPointF();
   // qDebug() <<  point;

    this->mapPoints = mapPoints.toList();

    qDebug() << this->mapPoints;

}
