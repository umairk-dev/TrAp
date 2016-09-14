#include "cyclonetrack.h"
#include <QtMath>
CycloneTrack::CycloneTrack(QObject *parent) : QObject(parent)
{

}


int CycloneTrack::getTrackID() const
{
    return trackID;
}


QString CycloneTrack::getCycloneID() const
{
    return cycloneID;
}

QString CycloneTrack::getBasin() const
{
    return basin;
}

QString CycloneTrack::getSubBasin() const
{
    return subBasin;
}


double CycloneTrack::getLongitude() const
{
    return longitude;
}


double CycloneTrack::getLatitude() const
{
    return latitude;
}


QString CycloneTrack::getNature() const
{
    return nature;
}

QString CycloneTrack::getDateTime() const
{
    return dateTime;
}


double CycloneTrack::getPressure() const
{
    return pressure;
}


double CycloneTrack::getWindSpeed() const
{
    return windSpeed;
}

void CycloneTrack::setTrackID(const int &n)
{
    trackID = n;
}


void CycloneTrack::setCycloneID(const QString &n)
{
    cycloneID = n;
}


void CycloneTrack::setNature(const QString &n)
{
    nature = n;
}


void CycloneTrack::setLatitude(const double &n)
{
    latitude = n;
}


void CycloneTrack::setLongitude(const double &n)
{
    longitude = n;
}

void CycloneTrack::setWindSpeed(const double &n)
{
    windSpeed = n;
}


void CycloneTrack::setDateTime(const QString &n)
{
    dateTime = n;
}



void CycloneTrack::setPressure(const double &n)
{
    pressure = n;
}


void CycloneTrack::setBasin(const QString &n)
{
    basin = n;
}



void CycloneTrack::setSubBasin(const QString &n)
{
    subBasin = n;
}



void CycloneTrack::increaseAccuracy(){
    //Earth’s radius, sphere
     int R = 6378137;

     //offsets in meters
     int dn = 100;
     int de = 100;

     //Coordinate offsets in radians
     double dLat = dn/R;

     double dLon = de/(R*qCos((M_PI * getLatitude()) /180));

     //OffsetPosition, decimal degrees
     setLatitude(getLatitude() + dLat * 180/M_PI);
     setLongitude(getLongitude() + dLon * 180/M_PI);


}
