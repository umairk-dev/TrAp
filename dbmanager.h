#ifndef DBMANAGER_H
#define DBMANAGER_H
#include <QtSql/QtSql>
#include <QObject>
class DbManager : public QObject
{
    Q_OBJECT
public:
    DbManager(QObject  *parent = 0);

private:
    QSqlDatabase db;
};


#endif // DBMANAGER_H
