#ifndef CONTROLS_H
#define CONTROLS_H

#include <QQmlApplicationEngine>
#include <QObject>
#include <QQuickItem>
#include <QWidget>

class Controls : public QWidget
{
    Q_OBJECT
public:
    explicit Controls(QWidget  *parent = 0);
    Q_INVOKABLE  void onHello();
     Q_INVOKABLE  void setEngine(QQmlApplicationEngine *engine);


signals:
 void setTextField(QVariant text);

private:
     QQmlApplicationEngine* _engine;
public slots:
      void handleSubmitTextField(const QString& in);

};

#endif // CONTROLS_H
