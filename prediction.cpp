#include "prediction.h"
#include <QLibrary>
#include <QtGui>
#include <QtQuick>
#include <string.h>
#include <QStandardPaths>
#include "dbmanager.h"
#include "cyclone.h"
#include <QDateTime>
#include "predictionthread.h"
#include <QStringList>
#include <signal.h>
#include <math.h>
#include "hindcastthread.h"

Prediction::Prediction(QObject *parent) : QObject(parent)
{
   /* QLibrary lib(QCoreApplication::applicationDirPath() + "/libOpenBUGS.dll");
       if (!lib.load())
           qDebug() << lib.errorString();
       if (lib.load()){
           qDebug() << "library loaded";
           initDir();
   }*/
}


void Prediction::doPrdiction(int year)
{
  //  QString modelFile = "modelFile.txt";
  //  QString dataFile = "data.txt";
    QString numChains = "2";
    QString nBurnin = "1000";
    QString nIter = "2000";
    QString nThin = "2";
    QString overRelax = "0";
    QProcess process;

    QString file = QCoreApplication::applicationDirPath() + "/controlBug.exe";

    file.append(" -p " + QCoreApplication::applicationDirPath() );
    file.append(" -m " + modelFile);
    file.append( " -d " + dataFile);
    file.append( " -d " + QDir::tempPath()+"/d2.txt");
    file.append(" -c 1 ");
    file.append( " -i " + QDir::tempPath()+"/init.txt");
    file.append( " -u " + _update);
    file.append( " -b " + _burnIn);

    DbManager db = DbManager::get();
    QStringList list = db.getMonitorList(_modelID.toInt());
    for(int i = 0; i < list.size(); i++ )
        file.append( " -mo " + list.at(i));

    file.append(" >> temp.txt ");
    qDebug() << file;

    std::system(file.toStdString().c_str());


    FILE * fptr;                    // file holder
            char c;                         // char buffer


   fptr = std::fopen("temp.txt", "r");


   QObject * mapView = engine->rootObjects().at(0)->findChild<QObject*>("map");
   QString msg = "Processing..";

   int count = 0;
   QString str;
   bool isOpen = false;
   if(fptr!=NULL){
        while(1){
            c = fgetc(fptr);
            if(c=='\n'){
                
                
                msg = str;
                if(mapView && !QMetaObject::invokeMethod(mapView, "showStatus", Q_ARG(QVariant, QVariant::fromValue(msg))))
                    qDebug() << "Failed to invoke showStatus";
                qDebug() << str;
                if(str == "\nCODA files written"){
                    count++;    

                    if(count>1 && !isOpen){
                        msg = "";
                        if(mapView && !QMetaObject::invokeMethod(mapView, "showStatus", Q_ARG(QVariant, QVariant::fromValue(msg))))
                            qDebug() << "Failed to invoke showStatus";

                        if(mapView && !QMetaObject::invokeMethod(mapView, "onModelGenerated"))
                            qDebug() << "Failed to invoke onModelGenerated";
                        else
                            qDebug() << "not found";
                        isOpen = true;
                    }
                }else{
                    qDebug() << " not match " << str;

                }
                

                
                str = "";
            }

            if(c!= EOF)
                str.append(c);
            else
                break;
       }
       fclose(fptr);
       remove("temp.txt");
   }


   //load the model
   //_BugsCmd("modelCheck('"+QDir::tempPath().toStdString()+"/model.txt');  ");

   //  qDebug() << "BugsEmbed.ParseGuard;";

  //   _CmdInterpreter("BugsCmds.ParseGuard;");

  //   qDebug() << "BugsEmbed.Parse";

  //   _CmdInterpreter("BugsCmds.Parse;");


  //Load the data
  //   _CmdInterpreter("BugsEmbed.SetFilePath('" + dataFile.toStdString() + "');BugsEmbed.LoadDataGuard;BugsEmbed.LoadData");


}

