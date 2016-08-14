#include "controls.h"
#include <QtGui>
#include <QtQuick>
#include <QDialog>


Controls::Controls(QWidget  *parent) : QWidget (parent)
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
