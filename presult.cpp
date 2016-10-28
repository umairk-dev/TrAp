#include "presult.h"

PResult::PResult(QObject *parent) : QObject(parent)
{

}


QVariantList PResult::getResult() const
{
    return result;
}

void PResult::setResult(const QVariantList &n)
{
    result = n;
}
