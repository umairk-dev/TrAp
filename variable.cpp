#include "variable.h"

Variable::Variable(QObject *parent) : QObject(parent)
{

}


int Variable::getDataID() const{
    return dataID;
}


QString Variable::getDataName() const{
    return dataName;
}

QString Variable::getDataValue() const{
    return dataValue;
}

QString Variable::getDataType() const{
    return dataType;
}

void Variable::setDataName(const QString & name){
    dataName = name;
}

void Variable::setDataValue(const QString & value){
    dataValue = value;
}


void Variable::setDataType(const QString & value){
    dataType = value;
}

void Variable::setDataID(const int & ID){
    dataID = ID;
}


