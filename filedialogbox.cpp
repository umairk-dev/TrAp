#include "filedialogbox.h"
#include <QFileDialog>

#include <QQuickItem>
FileDialogBox::FileDialogBox(QWidget *parent) : QWidget(parent)
{
    dlgFile = new QFileDialog();
    //QThread * th = new QThread();

  //  dlgFile->open();
  //  dlgFile->close();

}


QString FileDialogBox::saveFile()
  {



    QString filename = dlgFile->getSaveFileName(
        this,
        tr("Export Data"),
        QDir::currentPath(),
        tr("Text File (*.txt)") );
    if( !filename.isNull() )
    {
      qDebug() <<  filename ;
    }

    return filename;
  }
