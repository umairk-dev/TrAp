#ifndef SETTINGS_H
#define SETTINGS_H

#include <QObject>


class settings: public QObject
{
    Q_OBJECT
public:
    settings();
    settings(QObject  *parent = 0);
   
    ~settings();

};

#endif // SETTINGS_H
