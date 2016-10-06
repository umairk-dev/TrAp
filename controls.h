#ifndef CONTROLS_H
#define CONTROLS_H
#include <QtNetwork>
#include <QQmlApplicationEngine>
#include <QObject>
#include <QQuickItem>
#include <QWidget>

class Controls : public QObject
{
    Q_OBJECT

private:
       void delay();
public:
    explicit Controls(QObject  *parent = 0);
    Q_INVOKABLE  void onHello();
    Q_INVOKABLE  void setEngine(QQmlApplicationEngine *engine);
    QString resrtucturePara(const QVariant &multiplePara);
signals:
    void setTextField(QVariant text);

private:
     QQmlApplicationEngine* _engine;

public


     slots:
     void clearMap();
     void controlMapMouse(const bool& status);
     void handleSubmitTextField(const QString& in);
     void searchCycloneByName(const QString& name);
     void searchCycloneByYear(const QString& year);
     void searchCycloneByYears(const QString& yearFrom, const QString& yearTo);
     void searchCycloneByWind(const QString& windFrom, const QString& windTo);
     void searchCycloneByPressure(const QString& pressureFrom, const QString& pressureTo);
     void searchCycloneByArea(const QString &lat1, const QString &lng1,const QString &lat2,const QString &lng2);
     void searchCycloneByMultiPara(const QVariant& multiplePara);
     void searchCycloneServiceFinished(QNetworkReply* reply);
     void generateReport(const QString &path, const QVariant &cyclones);

      //void getWebView(QWebEngineView * view);

};

#endif // CONTROLS_H
