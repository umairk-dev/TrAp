#include <QApplication>//<QGuiApplication>
#include <QQmlApplicationEngine>
#include <QtWebView/QtWebView>
#include <QQmlContext>
#include "controls.h"
#include <QQuickWindow>
#include <QDir>
#include <QString>
#include <QStandardPaths>
#include <QScreen>
#include "controls.h"
#include "cyclone.h"
#include "utils.h"
#include "dbmanager.h"

#if defined Q_OS_BLACKBERRY || defined Q_OS_ANDROID || defined Q_OS_IOS || defined Q_OS_WP
#define Q_OS_MOBILE
#else
#define Q_OS_DESKTOP
#endif
int main(int argc, char *argv[])
{
    QApplication app(argc, argv); //QGuiApplication app(argc, argv);123
    qmlRegisterType<Cyclone>("Cyclone", 1,0, "Cyclone");

    QtWebView::initialize();
    Controls control;
    DbManager db;
    Utils utils;

   // qmlRegisterType(Cyclone);
    QLoggingCategory::setFilterRules("qt.network.ssl.w arning=false");//Test 21082016
    QScreen * screen = app.primaryScreen();
    int width = screen->availableSize().width();
    int height = screen->availableSize().height();


    QQmlApplicationEngine engine;
    control.setEngine(&engine);


    QQmlContext *context = engine.rootContext();
    //For android*****************
    #ifdef  Q_OS_MOBILE
   /* QString helpHTMLFile = QStandardPaths::writableLocation(QStandardPaths::TempLocation);
    helpHTMLFile.append(QDir::separator());
    helpHTMLFile.append("map.html");
    QFile(helpHTMLFile).remove();
    QFile(":/map.html").copy(helpHTMLFile);
    context->setContextProperty("initialUrl",
                                   "file:///"+helpHTMLFile);
    */
    context->setContextProperty(QStringLiteral("platform"),
                           "1");
    #else
   //     context->setContextProperty(QStringLiteral("initialUrl"),
     //                           QUrl(QStringLiteral("qrc:/map.html")));
        context->setContextProperty(QStringLiteral("platform"),
                                "2");
    #endif

    context->setContextProperty("Controls", &control);
    context->setContextProperty("Utils", &utils);
    context->setContextProperty(QStringLiteral("screenWidth"),
                            width);
    context->setContextProperty(QStringLiteral("screenHeight"),
                            height);

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

  //  QQmlComponent component(&engine, QUrl(QStringLiteral("qrc:/main.qml")));
    //    QObject *object = component.create();



    QObject *topLevel = engine.rootObjects().value(0);
    QQuickWindow *window = qobject_cast<QQuickWindow *>(topLevel);


    // connect our QML signal to our C++ slot
    QObject::connect(window, SIGNAL(submitTextField(QString)),
    &control, SLOT(handleSubmitTextField(QString)));



    //search signal  - by Name
    QObject::connect(window, SIGNAL(searchByName(QString)),
    &control, SLOT(searchCycloneByName(QString)));


    //search signal  - by Year
    QObject::connect(window, SIGNAL(searchByYear(QString)),
    &control, SLOT(searchCycloneByYear(QString)));

    //search signal  - by Years
    QObject::connect(window, SIGNAL(searchByYears(QString,QString)),
    &control, SLOT(searchCycloneByYears(QString,QString)));

    //search signal  - by Wind
    QObject::connect(window, SIGNAL(searchByWind(QString,QString)),
    &control, SLOT(searchCycloneByWind(QString,QString)));

    //search signal  - by Pressure
    QObject::connect(window, SIGNAL(searchByPressure(QString,QString)),
    &control, SLOT(searchCycloneByPressure(QString,QString)));


    //search signal  - by Area
    QObject::connect(window, SIGNAL(searchByArea(QString,QString,QString,QString)),
    &control, SLOT(searchCycloneByArea(QString,QString,QString,QString)));


    //control signal  - EnableDisable Map Mouse
    QObject::connect(window, SIGNAL(controlMapMouse(bool)),
    &control, SLOT(controlMapMouse(bool)));


    //control signal  - Clear Map
    QObject::connect(window, SIGNAL(clearMap()),
    &control, SLOT(clearMap()));


    //control signal  - Clear Map
    QObject::connect(window, SIGNAL(generateReport(QString,QVariant)),
    &control, SLOT(generateReport(QString,QVariant)));


    //search signal
    //QObject::connect(window, SIGNAL(sendWebView(QWebEngineView)),
    //&control, SLOT(getWebView(QWebEngineView)));



    //connect c++ to qml for sending data
    QObject::connect(&control, SIGNAL(setTextField(QVariant)),
    window, SLOT(setTextField(QVariant)));


    //show track info
  //  QObject::connect(&utils, SIGNAL(showTrackInfo(QVariant, QVariant, QVariant)),
   // window, SLOT(showTrackInfo(QVariant, QVariant, QVariant)));


    QObject *webView = engine.rootObjects().at(0)->findChild<QObject*>("map");
    if(webView)
      {
          qDebug() << "found";

        //  if(!QMetaObject::invokeMethod(webView, "zoomIn"))
       //       qDebug() << "Failed to invoke push";
          //QQmlComponent component(&engine, QStringLiteral("qrc:/Searching.qml"));
          //QObject *object = component.create();
          //QVariant arg = QVariant::fromValue(object);

          //if(!QMetaObject::invokeMethod(stackView, "push",
              //                          Q_ARG(QVariant, arg)))
            //  qDebug() << "Failed to invoke push";
      }else{

        qDebug() << "notfound";

    }



    return app.exec();
}
