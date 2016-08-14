#include "controls.h"
#include <QtGui>
#include <QtQuick>
#include <QDialog>


Controls::Controls(QObject  *parent) : QObject (parent)
{

}


void Controls::onHello(){

}


void Controls::setEngine(QQmlApplicationEngine * engine){

    _engine = engine;


}


void Controls::handleSubmitTextField(const QString &in)
{
    qDebug() << "c++: HandleTextField::handleSubmitTextField:" << in;
    emit setTextField(in.toUpper());
}
