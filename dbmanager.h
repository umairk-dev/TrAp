#ifndef DBMANAGER_H
#define DBMANAGER_H
#include <QtSql/QtSql>
#include <QHash>
#include <QList>
#include "cyclone.h"
#include "cyclonetrack.h"
#include "ella.h"
#include "model.h"
#include "variable.h"
class DbManager
{

    DbManager();
 //   DbManager(const DbManager &);
    void createTblModel();
    void createTblVersion();
    void createTblCyclone();
    void createTblCycloneTrack();
    void createTblElninoLanina();

public:
//    DbManager(QObject  *parent = 0);
    static DbManager &get();
    QString getModel(QString mid);
    void updateDB();
    void clearDB();
    int getVersion();
    void setMapView(QObject * mapView);
    void updateVersion(int v);
    bool checkCyclone(QString id);
    bool checkElLa(int year, int month);
    void addCyclone(Cyclone *cyclones);
    void addTracks(QVariantList tracks);
    bool  addElLa(ElLa* ella);
    QList<ElLa*> getElLa(int month);

    QObject * mapView;
    QQmlApplicationEngine* _engine;
    QHash<QString, int> searchArea(double latFrom, double lngFrom,double latTo, double lngTo);
    Q_INVOKABLE  void setEngine(QQmlApplicationEngine *engine);
    ~DbManager();

    void getModelList();
    void updateModel(Model * model);
    QString getInitList(int modelID);
    QString getDataList(int modelID);
    QStringList getMonitorList(int modelID);
    void updateData(Variable * data, int modelID);

private:
    QSqlDatabase db;
};
#endif // DBMANAGER_H
