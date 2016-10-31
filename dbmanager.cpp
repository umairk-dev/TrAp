#include "dbmanager.h"
#include "model.h"
#include "variable.h"


DbManager::DbManager()
{

    db = QSqlDatabase::addDatabase("QSQLITE");
    db.setDatabaseName(  QCoreApplication::applicationDirPath() + QStringLiteral("/trap.db"));// QDir::homePath() + QDir::separator() + "qrc:/trapDB.db3");
    if(!QFile::exists(QCoreApplication::applicationDirPath() +  QStringLiteral("/trap.db"))){
        qDebug() << QCoreApplication::applicationDirPath() +  QStringLiteral("/trap.db");//;QDir::homePath() + QDir::separator() + "trapDB.db3";
        if(!db.isOpen())
            db.open();

        if (db.isOpen()) {
            createTblModel();
            createTblCyclone();
            createTblCycloneTrack();
            createTblElninoLanina();
            createTblVersion();
        } else {
            qDebug() << "No DB";
        }
    }
    db.close();

}

Model * DbManager::getModel(QString mid){
    Model * model = new Model;

    if(db.open()){
        QSqlQuery query(db);
        query.exec("SELECT modelData, modelEquation FROM model WHERE modelID = " + mid);
        if (query.next()) {

            model->setModelData(query.value("modelData").toString());
            model->setModelEquation(query.value("modelEquation").toString());
        }
    }
    db.close();
    return model;
}

QList<ElLa*> DbManager::getElLa(int month){
    QList<ElLa*> list;

    if(db.open()){
        QDateTime local(QDateTime::currentDateTime());
        int current = local.toString("yyyy").toInt();

        QSqlQuery * query = new QSqlQuery(db);
        query->prepare("Select * from ElninoLanina WHERE month = "+QString::number(month)+ " AND year < " + QString::number(current) + " ORDER BY year ASC");

        if(query->exec() == true)
        {
            while (query->next()) {
                ElLa * ella = new ElLa;
                ella->setYear(query->value("year").toInt());
                ella->setMonth(query->value("month").toInt());
                ella->setValue(query->value("value").toDouble());
                ella->setColor(query->value("color").toString());
                list.append(ella);
            }
        }
        delete query;
    }
    db.close();
    return list;
}


ElLa* DbManager::getSingleElLa(int year, int month){
    ElLa * ella = NULL;

    if(db.open()){

        QSqlQuery * query = new QSqlQuery(db);
        query->prepare("Select * from ElninoLanina WHERE month = "+QString::number(month)+ " AND year = " + QString::number(year) );

        if(query->exec() == true)
        {
            if (query->next()) {
                ella = new ElLa;
                ella->setYear(query->value("year").toInt());
                ella->setMonth(query->value("month").toInt());
                ella->setValue(query->value("value").toDouble());
                ella->setColor(query->value("color").toString());
                return ella;
            }
        }
        delete query;
    }
    db.close();
    return ella;
}


void DbManager::setMapView(QObject * mapView){
    this->mapView = mapView;
}

DbManager::~DbManager(){

    QSqlDatabase::removeDatabase(QDir::tempPath() + QStringLiteral("/trap.db"));
}

DbManager & DbManager::get()
{
    static DbManager obj;
    return obj;
}

int DbManager::getVersion(){
    if(!db.isOpen()){
        db.open();
    }

    if(db.isOpen()){
        QSqlQuery query(db);
        query.exec("SELECT verNum FROM version");
        if (query.next()) {
           return query.value(0).toInt();
        }
    }

    db.close();
    return 0;
}

void DbManager::updateVersion(int v){

    if(!db.isOpen()){
        db.open();
    }

    if(db.isOpen()){
        QSqlQuery query(db);
        query.exec("UPDATE version SET verNum = " + QString::number(v));
        qDebug() << "version updated";
    }else

        qDebug() << "Unable to update version";


    db.close();
}

bool DbManager::checkCyclone(QString id){
    if(!db.isOpen()){
        db.open();
    }

    if(db.isOpen()){

        QSqlQuery * query = new QSqlQuery(db);
        query->prepare("SELECT cycloneID FROM cyclone WHERE cycloneID = " + id);

        if(query->exec() == true)
        {
           // qDebug() << "track added";
            if (query->next()) {
                delete query;
                db.close();
               return true;
            }

        }else{

            qDebug() << "Error inserting new track";

        }
        delete query;
        db.close();

    }

  //  db.close();
    return false;


}

