#include "model.h"

Model::Model(QObject *parent) : QObject(parent)
{

}

QString Model::getModelName() const{
    return modelName;
}

QString Model::getModelData() const{
    return modelData;
}

QString Model::getModelID() const{
    return modelID;
}

void Model::setModelName(const QString & name){
    modelName = name;
}

void Model::setModelData(const QString & data){
    modelData = data;
}

void Model::setModelID(const QString & id){
    modelID = id;
}

QVariantList Model::getDataList() const{
    return dataList;
}

void Model::setDataList(const QVariantList & data){
    dataList = data;
}
