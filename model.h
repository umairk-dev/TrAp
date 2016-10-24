#ifndef MODEL_H
#define MODEL_H

#include <QObject>
#include <QtQuick>
#include <QQmlListProperty>
class Model : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString modelName READ getModelName WRITE setModelName)
    Q_PROPERTY(QString modelData READ getModelData WRITE setModelData)
    Q_PROPERTY(QString modelID READ getModelID WRITE setModelID)
    Q_PROPERTY(QVariantList variables READ getDataList WRITE setDataList)

public:
    explicit Model(QObject *parent = 0);
    QString getModelName() const;
    QString getModelData() const;
    QString getModelID() const;
    QVariantList getDataList() const;

    void setModelName(const QString &);
    void setModelData(const QString &);
    void setModelID(const QString &);
    void setDataList(const QVariantList &);
signals:

public slots:


private:
        QString modelName;
        QString modelData;
        QString modelID;
        QVariantList dataList;
};

#endif // MODEL_H