bool DbManager::checkElLa(int year, int month){
    if(!db.isOpen()){
        db.open();
    }

    if(db.isOpen()){
        QSqlQuery * query = new QSqlQuery(db);
        query->prepare("SELECT value FROM ElninoLanina WHERE year = " + QString::number(year) + " AND month = " + QString::number(month));

        if(query->exec() == true)
        {
           // qDebug() << "track added";
            if (query->next()) {
                delete query;
                db.close();
               return true;
            }

        }else{

            qDebug() << "Error inserting new track";

        }
        delete query;
        db.close();

    }

  //  db.close();
    return false;
}

void DbManager::createTblModel(){

    if(!db.isOpen())
        db.open();

    QSqlQuery query(db);
    if (query.exec("CREATE TABLE IF NOT EXISTS model ( modelID INTEGER PRIMARY KEY AUTOINCREMENT, modelData TEXT, modelName TEXT, modelEquation TEXT);")) {
        qDebug() << "model table created";

        QString m = "";
        m.append("'model; { ");
        m.append("for(i in 1: N) { ");
        m.append("y[i]  ~ dpois (lambda [i]) ");
        m.append("log(lambda [i]) <-  beta0 + beta1*Nino34[i]");
        m.append("} ");
        m.append("beta0 ~ dnorm(0.0, 1.0E-6) ");
        m.append("beta1 ~ dnorm(0.0, 1.0E-6) ");
        m.append("beta2<- log(p) ");
        m.append("p ~ dunif(lower, upper) ");
        m.append("}'");

        query.exec("INSERT INTO model ( modelData, modelName, modelEquation) VALUES ( "+m+", 'Poisson', 'beta0 + beta1 * Nino34[i]');");


        if (query.exec("CREATE TABLE IF NOT EXISTS modelVariable ( dataID INTEGER PRIMARY KEY AUTOINCREMENT, dataName TEXT, dataValue TEXT, modelID INTEGER, dataType TEXT);")) {
            qDebug() << "data table created";
            query.exec("INSERT INTO modelVariable ( dataName,dataValue, modelID, dataType) VALUES ( 'N', '0', 1, '1');");
            query.exec("INSERT INTO modelVariable ( dataName,dataValue, modelID, dataType) VALUES ( 'lower', '0.80', 1, '1');");
            query.exec("INSERT INTO modelVariable ( dataName,dataValue, modelID, dataType) VALUES ( 'upper', '0.95', 1, '1');");
            query.exec("INSERT INTO modelVariable ( dataName,dataValue, modelID, dataType) VALUES ( 'beta0', '0', 1, '2');");
            query.exec("INSERT INTO modelVariable ( dataName,dataValue, modelID, dataType) VALUES ( 'beta1', '0', 1, '2');");
            query.exec("INSERT INTO modelVariable ( dataName,dataValue, modelID, dataType) VALUES ( 'p', '0.95', 1, '2');");
        }

    } else {
        qDebug() << "error Model table creation" << query.lastError();
    }

    db.close();
}



void DbManager::createTblVersion(){

    if(!db.isOpen())
        db.open();

    QSqlQuery query(db);
    if (query.exec("CREATE TABLE IF NOT EXISTS version ( verNum INTEGER);")) {
        qDebug() << "version Table Created";
        query.exec("INSERT INTO version (verNum) VALUES (0);");
    } else {
        qDebug() << "error Model table creation" << query.lastError();
    }


    db.close();
}

void DbManager::createTblCyclone(){

    if(!db.isOpen())
        db.open();

    QSqlQuery query(db);



    if (query.exec("CREATE TABLE Cyclone (cycloneID INTEGER PRIMARY KEY, cycloneName TEXT (150), seasonYear  TEXT, source TEXT, num TEXT, ctype TEXT );")){
        qDebug() << "Cyclone Table Created";
    } else {
        qDebug() << "error Cyclone table creation" << query.lastError();
    }

    db.close();
}

