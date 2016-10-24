#ifndef PREDICTION_H
#define PREDICTION_H

#include <QObject>
#include <QLibrary>
#include <QtNetwork>
#include <QHash>
#include "dbmanager.h"
#include <QQmlApplicationEngine>

class Prediction : public QObject
{
    Q_OBJECT
public:
    explicit Prediction(QObject *parent = 0);

    Q_INVOKABLE  void setEngine(QQmlApplicationEngine *engine);

    Q_INVOKABLE  QQmlApplicationEngine * getEngine();
signals:

public slots:
    void searchServiceFinished(QNetworkReply* reply);
    void predictCyclones(const QString &lat1, const QString &lng1,const QString &lat2, const QString &lng2, const QString& mid, const QString& burnin, const QString& update);


    QHash<QString, int> getYearCount();
    void setYearCount(QHash<QString, int> yearsCount);
    double getFromLat();
    double getToLat();
    double getFromLng();
    double getToLng();

    void setFromLat(double lat);
    void setToLat(double lat);
    void setFromLng(double lng);
    void setToLng(double lng);
    void generateData();
    void doPrdiction(int year);
private:
    void predict(const QString& name);
    void initDir();
    void loadModel(QString modelID);
    void loadData();
    void initYearCount();
    void _CharArray(QString cmd, QString arg);
    void _CmdInterpreter(std::string cmd);
    void _BugsCmd(std::string cmd);
    QLibrary lib;
    QString modelFile;// = "modelFile.txt";
    QString dataFile; //= "data.txt";
    QString numChains;// = "2";
    QString nBurnin; //= "1000";
    QString nIter; //= "2000";
    QString nThin; //= "2";
    QString overRelax; //= "0";
    QString path;
    double fromLat;
    double toLat;
    double fromLng;
    double toLng;
    QString _modelID;
    QString _burnIn;
    QString _update;
    QHash<QString, int> yearsCount;
    QQmlApplicationEngine *engine;
};

#endif // PREDICTION_H
