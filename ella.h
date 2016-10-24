#ifndef ELLA_H
#define ELLA_H

#include <QObject>

class ElLa : public QObject
{
    Q_OBJECT
public:
    explicit ElLa(QObject *parent = 0);
    int getYear();
    int getMonth();
    double getValue();
    QString getColor();

    void setYear(int);
    void setMonth(int);
    void setValue(double);
    void setColor(QString);
signals:

public slots:



private:

    int year;
    int month;
    double value;
    QString color;

};

#endif // ELLA_H