void DbManager::createTblCycloneTrack(){
    if(!db.isOpen())
        db.open();

    QSqlQuery query(db);


    if (query.exec("CREATE TABLE CycloneTrack (trackID   INTEGER PRIMARY KEY,latitude  DOUBLE,longitude DOUBLE, pressure  DOUBLE,windSpeed DOUBLE, dateTime  TEXT,nature TEXT,basin TEXT,subBasin  TEXT, cycloneID INTEGER);")){
        qDebug() << "CycloneTrack Table Created";
    } else {
        qDebug() << "error CycloneTrack table creation" << query.lastError();
    }
  db.close();
}

void DbManager::createTblElninoLanina(){
    if(!db.isOpen())
        db.open();

    QSqlQuery query(db);


    if (query.exec("CREATE TABLE ElninoLanina (id  INTEGER PRIMARY KEY AUTOINCREMENT,year  INTEGER,month INTEGER, value DOUBLE, color TEXT);")){
        qDebug() << "ElninoLanina Table Created";
    } else {
        qDebug() << "error ElninoLanina table creation" << query.lastError();
    }
  db.close();
}

bool DbManager::addElLa(ElLa * ella){
   // mapView = _engine->rootObjects().at(0)->findChild<QObject*>("map");

   // QString msg = "updating Elnino Lanina Data..";
  //  if(!QMetaObject::invokeMethod(mapView, "showStatus", Q_ARG(QVariant, QVariant::fromValue(msg))))
  //      qDebug() << "Failed to invoke showStatus";

   // if(!db.isOpen())
   db.open();

   // QSqlQuery query(db);

    if(db.isOpen()){

        QSqlQuery * query = new QSqlQuery(db);
        query->prepare("INSERT INTO ElninoLanina (year, month, value, color) VALUES ("+QString::number(ella->getYear())+"," + QString::number(ella->getMonth()) + "," +QString::number(ella->getValue()) + ",'" + ella->getColor() + "');");

        if(query->exec() == true)
        {
            qDebug() << "ella added";

        }else{

            qDebug() << "Error inserting new ella";
        }

        delete query;
        delete ella;
        db.close();
        return true;
    }
    return false;

    //qDebug() << "row added";
  //  db.close();
    //msg = "";
   // if(!QMetaObject::invokeMethod(mapView, "showStatus", Q_ARG(QVariant, QVariant::fromValue(msg))))
     //   qDebug() << "Failed to invoke showStatus";

}

void DbManager::clearDB(){
    db.open();

    QSqlQuery query(db);
    if (query.exec("DELETE FROM Cyclone;")) {
        qDebug() << "Cyclone Table cleared";
        query.exec("VACUUM;");
    } else {
        qDebug() << "error clearing Cyclone table" << query.lastError();
    }

    if (query.exec("DELETE FROM CycloneTrack;")) {
        qDebug() << "Cyclone Track Table cleared";
        query.exec("VACUUM;");
    } else {
        qDebug() << "error clearing Cyclone Track table" << query.lastError();
    }
      db.close();
}


void DbManager::addCyclone(Cyclone * cyclone){

    QString msg = "";
   // mapView = _engine->rootObjects().at(0)->findChild<QObject*>("map");

    db.open();

    if (db.isOpen()) {
      //  QSqlQuery query(db);

        QSqlQuery * query = new QSqlQuery(db);
        query->prepare("INSERT INTO Cyclone (cycloneID, cycloneName, seasonYear, source, num, ctype) VALUES ("+cyclone->getCycloneID()+",'" + cyclone->getCycloneName() + "','" + cyclone->getSeasonYear() + "','" + cyclone->getSource()+"','"+cyclone->getNum()+"','" + cyclone->getCType() + "');");

        if(query->exec() == true)
        {
            qDebug() << "cyclone added";

        }else{

            qDebug() << "Error inserting new cyclone";

        }

        delete query;
       // db.close();


        //       msg = "Adding Cyclone.. " + cyclone->getCycloneName();
      //      if(!QMetaObject::invokeMethod(mapView, "showStatus", Q_ARG(QVariant, QVariant::fromValue(msg))))
      //              qDebug() << "Failed to invoke showStatus";
//        } else {
  //          qDebug() << "error while adding cyclone data" << query.lastError();

   //     msg = "error while adding cyclone data";
  //      if(!QMetaObject::invokeMethod(mapView, "showStatus", Q_ARG(QVariant, QVariant::fromValue(msg))))
 //           qDebug() << "Failed to invoke showStatus";
    }
//    msg = "";
 //   if(!QMetaObject::invokeMethod(mapView, "showStatus", Q_ARG(QVariant, QVariant::fromValue(msg))))
  //      qDebug() << "Failed to invoke showStatus";

     // db.close();


}

