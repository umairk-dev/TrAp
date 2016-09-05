#ifndef UTILS_H
#define UTILS_H

#include <QObject>
#include <QQuickItem>
#include <QWidget>

class Utils : public QObject
{
    Q_OBJECT

private:

public:
    explicit Utils(QObject  *parent = 0);



signals:
    void showTrackInfo(QVariant, QVariant, QVariant);
private:
     QVariant mapPoints;

public


     slots:

     void setMapPoints(const  QVariant mapPoints);
     void selectMapItem(QPointF select, QVariant points);
      //void getWebView(QWebEngineView * view);

};

#endif
