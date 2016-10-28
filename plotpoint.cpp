#include "plotpoint.h"

PlotPoint::PlotPoint(QObject *parent) : QObject(parent)
{


}


void PlotPoint::setX(const double & _x){
    x = _x;
}


void PlotPoint::setY(const double & _y){
    y = _y;
}

double PlotPoint::getX() const{
    return x;
}

double PlotPoint::getY() const{
    return y;
}