void DbManager::addTracks(QVariantList tracks){
  //  mapView = _engine->rootObjects().at(0)->findChild<QObject*>("map");
    if(!db.isOpen())
       db.open();

    if (db.isOpen()) {
        //QString msg = "";
        for(int i = 0; i < tracks.size(); i++){
            QSqlQuery * query = new QSqlQuery(db);
            CycloneTrack *track = qvariant_cast<CycloneTrack*>( tracks.at(i));
            query->prepare("INSERT INTO cyclonetrack (trackID,latitude ,longitude,pressure,windSpeed, dateTime  ,nature,basin,subBasin,cycloneID) VALUES ("+QString::number(track->getTrackID())+"," + QString::number(track->getLatitude() )+ "," +QString::number(track->getLongitude()) + "," + QString::number(track->getPressure()) +","+ QString::number(track->getWindSpeed())+",'" + track->getDateTime()+"','" + track->getNature() + "','" + track->getBasin() + "','" + track->getSubBasin()+ "'," +track->getCycloneID() + ");");

            if(query->exec() == true)
            {
               // qDebug() << "track added";

            }else{

                qDebug() << "Error inserting new track";

            }
            delete track;
            delete query;
        }

        //db.close();
        //   msg = "Adding Track Data.. ";
        //    if(!QMetaObject::invokeMethod(mapView, "showStatus", Q_ARG(QVariant, QVariant::fromValue(msg))))
        //        qDebug() << "Failed to invoke showStatus";

       //         qDebug() << "track row added";
      //  } else {
     //           qDebug() << "error while adding cyclone track data" << query.lastError();

       //         msg = "Error while adding cyclone track data.. ";
       //         if(!QMetaObject::invokeMethod(mapView, "showStatus", Q_ARG(QVariant, QVariant::fromValue(msg))))
        //            qDebug() << "Failed to invoke showStatus";
        }

 //   msg = "";
//    if(!QMetaObject::invokeMethod(mapView, "showStatus", Q_ARG(QVariant, QVariant::fromValue(msg))))
//        qDebug() << "Failed to invoke showStatus";
      //  db.close();

}



