#include "cyclonetrack.h"

CycloneTrack::CycloneTrack(QObject *parent) : QObject(parent)
{

}


QString CycloneTrack::getTrackID() const
{
    return trackID;
}


QString CycloneTrack::getCycloneID() const
{
    return cycloneID;
}


QString CycloneTrack::getLongitude() const
{
    return longitude;
}


QString CycloneTrack::getLatitude() const
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


QString CycloneTrack::getPressure() const
{
    return pressure;
}


QString CycloneTrack::getWindSpeed() const
{
    return windSpeed;
}

void CycloneTrack::setTrackID(const QString &n)
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


void CycloneTrack::setLatitude(const QString &n)
{
    latitude = n;
}


void CycloneTrack::setLongitude(const QString &n)
{
    longitude = n;
}

void CycloneTrack::setWindSpeed(const QString &n)
{
    windSpeed = n;
}


void CycloneTrack::setDateTime(const QString &n)
{
    dateTime = n;
}



void CycloneTrack::setPressure(const QString &n)
{
    pressure = n;
}
