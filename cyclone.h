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
    Q_PROPERTY(QString seasonYear READ getSeasonYear WRITE setSeasonYear)
    Q_PROPERTY(QString num READ getNum WRITE setNum)
    Q_PROPERTY(QString source READ getSource WRITE setSource)
    Q_PROPERTY(QVariantList tracks READ getTracks WRITE setTracks)

public:
    Cyclone(QObject *parent = 0);
    QString getCycloneName() const;
    QString getCycloneID() const;
    QString getSeasonYear() const;
    QVariantList getTracks() const;
    QString getSource() const;
    QString getNum() const;

    void setCycloneName(const QString &);
    void setCycloneID(const QString &);
    void setSeasonYear(const QString &);
    void setTracks(const QVariantList &);
    void setSource(const QString &);
    void setNum(const QString &);

private:
        QString cycloneName;
        QString cycloneID;
        QString seasonYear;
        QString source;
        QString num;
        QVariantList tracks;
signals:

public slots:
};

//Q_DECLARE_METATYPE(Cyclone);
#endif // CYCLONE_H
