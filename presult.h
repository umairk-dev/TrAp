#ifndef PRESULT_H
#define PRESULT_H

#include <QObject>

#include <QtQuick>
#include <QQmlListProperty>
class PResult : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QVariantList result READ getResult WRITE setResult)

public:
    explicit PResult(QObject *parent = 0);

    void setResult(const QVariantList &);

    QVariantList getResult() const;
signals:

public slots:

private:

     QVariantList result;
};

#endif // PRESULT_H