QHash<QString, int> DbManager::searchArea(double latFrom, double lngFrom,double latTo, double lngTo){

    mapView = _engine->rootObjects().at(0)->findChild<QObject*>("map");

    QDateTime local(QDateTime::currentDateTime());
    int current = local.toString("yyyy").toInt();
    QString cycloneSql = "SELECT cycloneID, seasonYear FROM Cyclone WHERE seasonYear BETWEEN 1970 AND " + QString::number(current);

    QString msg = "Searching cyclones in selected region from 1970 to " + QString::number(current);
    if(!QMetaObject::invokeMethod(mapView, "showStatus", Q_ARG(QVariant, QVariant::fromValue(msg))))
        qDebug() << "Failed to invoke showStatus";
    int count = 0;

    QHash<QString, int> yearsCount;
    for(int i = 1970; i <= current; i++ ){
        yearsCount.insert(QString::number(i), 0);
    }

    if(!db.isOpen()){
        db.open();
    }

    if(db.isOpen()){
        QSqlQuery query(db);
        query.exec(cycloneSql);
        while (query.next()) {

            int id = query.value("cycloneID").toInt();
            QString year = query.value("seasonYear").toString();
          //  qDebug() << id <<" - " << year<<endl;
            QString sql = "SELECT * FROM cycloneTrack WHERE cycloneID = " + QString::number(id) ;

        /*    if(latTo.toDouble() < latFrom.toDouble()){
                  sql.append(" and latitude<=" + latFrom);
                  sql.append(" and latitude>=" + latTo);
            }else{
                  sql.append(" and latitude>=" + latFrom);
                  sql.append(" and latitude<=" + latTo);
            }


            if(lngTo.toDouble() < lngFrom.toDouble()){
                  sql.append(" and longitude<=" + lngFrom);
                  sql.append(" and longitude>=" + lngTo);
            }else{
                  sql.append(" and longitude>=" + lngFrom);
                  sql.append(" and longitude<=" + lngTo);
            }
*/
            QSqlQuery query2(db);
            query2.exec(sql);
       //     qDebug()<< sql;
       //     qDebug() << query2.size();
             if (query2.next()) {
                 double lat = query2.value("latitude").toDouble();
                 double lng = query2.value("longitude").toDouble();

                 bool chkLat = false;
                 bool chkLng = false;
                 if(latTo < latFrom && ( lat <= latFrom && lat >= latTo ) ){

                     chkLat = true;
                 }else if(lat >= latFrom && lat <= latTo){
                     chkLat = true;
                 }


                 if(lngTo < lngFrom && ( lng <= lngFrom && lng >= lngTo ) ){

                     chkLng = true;
                 }else if(lng >= lngFrom && lng <= lngTo){
                     chkLng = true;
                 }

                 if(chkLng && chkLat){
                     yearsCount[year] = yearsCount.value(year) + 1;
                     count++;


                     QString msg = "Searching cyclones in selected region from 1970 to " + QString::number(current);
                     msg.append("\n Found: " + QString::number(count));
                     if(!QMetaObject::invokeMethod(mapView, "showStatus", Q_ARG(QVariant, QVariant::fromValue(msg))))
                         qDebug() << "Failed to invoke showStatus";

                 }
             }

        }
    }


    if(count == 0){
        QString msg = "0 Cyclones originated in selected region from 1970 to " + QString::number(current);
        if(!QMetaObject::invokeMethod(mapView, "showStatus", Q_ARG(QVariant, QVariant::fromValue(msg))))
            qDebug() << "Failed to invoke showStatus";
    }else{
        QString msg = QString::number(count) + " Cyclones originated in selected region from 1970 to " + QString::number(current);
        if(!QMetaObject::invokeMethod(mapView, "showStatus", Q_ARG(QVariant, QVariant::fromValue(msg))))
            qDebug() << "Failed to invoke showStatus";


    }

    return yearsCount;
}


void DbManager::getModelList(){
    if(!db.isOpen()){
        db.open();
    }

    if(db.isOpen()){
        QSqlQuery * query = new QSqlQuery(db);
        query->prepare("SELECT * FROM model " );
        QVariantList models;
        if(query->exec() == true)
        {

            while (query->next()) {
                Model *  model = new Model;
                model->setModelID(query->value("modelID").toString());
                model->setModelData(query->value("modelData").toString());
                model->setModelName(query->value("modelName").toString());             
                model->setModelEquation(query->value("modelEquation").toString());

                QSqlQuery * query2 = new QSqlQuery(db);
                query2->prepare("SELECT * FROM modelVariable WHERE modelID = " + query->value("modelID").toString() );
                if(query2->exec() == true)
                {
                    QVariantList dataList;
                   // qDebug() << "track added";
                    while (query2->next()) {
                        Variable * data = new Variable;
                        data->setDataID(query2->value("dataID").toInt());
                        data->setDataName(query2->value("dataName").toString());
                        data->setDataValue(query2->value("dataValue").toString());
                        data->setDataType(query2->value("dataType").toString());
                        QVariant d;
                        d.setValue(data);
                        dataList.append(d);

                        qDebug() << data->getDataName() << " v=" << data->getDataValue() << " t=" << data->getDataType();

                    }

                    qDebug() << dataList;
                    model->setDataList(dataList);
                }

                delete query2;
                QVariant m;
                m.setValue(model);
                models.append(m);
             }
        }else{
            qDebug() << "Error loading models";
        }
        delete query;
        db.close();


        QObject *predictionV = _engine->rootObjects().at(0)->findChild<QObject*>("predictView");
        if(predictionV)
        {
            if(models.size() > 0){
                for(int i = 0; i < models.size(); i++){
                    if(!QMetaObject::invokeMethod(predictionV, "loadModels", Q_ARG(QVariant, QVariant::fromValue(models))))
                        qDebug() << "Failed to invoke push";
                }
            }
        }else{

            qDebug() << "not found";
        }
    }
}

