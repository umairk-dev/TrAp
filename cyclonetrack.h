#ifndef CYCLONETRACK_H
#define CYCLONETRACK_H

#include <QObject>

class CycloneTrack : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int trackID READ getTrackID WRITE setTrackID)
    Q_PROPERTY(double latitude READ getLatitude WRITE setLatitude)
    Q_PROPERTY(double longitude READ getLongitude WRITE setLongitude)
    Q_PROPERTY(double pressure READ getPressure WRITE setPressure)
    Q_PROPERTY(double windSpeed READ getWindSpeed WRITE setWindSpeed)
    Q_PROPERTY(QString dateTime READ getDateTime WRITE setDateTime)
    Q_PROPERTY(QString nature READ getNature WRITE setNature)
    Q_PROPERTY(QString cycloneID READ getCycloneID WRITE setCycloneID)
    Q_PROPERTY(QString basin READ getBasin WRITE setBasin)
    Q_PROPERTY(QString subBasin READ getSubBasin WRITE setSubBasin)

public:
    CycloneTrack(QObject *parent = 0);
    int getTrackID() const;
    double getLatitude() const;
    double getLongitude() const;
    double getPressure() const;
    double getWindSpeed() const;
    QString getDateTime() const;
    QString getCycloneID() const;
    QString getNature() const;
    QString getBasin() const;
    QString getSubBasin() const;

    void setTrackID(const int &);
    void setCycloneID(const QString &);
    void setLatitude(const double &);
    void setLongitude(const double &);
    void setPressure(const double &);
    void setWindSpeed(const double &);
    void setDateTime(const QString &);
    void setNature(const QString &);
    void increaseAccuracy();
    void setBasin(const QString &);
    void setSubBasin(const QString &);

private:
        QString cycloneID;
        int trackID;
        double latitude;
        double longitude;
        double pressure;
        double windSpeed;
        QString dateTime;
        QString nature;
        QString basin;
        QString subBasin;


signals:

public slots:
};

#endif // CYCLONETRACK_H
