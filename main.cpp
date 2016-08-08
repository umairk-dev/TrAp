#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QtWebView/QtWebView>
#if defined Q_OS_BLACKBERRY || defined Q_OS_ANDROID || defined Q_OS_IOS || defined Q_OS_WP
#define Q_OS_MOBILE
#else
#define Q_OS_DESKTOP
#endif
int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    QtWebView::initialize();

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
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


    return app.exec();
}
