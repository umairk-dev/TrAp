#ifndef PLOTPOINT_H
#define PLOTPOINT_H

#include <QObject>

class PlotPoint : public QObject
{
    Q_OBJECT
    Q_PROPERTY(double x READ getX WRITE setX)
    Q_PROPERTY(double y READ getY WRITE setY)
public:
    explicit PlotPoint(QObject *parent = 0);
    double getX() const;
    double getY() const;

    void setX(const double &);
    void setY(const double &);
signals:

public slots:

private:

    double x;
    double y;
};

#endif // PLOTPOINT_H
