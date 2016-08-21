#include "cyclone.h"

Cyclone::Cyclone(QObject *parent) : QObject(parent)
{

}



QString Cyclone::getCycloneName() const
{
    return cycloneName;
}


QString Cyclone::getCycloneID() const
{
    return cycloneID;
}

QString Cyclone::getBasin() const
{
    return basin;
}

QString Cyclone::getSubBasin() const
{
    return subBasin;
}

QString Cyclone::getSeasonYear() const
{
    return seasonYear;
}


QVariantList Cyclone::getTracks() const
{
    return tracks;
}

void Cyclone::setTracks(const QVariantList &n)
{
    tracks = n;
}

void Cyclone::setCycloneName(const QString &n)
{
    cycloneName = n;
}

void Cyclone::setCycloneID(const QString &n)
{
    cycloneID = n;
}


void Cyclone::setBasin(const QString &n)
{
    basin = n;
}



void Cyclone::setSubBasin(const QString &n)
{
    subBasin = n;
}



void Cyclone::setSeasonYear(const QString &n)
{
    seasonYear = n;
}




