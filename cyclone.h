#ifndef CYCLONE_H
#define CYCLONE_H

#include <QObject>
#include <QtQuick>
#include <QQmlListProperty>

class Cyclone : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString cycloneName READ getCycloneName WRITE setCycloneName)
    Q_PROPERTY(QString cycloneID READ getCycloneID WRITE setCycloneName)
    Q_PROPERTY(QString basin READ getBasin WRITE setBasin)
    Q_PROPERTY(QString subBasin READ getSubBasin WRITE setSubBasin)
    Q_PROPERTY(QString seasonYear READ getSeasonYear WRITE setSeasonYear)
    Q_PROPERTY(QVariantList tracks READ getTracks WRITE setTracks)

public:
    Cyclone(QObject *parent = 0);
    QString getCycloneName() const;
    QString getCycloneID() const;
    QString getBasin() const;
    QString getSubBasin() const;
    QString getSeasonYear() const;
    QVariantList getTracks() const;

    void setCycloneName(const QString &);
    void setCycloneID(const QString &);
    void setBasin(const QString &);
    void setSubBasin(const QString &);
    void setSeasonYear(const QString &);
    void setTracks(const QVariantList &);

private:
        QString cycloneName;
        QString cycloneID;
        QString basin;
        QString subBasin;
        QString seasonYear;
        QString num;
        QVariantList tracks;
signals:

public slots:
};

//Q_DECLARE_METATYPE(Cyclone);
#endif // CYCLONE_H