void Prediction::generateData(){
    dataFile = QDir::tempPath()+"/d.txt";
    QFile file(dataFile);
    file.remove();
    DbManager db = DbManager::get();
    QList<ElLa*> list = db.getElLa(_elSeason.toInt());
    QDateTime local(QDateTime::currentDateTime());
    int current = local.toString("yyyy").toInt();
    if (file.open(QIODevice::WriteOnly | QIODevice::Text)) {
        QTextStream stream(&file);
        int year = 1970;
        stream <<"y[]	Nino34[]"<< '\n';//	TNI[]

        for(int i = 0;i<list.size(); i++){
         //  if(year == current)
         //      stream <<"NA"<<"	"<<list.at(i)->getValue()<<'\n';//<<"	0"
         //   else
              stream <<yearsCount[QString::number(year)]<<"	"<<list.at(i)->getValue()<< '\n';//<<"	0"<< '\n';
           year++;
        }
        stream <<"END";
    }
    
    file.close();

   // Variable * N = new Variable;
   // N->setDataName("N");
   // N->setDataValue(QString::number(list.size()));
   // db.updateData(N, _modelID.toInt());

    QString dataFile2 = QDir::tempPath()+"/d2.txt";
    QFile file2(dataFile2);
    file2.remove();
    if (file2.open(QIODevice::WriteOnly | QIODevice::Text)) {
        QTextStream stream(&file2);
       // qDebug()<<list.size();
        stream <<"list(N = "<<list.size()<<","<<db.getDataList(_modelID.toInt())<< '\n'<<"END";
        //"list(N = "<<list.size()<<", lower = 0.80, upper = 0.95)"
    }

    file2.close();


    QString initFile = QDir::tempPath()+"/init.txt";
    QFile file3(initFile);
    file3.remove();
    if (file3.open(QIODevice::WriteOnly | QIODevice::Text)) {
        QTextStream stream(&file3);
        qDebug()<<list.size();
        stream <<db.getInitList(_modelID.toInt())<< '\n'<<"END";
        //"list(N = "<<list.size()<<", lower = 0.80, upper = 0.95)"
    }

    file3.close();
}

void Prediction::loadData(){
    dataFile = QDir::tempPath()+"d.txt";
    QFile file(modelFile);
    if (file.open(QIODevice::ReadWrite)) {
        QTextStream stream(&file);
        DbManager db = DbManager::get();
       // stream << db.getModel();
    }
    file.close();
}

void Prediction::loadModel(QString mid){
    modelFile = QDir::tempPath()+"/m.txt";
    QFile file(modelFile);
    if (file.open(QIODevice::ReadWrite)) {
        QTextStream stream(&file);
        DbManager db = DbManager::get();
        stream << db.getModel(mid)->getModelData();
    }

    //Check the model
}

void Prediction::predict(const QString& name){


}


void Prediction::initDir(){

    //Set directories
    typedef void (*SETDIR_ptr) (std::string*, int*);
    SETDIR_ptr SetWorkingDir = (SETDIR_ptr)QLibrary::resolve("i:/qt/TrAp/libOpenBUGS.dll","SetWorkingDir");
    if (!SetWorkingDir) {
        qDebug()<<"Unable to link to function SetWorkingDir\n";
    }

    SETDIR_ptr SetTempDir = (SETDIR_ptr)QLibrary::resolve("i:/qt/TrAp/libOpenBUGS.dll","SetTempDir");
    if (!SetTempDir) {
        qDebug() << "Unable to link to function SetTempDir\n";
    }

    path = QDir::tempPath();
    qDebug() << path;

  //  char* cpath;
    std::string spath = path.toStdString();
    //cpath = new char [spath.size()+1];
    //strcpy( cpath, spath.c_str() );

   // qDebug()<< cpath;
    int len = path.length();
    SetWorkingDir(&spath, &len);
    SetTempDir(&spath, &len);

}

