#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QtWebView/QtWebView>
#include <QQmlContext>
#include "controls.h"
#include <QQuickWindow>
#include <QDir>
#include <QString>
#include <QStandardPaths>
#include <QScreen>
#if defined Q_OS_BLACKBERRY || defined Q_OS_ANDROID || defined Q_OS_IOS || defined Q_OS_WP
#define Q_OS_MOBILE
#else
#define Q_OS_DESKTOP
#endif
int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    QtWebView::initialize();
    Controls control;


    QScreen * screen = app.primaryScreen();
    int width = screen->availableSize().width();
    int height = screen->availableSize().height();


    QQmlApplicationEngine engine;
    control.setEngine(&engine);


    QQmlContext *context = engine.rootContext();
    //For android*****************
    #ifdef  Q_OS_MOBILE
    QString helpHTMLFile = QStandardPaths::writableLocation(QStandardPaths::TempLocation);
    helpHTMLFile.append(QDir::separator());
    helpHTMLFile.append("map.html");
    QFile(helpHTMLFile).remove();
    QFile(":/map.html").copy(helpHTMLFile);
    context->setContextProperty("initialUrl",
                                   "file:///"+helpHTMLFile);
    context->setContextProperty(QStringLiteral("platform"),
                           "1");
    #else
        context->setContextProperty(QStringLiteral("initialUrl"),
                                QUrl(QStringLiteral("qrc:/map.html")));
        context->setContextProperty(QStringLiteral("platform"),
                                "2");
    #endif

    context->setContextProperty("Controls", &control);
    context->setContextProperty(QStringLiteral("screenWidth"),
                            width);
    context->setContextProperty(QStringLiteral("screenHeight"),
                            height);

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));


    QObject *topLevel = engine.rootObjects().value(0);
    QQuickWindow *window = qobject_cast<QQuickWindow *>(topLevel);



    // connect our QML signal to our C++ slot
    QObject::connect(window, SIGNAL(submitTextField(QString)),
    &control, SLOT(handleSubmitTextField(QString)));

    //connect c++ to qml for sending data
    QObject::connect(&control, SIGNAL(setTextField(QVariant)),
    window, SLOT(setTextField(QVariant)));


    return app.exec();
}
