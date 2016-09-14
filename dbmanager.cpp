#include "dbmanager.h"

DbManager::DbManager(QObject  *parent) : QObject (parent)
{

    db = QSqlDatabase::addDatabase("QSQLITE");
    db.setDatabaseName( QStringLiteral("qrc:/trapDB.db3"));// QDir::homePath() + QDir::separator() + "qrc:/trapDB.db3");
    qDebug() << QDir::homePath() + QDir::separator() + "trapDB.db3";
    if (db.open()) {
    QSqlQuery query(db);
    if (query.exec("CREATE TABLE IF NOT EXISTS cyclone ( INTEGER cycloneID PRIMARY KEY);")) {
    qDebug() << "table created";
    } else {
    qDebug() << "error table creation" << query.lastError();
    }
    } else {
        qDebug() << "No DB";
    }
    db.close();
}
