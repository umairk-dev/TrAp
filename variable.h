#ifndef VARIABLE_H
#define VARIABLE_H

#include <QObject>

class Variable : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int dataID READ getDataID WRITE setDataID)
    Q_PROPERTY(QString dataName READ getDataName WRITE setDataName)
    Q_PROPERTY(QString dataValue READ getDataValue WRITE setDataValue)
    Q_PROPERTY(QString dataType READ getDataType WRITE setDataType)
public:
    explicit Variable(QObject *parent = 0);

    int getDataID() const;
    QString getDataName() const;
    QString getDataValue() const;
    QString getDataType() const;

    void setDataID(const int &);
    void setDataName(const QString &);
    void setDataValue(const QString &);
    void setDataType(const QString &);

signals:

public slots:

private:

    int dataID;
    QString dataName;
    QString dataValue;
    QString dataType;

};

#endif // VARIABLE_H