void DbManager::setEngine(QQmlApplicationEngine * engine){
    _engine = engine;
}

void DbManager::updateModel(Model * model){
    if(!db.isOpen()){
        db.open();
    }

    if(db.isOpen()){
        QSqlQuery * query = new QSqlQuery(db);
        query->prepare("UPDATE model SET modelData = '"+model->getModelData()+"', ,modelEquation = '"+model->getModelEquation()+"' WHERE modelID = " + model->getModelID() );
        if(query->exec() == true){
            qDebug() << "model updated";
        }else{

            qDebug() << "unable to update model";

        }

        delete query;
        db.close();
    }
}

QString DbManager::getDataList(int modelID){

    if(!db.isOpen()){
        db.open();
    }

    if(db.isOpen()){
        QSqlQuery * query = new QSqlQuery(db);

        query->prepare("SELECT dataName, dataValue, dataID FROM modelVariable WHERE dataType = '1' AND  modelID = " + QString::number(modelID));
        if(query->exec() == true){
            qDebug() << "data updated";
            QString d = "";//list(";
            while(query->next()){

                 if(query->value("dataName").toString() != "N"){
                    d.append(query->value("dataName").toString());
                    d.append("=");
                    d.append(query->value("dataValue").toString());
                    d.append(", ");
                 }
            }
            d = d.remove(d.length()-2, d.length()-1 );
            d.append(")");
            return d;
        }
    }

    return "";
}

QString DbManager::getInitList(int modelID){

        if(!db.isOpen()){
            db.open();
        }

        if(db.isOpen()){
            QSqlQuery * query = new QSqlQuery(db);

            query->prepare("SELECT dataName, dataValue, dataID FROM modelVariable WHERE dataType = '2' AND modelID = " + QString::number(modelID));
            if(query->exec() == true){
                qDebug() << "data updated";
                QString d = "list(";
                while(query->next()){

                        d.append(query->value("dataName").toString());
                        d.append("=");
                        d.append(query->value("dataValue").toString());
                        d.append(", ");

                }
                d = d.remove(d.length()-2, d.length()-1 );
                d.append(")");
                return d;
            }

            delete query;
            db.close();
       }

       return "";
}

void DbManager::updateData(Variable * vdata, int modelID){
    if(!db.isOpen()){
        db.open();
    }

    if(db.isOpen()){
        QSqlQuery * query = new QSqlQuery(db);

        if(vdata->getDataName() == "N"){
            qDebug() << "UPDATE modelVariable SET dataValue = '"+ vdata->getDataValue()+"' WHERE modelID = " + QString::number(modelID) + " AND dataName = 'N' ";
            query->prepare("UPDATE modelVariable SET dataValue = '"+ vdata->getDataValue()+"' WHERE modelID = " + QString::number(modelID) + " AND dataName = '" + vdata->getDataName()+"' ");
        }else{
            query->prepare("UPDATE modelVariable SET dataName = '"+vdata->getDataName()+"', dataValue = '"+ vdata->getDataValue()+"' WHERE modelID = " + QString::number(modelID) + " AND dataID = '" + QString::number(vdata->getDataID())+"' ");
        }

        if(query->exec() == true){
            qDebug() << "data updated";
        }else{

            qDebug() << "unable to update data";

        }


        delete query;
        db.close();
    }


}


QStringList DbManager::getMonitorList(int modelID){
    if(!db.isOpen()){
        db.open();
    }

    QStringList list;
    if(db.isOpen()){
        QSqlQuery * query = new QSqlQuery(db);


        query->prepare("SELECT dataName FROM modelVariable WHERE dataType = '2' AND modelID = " + QString::number(modelID));
        if(query->exec() == true){
            QString d = "list(";
            while(query->next()){
                if(query->value("dataName").toString() != "N")
                    list.append(query->value("dataName").toString());
            }
            return list;
        }

        delete query;
        db.close();
   }
    return list;

}