void Prediction::predictCyclones(const QString &lat1, const QString &lng1,const QString &lat2, const QString &lng2, const QString& mid, const QString& burnin, const QString& update, const QString& elSeason)
{
       qDebug() << "Predict";
       fromLat = lat1.toDouble();
       fromLng = lng1.toDouble();
       toLat = lat2.toDouble();
       toLng = lng2.toDouble();
       _modelID = mid;
       _update = update;
       _burnIn = burnin;
       _elSeason = elSeason;
       loadModel(mid);



       PredictionThread *  thread = new PredictionThread(this);

       thread->start();
     /* QNetworkAccessManager * nam = new QNetworkAccessManager(this);
       QObject::connect(nam, SIGNAL(finished(QNetworkReply*)),
                this, SLOT(searchServiceFinished(QNetworkReply*)));
       QUrl url( "http://130.56.253.211/api2/web/index.php?r=cyclone/searchbyregion&latfrom="+lat1+"&lntfrom="+lng1+"&latto="+lat2+"&lntto="+lng2);
       qDebug() << url;
       nam->get(QNetworkRequest(url));*/
}


void Prediction::initYearCount(){
    yearsCount.clear();
    QDateTime local(QDateTime::currentDateTime());
    int current = local.toString("yyyy").toInt();

    for(int i = 1970; i <= current; i++ ){
        yearsCount.insert(QString::number(i), 0);
    }
}


void Prediction::searchServiceFinished(QNetworkReply* reply)
{
/*
    if(reply->error() == QNetworkReply::NoError) {

        initYearCount();

        QStringList propertyNames;
        QStringList propertyKeys;

        QString strReply = reply->readAll();
        QJsonDocument jsonResponse = QJsonDocument::fromJson(strReply.toUtf8());
        QJsonObject jsonObject = jsonResponse.object();

        if(jsonObject.keys().contains("cyclones")){
            qDebug() << strReply;
            QJsonArray jsonArray = jsonObject["cyclones"].toArray();

            foreach (const QJsonValue & value, jsonArray)
            {

                QJsonObject obj = value.toObject();
                QJsonObject objC = obj["cyclone"].toObject();
                Cyclone * cyclone = new Cyclone;

                if(obj.keys().contains("tracks")){
                    QJsonArray tracksArray = obj["tracks"].toArray();
                    if(tracksArray.size() > 0){
                        QJsonObject obj = tracksArray.at(0).toObject();
                        QString lng = obj["longitude"].toString();
                        QString lat = obj["latitude"].toString();
//                      latitude<=:latfrom', 'latitude>=:latto', 'longitude>=:lantfrom', 'longitude<=:lantto
                        if(lat.toDouble() <= fromLat && lat.toDouble() >= toLat  && lng.toDouble() >= fromLng && lng.toDouble() <= toLng ){
                             yearsCount[objC["year"].toString()] = yearsCount.value(objC["year"].toString()) + 1;
                        }
                    }
                }
            }
        }

        for(int i = 1950; i <= 2016; i++){
            qDebug()<<i <<" - "<<yearsCount.value(QString::number(i))<<endl;
        }
    }
    delete reply;*/
}


QHash<QString, int> Prediction::getYearCount(){
    return yearsCount;
}

void Prediction::setYearCount(QHash<QString, int> yearsCount){
    this->yearsCount = yearsCount;
}

double Prediction::getFromLat(){
    return fromLat;
}
double Prediction::getToLat(){
    return toLat;
}

double Prediction::getFromLng(){
    return fromLng;
}

double Prediction::getToLng(){
    return toLng;
}

void Prediction::setFromLat(double lat){
    this->fromLat = lat;
}

void Prediction::setToLat(double lat){
    this->toLat = lat;
}

void Prediction::setFromLng(double lng){
    this->fromLng = lng;
}

void Prediction::setToLng(double lng){
    this->toLng = lng;
}


void Prediction::setEngine(QQmlApplicationEngine * engine){
    this->engine = engine;
}

QQmlApplicationEngine * Prediction::getEngine(){
    return this->engine;
}



