#ifndef FILEDIALOGBOX_H
#define FILEDIALOGBOX_H

#include <QWidget>
#include <QFileDialog>
class FileDialogBox : public QWidget
{
    Q_OBJECT
public:
    explicit FileDialogBox(QWidget *parent = 0);
    QString saveFile();
signals:

public slots:

private :
    QFileDialog * dlgFile;
};

#endif // FILEDIALOGBOX_H
