#include <QApplication>
#include <QQmlApplicationEngine>
#include <QtWebView/QtWebView>
#include <QQmlContext>
#include "controls.h"
#include <QQuickWindow>

#if defined Q_OS_BLACKBERRY || defined Q_OS_ANDROID || defined Q_OS_IOS || defined Q_OS_WP
#define Q_OS_MOBILE
#else
#define Q_OS_DESKTOP
#endif
int main(int argc, char *argv[])
{
    QApplication app(argc, argv);
    QtWebView::initialize();
    Controls control;

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    control.setEngine(&engine);


    QObject *topLevel = engine.rootObjects().value(0);
    QQuickWindow *window = qobject_cast<QQuickWindow *>(topLevel);



    // connect our QML signal to our C++ slot
    QObject::connect(topLevel, SIGNAL(submitTextField(QString)),
    &control, SLOT(handleSubmitTextField(QString)));

    //connect c++ to qml for sending data
    QObject::connect(&control, SIGNAL(setTextField(QVariant)),
    topLevel, SLOT(setTextField(QVariant)));



    QQmlContext *context = engine.rootContext();
    //For android*****************
    #ifdef  Q_OS_MOBILE
    QString helpHTMLFile = QStandardPaths::writableLocation(QStandardPaths::TempLocation);
    helpHTMLFile.append(QDir::separator());
    helpHTMLFile.append("map.html");
    QFile(helpHTMLFile).remove();
    QFile(":/map.html").copy(helpHTMLFile);
    context->setContextProperty(QStringLiteral("initialUrl"),
                                   "file:///"+helpHTMLFile);

    #endif
    //*********************
    #ifdef Q_OS_DESKTOP
    context->setContextProperty(QStringLiteral("initialUrl"),
                                QUrl(QStringLiteral("qrc:/map.html")));
    #endif

    context->setContextProperty("Controls", &control);

    return app.exec();
}
