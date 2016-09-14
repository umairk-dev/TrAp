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


QString Cyclone::getSeasonYear() const
{
    return seasonYear;
}

QString Cyclone::getNum() const
{
    return num;
}

QString Cyclone::getSource() const
{
    return source;
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





void Cyclone::setSeasonYear(const QString &n)
{
    seasonYear = n;
}

void Cyclone::setSource(const QString &n)
{
    source = n;
}


void Cyclone::setNum(const QString &n)
{
    num = n;
}