//**************


//Read the content of "buffer.txt"
/*void buffer() {
    ifstream file("buffer.txt");
    string contents((istreambuf_iterator<char>(file)),istreambuf_iterator<char>());
    cout << contents;
    remove("buffer.txt");
}
*/


void Prediction::_BugsCmd(std::string cmd) {

    typedef void (*CLI)();
    CLI cli  = (CLI)QLibrary::resolve("i:/qt/TrAp/libOpenBUGS.dll","CLI");
    if (!cli) {
        qDebug()<<"Unable to link to function cli\n";
    }

    cli();

    typedef void (*BugsCmd)(char** , int*);
    BugsCmd bugsCmd  = (BugsCmd)QLibrary::resolve("i:/qt/TrAp/libOpenBUGS.dll","BugsCmd");
    if (!bugsCmd) {
        qDebug()<<"Unable to link to function SetWorkingDir\n";
    }

    char * c = new char[cmd.length()+1];
    for(int i = 0; i< cmd.length(); i++)
        c[i] = cmd.at(i);

    c[cmd.length()] = '\0';

   // std::string myString(cmd.c_str(), cmd.length());
    qDebug()<<c;
    int len = cmd.length()+1;//myString.length();
  /*  int error = -1;*/
    //int* error_ptr = &error;
    try{
        bugsCmd(&c, &len);
    }catch (std::exception &e) {
        qFatal("Error %s ", e.what());
    }catch(...){

    }
}

void segv_handler(int)
{
  // Do what you want here
}
//Run CmdInterpreter procedure from OpenBUGS
void Prediction::_CmdInterpreter(std::string cmd) {
    typedef void (*CmdInterpreter)(std::string * , int*, int*);
    CmdInterpreter cmdInterpreter  = (CmdInterpreter)QLibrary::resolve("i:/qt/TrAp/libOpenBUGS.dll","CmdInterpreter");
    if (!cmdInterpreter) {
        qDebug()<<"Unable to link to function SetWorkingDir\n";
    }

    std::string myString(cmd.c_str(), cmd.length());
    qDebug()<<myString.c_str();
    int len = myString.length();
    int error = -1;
    //int* error_ptr = &error;
    try{
        cmdInterpreter(&myString, &len, &error);
       // signal(SIGSEGV, segv_handler);
    }catch (std::exception &e) {
        qFatal("Error %s ", e.what());
    }catch(...){

    }
    //    error = *error_ptr;
    if (error > 0) {
        qDebug() << "Unable to call CmdInterpreter with " << cmd.c_str() << endl << "Error = " << error << endl; system("PAUSE"); exit(0);}
   // buffer();
}


//Run CharArray procedure from OpenBUGS
void Prediction::_CharArray(QString cmd, QString arg) {
    typedef void (*CharArray)(char**, int*, char**, int*, int*);
    CharArray charArray  = (CharArray)QLibrary::resolve("i:/qt/TrAp/libOpenBUGS.dll","CharArray");
    if (!charArray) {
        qDebug()<<"Unable to link to function SetWorkingDir\n";
    }

    if (!charArray) {
        //printf("Unable to link to function CharArray\n"); system("PAUSE"); exit(0);
    }


    char* c_cmd;
    std::string s_cmd = cmd.toStdString();
    c_cmd = new char [s_cmd.size()+1];
    strcpy( c_cmd, s_cmd.c_str() );


    char* c_arg;
    std::string s_arg = arg.toStdString();
    c_arg = new char [s_arg.size()+1];
    strcpy( c_arg, s_arg.c_str() );

    int cmd_len = cmd.length();
    int arg_len = arg.length();

    int res = 0; int* res_ptr = &res;
    charArray(&c_cmd, &cmd_len, &c_arg, &arg_len, res_ptr);
    //buffer();
}

void Prediction::doBackcast(){

    HindcastThread * hindcast = new HindcastThread(this);
    hindcast->start();

}



