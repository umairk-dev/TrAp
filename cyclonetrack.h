#ifndef CYCLONETRACK_H
#define CYCLONETRACK_H

#include <QObject>

class CycloneTrack : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString trackID READ getTrackID WRITE setTrackID)
    Q_PROPERTY(QString latitude READ getLatitude WRITE setLatitude)
    Q_PROPERTY(QString longitude READ getLongitude WRITE setLongitude)
    Q_PROPERTY(QString pressure READ getPressure WRITE setPressure)
    Q_PROPERTY(QString windSpeed READ getWindSpeed WRITE setWindSpeed)
    Q_PROPERTY(QString dateTime READ getDateTime WRITE setDateTime)
    Q_PROPERTY(QString nature READ getNature WRITE setNature)
    Q_PROPERTY(QString cycloneID READ getCycloneID WRITE setCycloneID)

public:
    CycloneTrack(QObject *parent = 0);
    QString getTrackID() const;
    QString getLatitude() const;
    QString getLongitude() const;
    QString getPressure() const;
    QString getWindSpeed() const;
    QString getDateTime() const;
    QString getCycloneID() const;
    QString getNature() const;

    void setTrackID(const QString &);
    void setCycloneID(const QString &);
    void setLatitude(const QString &);
    void setLongitude(const QString &);
    void setPressure(const QString &);
    void setWindSpeed(const QString &);
    void setDateTime(const QString &);
    void setNature(const QString &);

private:
        QString cycloneID;
        QString trackID;
        QString latitude;
        QString longitude;
        QString pressure;
        QString windSpeed;
        QString dateTime;
        QString nature;


signals:

public slots:
};

#endif // CYCLONETRACK_H
