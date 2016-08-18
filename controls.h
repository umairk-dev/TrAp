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
    void serviceRequestFinished(QNetworkReply* reply);
public:
    explicit Controls(QObject  *parent = 0);
    Q_INVOKABLE  void onHello();
    Q_INVOKABLE  void setEngine(QQmlApplicationEngine *engine);

signals:
    void setTextField(QVariant text);

private:
     QQmlApplicationEngine* _engine;
public slots:
      void handleSubmitTextField(const QString& in);
      void searchCyclone(const QString& name);
};

#endif // CONTROLS_H
