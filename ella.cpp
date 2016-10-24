#include "ella.h"

ElLa::ElLa(QObject *parent) : QObject(parent)
{

}



int ElLa::getYear(){
    return year;
}

int ElLa::getMonth(){
    return month;
}

double ElLa::getValue(){
    return value;
}

QString ElLa::getColor(){
    return color;
}

void ElLa::setYear(int year){
    this->year = year;
}

void ElLa::setMonth(int month){
    this->month = month;
}

void ElLa::setValue(double value){
    this->value = value;
}

void ElLa::setColor(QString color){
    this->color = color;
}
