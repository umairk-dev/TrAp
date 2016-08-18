#ifndef CYCLONE_H
#define CYCLONE_H

#include <QObject>

class Cyclone : public QObject
{
    Q_OBJECT
public:
    explicit Cyclone(QObject *parent = 0);
    QString cycloneName;
    QString cycloneID;
    QString basin;
    QString sub_basin;
    QString seasonYear;
    QString num;
signals:

public slots:
};

#endif // CYCLONE_H
