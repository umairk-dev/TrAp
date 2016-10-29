import QtQuick 2.5
import QtCharts 2.1
import QtQuick.Window 2.2
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.1
import QtQuick.Controls.Styles 1.4
import QtQuick.Dialogs 1.2
import Cyclone 1.0
import QtLocation 5.5
import QtPositioning 5.3
import PlotPoint 1.0
import PResult 1.0

ApplicationWindow  {
    title: "TrAp - FedUni Project"
    width: screenWidth
    height : screenHeight
    color: "#4355e6"
    visible: true
    visibility: "Maximized"
    id : window
    objectName: "main"
    property bool isSearching: false
    property string info : ""
    property string _platform: platform
    property bool isSearchScreen: false
    property bool isReportScreen: false
    property bool isFilterScreen: false
    property bool isPredictScreen: false

    // 26092016 [S] ChartView show after search
    //property bool isChartConfigScreen: false
    property bool isChartScreen: false
    // 26092016 [E] ChartView show after search
    property int ppi: Screen.pixelDensity*25.4
    property variant cycloneInfo: []
    property Map mapView

    property variant selectedCyclones: []

    property var dir: ["MDPI","HDPI","XHDPI","XXHDPI",
                                        "XXXHDPI","XXXXHDPI"]

    property bool predictAreaSel: false
// 14092016 [S] new search mechanism
    property variant searchType //year, wind
    property variant searchPara //2016,
// 14092016 [E] new search mechanism
    property var intensity_colours: ['#ffffff','#5ebaff','#00faf4','#ffff99','#ffe775','#ffc140','#ff8f20','#ff6060'] //28082016 Changed from #ffffcc to #ffff99
    // 18092016 [S] predefine country search
    property var preDefineCountry: ["-15.7134,176.0650,-19.7134,180.0650","-7.6457,158.1562,-11.6457,162.1562","-19.1790,-173.1982,-23.1790,-177.1982"]//["-17.7134,178.0650","-9.6457,160.1562","-21.1790,-175.1982"]//FST
    // 18092016 [E] predefine country search
    // 19092016 [S] area selection
    property bool areaSelectMode:false
    // 19092016 [E] area selection
    // 26092016 [S] var for bar chart
    property variant catelist: []
    property variant catevalues: []
    property variant rangemax: []
    property variant rangemin: []
    // 26092016 [E] var for bar chart
    // 29092016 [S] var for searching
    property var serchingitem: ['year','wind','pressure','area','country','elstat']
    property var selectingArea: []
    property var statuslist: ["LaNina","Neutral","ElNino"]


    //Prediction Paramerters
    property var modelID: 1
    property var _update: 1000
    property var _burnin: 1000
    property var _elSeason: 5

    property variant predictdataset: []

    // 29092016 [E] var for searching
    readonly property int ppiRange:{
     if (ppi>=540)
      5
     else if (ppi>=360)
      4
     else if (ppi>=270)
      3
     else if (ppi>=180)
      2
     else if (ppi>=135)
      1
     else
      0
     }

    /****************************************/

    MessageDialog {
        id: messageDialog

        title: "Cyclone Info"
        onAccepted: {
            messageDialog.close()
        }
        Component.onCompleted: visible = false
    }

    Rectangle{
         x :  parent.width/2
         y : parent.height/2
         width: 100
         height : 100
         color: "black"
         id : processing
         z : 0
         Text {
             anchors.centerIn: processing
             id: txtProcess
             text: qsTr("Processing..")
             color : "white"
         }

    }



    Text {
        x : parent.width/2
        y : 20
        z : 70

        id: txtResultCount
        color : "white"
    }

         Text {
             x : 20
             y : 60
             z : 70
             font.pointSize : 12
             id: txtInfo

             color : "white"
         }

    function getTrackColor(windSpeed){
        if(windSpeed===-999)
                return intensity_colours[0]
        else if(windSpeed<34)
                return intensity_colours[1]
        else if(windSpeed<64)
                return intensity_colours[2]
        else if(windSpeed<83)
               return intensity_colours[3]
        else if(windSpeed<96)
               return intensity_colours[4]
        else if(windSpeed<113)
                return intensity_colours[5]
        else if(windSpeed<137)
                return intensity_colours[6]
        else
                return intensity_colours[7]
    }

    //Info Box
    function showTrackInfo(_data){
     //   console.log(_data)

        messageDialog.text = _data;
        messageDialog.open();
    }


    function getMapItems(){
        if(map !== undefined)
            return map.cyclones;
    }



    /*****************************************/

    //signals
    signal updateModel(string model, variant data, string modelID);
    signal updateElLa();
    signal updateLocalDB()
    signal submitTextField(string text)
    signal searchByName(string name)
    signal searchByYear(string year)
    signal searchByWind(string windFrom, string windTo)
    signal searchByYears(string yearFrom, string yearTo)
    signal searchByPressure(string pressureFrom, string pressureTo)
    signal searchByArea(string lat1, string lng1, string lat2, string lng2)
    signal predictCyclones(string lat1, string lng1, string lat2, string lng2, string modleID, string burnin, string update, string elSeason)
    // 29092016 [S] search by multiple parameter
    signal searchByMultiPara(variant multisearchpara)
    // 29092016 [E] search by multiple parameter
    signal generateReport(string path, variant cyclones)
    signal controlMapMouse(bool status);
    signal clearMap();
    signal getModelList();
    signal doBackcast();

    //  signal sendWebView(WebEngineView view)

    function selectCyclone(cyclone){
        console.log("Adding: " + cyclone.cycloneID + ", " + cyclone.cycloneName);
        console.log("List before adding : " + selectedCyclones);
        for(var i = 0; i < selectedCyclones.length; i++){
            if(selectedCyclones[i].cycloneID === cyclone.cycloneID){
                console.log("Already in list");
                return;
            }
        }

        selectedCyclones.push(cyclone);

        console.log("Added : length = " + selectedCyclones.length);
        console.log("List after adding : " + selectedCyclones);

    }

    function removeCyclone(cyclone){
        console.log("removing : " + cyclone.cycloneID);
        console.log("List before rem : " + selectedCyclones);

        var temp = []
        for(var i = 0; i < selectedCyclones.length; i++){
            if(selectedCyclones[i].cycloneID !== cyclone.cycloneID)
                temp.push(selectedCyclones[i]);
        }
        selectedCyclones = temp;
        console.log("List after rem : " + selectedCyclones);
    }


    // slots
    function setTextField(text){
         console.log("setTextField: " + text)

        //stack.zoomIn();
    }


    function _generateReport(type, path){
        if(type === "all"){
            generateReport(path, cycloneInfo);
        }else if(type === "selected"){
            generateReport(path, selectedCyclones);
        }else{
            var filtered = []
            for(var i = 0; i < cycloneInfo.length; i++){
                if((window.mapView.cyclones[i])[3] === true)
                    filtered.push(cycloneInfo[i])
            }
            generateReport(path, filtered);

        }
    }

    // 14092016 [S] new search mechanism
    function doClearCondition(){
        searchType = []
        searchPara = []
    }


    //
    function addSearchCondtion(type,content){
        searchType.push(type)
        searchPara.push(content)
    }
    function doSearch(){
      window.isSearchScreen = false;
      if(searchType.length === 1)
      {//single type search
//            console.log("[DBG] Type:"+searchType.length+"||"+searchType[searchType.length-1]+"\tPara"+searchPara.length+"||"+searchPara[searchPara.length-1])
          var singleSearchPara
           if(searchType[searchType.length-1] === serchingitem[0])
           {
               if(searchPara.length === 1 && searchPara[searchPara.length-1].length ===4)
               {
                    processing.z = 60
                    searchByYear(searchPara[searchPara.length-1])
               }
               else
               {
                   singleSearchPara = String(searchPara[searchType.length-1]).split(',')
//                   console.log("[DBG]p1"+paraYear[0]+"\tp2"+paraYear[1])
                   processing.z = 60
                   searchByYears(singleSearchPara[0],singleSearchPara[1])
               }//searchByYearRange(searchPara[searchPara.length-1]);
           }
           else if(searchType[searchType.length-1] === serchingitem[1] ){
               singleSearchPara = String(searchPara[searchType.length-1]).split(',')
//               console.log("[DBG_wind]p1"+singleSearchPara[0]+"\tp2"+singleSearchPara[1])
               processing.z = 60
               searchByWind(singleSearchPara[0],singleSearchPara[1])
           }
           else if(searchType[searchType.length-1] === serchingitem[2] ){
               singleSearchPara = String(searchPara[searchType.length-1]).split(',')
//               console.log("[DBG]p1"+singleSearchPara[0]+"\tp2"+singleSearchPara[1])
               processing.z = 60
               searchByPressure(singleSearchPara[0],singleSearchPara[1])
           }
           else if(searchType[searchType.length-1] === serchingitem[3] ){
           // 29092016 [S] area search
//               console.log("[DBG]type3:[L]"+selectingArea.length+"\tp2"+selectingArea[0])
               processing.z = 60
               searchByArea(parseFloat(selectingArea[0]),parseFloat(selectingArea[1]),parseFloat(selectingArea[2]),parseFloat(selectingArea[3]))
           // 29092016 [E] area search
           }
           else if(searchType[searchType.length-1] === serchingitem[4] ){
           // 18092016 [E] predefine country search
           //preDefineCountry
               singleSearchPara = String(preDefineCountry[parseInt(searchPara[searchType.length-1])]).split(',')
//               console.log("[DBGc]p1:"+singleSearchPara[0]+"\tp2:"+singleSearchPara[1]+"\t")
               processing.z = 60
               searchByArea(parseFloat(singleSearchPara[0]),parseFloat(singleSearchPara[1]),parseFloat(singleSearchPara[2]),parseFloat(singleSearchPara[3]))
           // 18092016 [E] predefine country search
           }
      }
         else
        {//29092016 [S] area search - multi type search
            var multiSearchPara=[]

            for(var i=0;i<searchType.length;i++)
            {
                if(searchType[i] === serchingitem[3])
                {
                    multiSearchPara.push(serchingitem[3],selectingArea)
                }
                else if(searchType[i] === serchingitem[4])
                {
                    var longlatitude=String(preDefineCountry[parseInt(searchPara[searchType.length-1])]).split(',')
                    multiSearchPara.push(serchingitem[3],longlatitude)
                }
                else
                {
                    multiSearchPara.push(searchType[i],searchPara[i])
                }
            }
            //call the function to search
            //ToDO: remove it, debug only
            for(var j=0;j<multiSearchPara.length;j++)
                console.debug("[dubug multi para] j:"+j+"[para]"+multiSearchPara[j])
            searchByMultiPara(multiSearchPara)
        }//29092016 [E] area search - multi type search
    }
    // 14092016 [E] new search mechanism
    // 19092016 [S] area selection


    function areaSearchCheck(cbStatus)
    {
        controlMapMouse(cbStatus)
        areaSelectMode=cbStatus
    }
    // 19092016 [E] area selection


    Menu {
        id: menuFile
        title: qsTr("&Settings")
        MenuItem {
            text: qsTr("&Update Local DB")
            onTriggered: updateLocalDB();
        }
        MenuItem {
            text: qsTr("Update ElNino LaNina")
            onTriggered: updateElLa();
        }
    }

    toolBar : ToolBar {
            RowLayout {
                anchors.fill: parent

                ToolButton {
                    id : btnFilter
                    iconSource: "./images/" + dir[ppiRange] +"/filter.png"
                    visible: false
                    onClicked:  if(isFilterScreen === false){
                                    if(cycloneInfo.length > 0){
                                        stack.push(resultFilterView)
                                        isFilterScreen = true
                                        btnFilter.iconSource = "./images/" + dir[ppiRange] +"/filter_selected.png"
                                    }
                                }else{
                                    stack.pop(resultFilterView)
                                    isFilterScreen = false
                                    btnFilter.iconSource = "./images/" + dir[ppiRange] +"/filter.png"
                                }
                }

                ToolButton {
                    id : btnChart
                    iconSource: "./images/" + dir[ppiRange] +"/Bar.png"
                    visible: false
                    onClicked:     if(window.isReportScreen === false && window.isSearchScreen===false){
                                    if(window.isChartScreen !== false){
                                        window.isChartScreen = false;
                                        stack.pop();
                                    }
                                    window.isChartScreen = true;
                                    stack.push(mychartView);
                                }
                }

                ToolButton {
                    id : btnClearMap
                    iconSource: "./images/" + dir[ppiRange] +"/clear.png"
                    visible: false
                    onClicked: {clearMap()}
                }


                ToolButton {
                    id : btnExportCSV
                    iconSource: "./images/" + dir[ppiRange] +"/report.png"
                    visible: false
                    onClicked:  if(window.isReportScreen === false){
                                    if(window.isSearchScreen !== false){
                                        window.isSearchScreen = false;
                                        stack.pop();
                                    }
                                    window.isReportScreen = true;
                                    stack.push(reportView);
                                    txtInfo.text = "";
                                }
                }

                Item { Layout.fillWidth: true }
                ToolButton {

                    iconSource: "./images/" + dir[ppiRange] +"/search.png"
                    onClicked: if(window.isSearchScreen === false){
                                    if(window.isReportScreen !== false){
                                        window.isReportScreen = false;
                                        stack.pop();
                                    }
                                    // close the bar chart
                                    if(window.isChartScreen !== false){
                                        window.isChartScreen = false;
                                        stack.pop();
                                    }
                                    //
                                    window.isSearchScreen = true;
                                    stack.push(searchingView);
                                    txtInfo.text = "";

//                                    if(isFilterScreen === true){
//                                        stack.pop(resultFilterView)
//                                        isFilterScreen = false
//                                        btnFilter.iconSource = "./images/" + dir[ppiRange] +"/filter.png"
//                                    }
                                }

                }
                ToolButton {
                    visible: {if(window._platform == "2") return true;
                                else
                                    return false;
                        }
                    iconSource: "./images/" + dir[ppiRange] +"/setting.png"
                    onClicked: menuFile.popup()
                }

                ToolButton {
                    visible: {if(window._platform == "2") return true;
                                else
                                    return false;
                        }
                   // iconSource: "./images/" + dir[ppiRange] +"/setting.png"
                    text : "Prediction"
                    onClicked: {
                        if(window.isPredictScreen === false){
                             if(window.isSearchScreen !== false){
                                  window.isSearchScreen = false;
                                  stack.pop();
                             }
                             if(window.isReportScreen !== false){
                                window.isReportScreen = false;
                                 stack.pop();
                             }

                             window.isPredictScreen = true;
                             stack.push(predictView);
                             txtInfo.text = "";
                        }else{
                            window.isPredictScreen = false;
                            stack.pop();
                        }

                        //predictAreaSel = true;
                        //areaSelectMode = true;
                        //areaSearchCheck(areaSelectMode);


                    }
                }

                ToolButton {
                    text: "About"
                   //iconSource: "save-as.png"
                    onClicked:  stack.push(submitTextField("hello"))//console.log(dir[ppiRange])

                }


            }
        }


    StackView {
          id: stack
          anchors.fill: parent
          anchors.bottom: parent.toolBar
          objectName: "stack"
          delegate: StackViewDelegate {
                 function transitionFinished(properties){
                     if(window._platform === "2"){
                        properties.exitItem.visible = true
                     }
                 }
             }

          function enableMouse(){

          }
    }
    Plugin {
        id: mapProvider
        name: "mapbox"
        PluginParameter { name: "useragent"; value: "TrAp" }
        PluginParameter { name: "mapbox.access_token"; value: "sk.eyJ1IjoidW1haXIzMDQiLCJhIjoiY2lzNGZkN2w0MDhwejJzbzB0ZmI0ZWp4MCJ9.7ix5rlax1msmBda2ZOeOlQ"}
        PluginParameter { name: "mapbox.map_id"; value: "mapbox.satellite" }
    }

Location{
    id: myCentre
    coordinate {
        latitude : -30.00
        longitude : 135.00
    }
}

Component {
    id: mapView


    Item{
        id : item
        objectName: "item"
        anchors.fill: parent


        function enableMouse(){
            map.enableMouse();
        }
        Rectangle{
            color: "transparent"
            border.color: "red"
            x : 0
            y : 0
            width: 0
            height: 0
            z : 55
            id : dragRect
         //   radius: width*0.5
        }


            Rectangle{
                z: 55
                id: infoBox
                visible: false
                color: "white"
                width:100
                height : 100
                Text {
                    id: detail
                    text: qsTr("text")
                    color: "black"
                }

                Button{
                    text: qsTr("OK")
                    onClicked: {infoBox.visible = false}
                }
        }

        Map {
            id : map
            objectName: "map"
            anchors.fill: parent
            plugin: mapProvider
            gesture.enabled: true
            enabled: true
            center : myCentre.coordinate //22082016
            zoomLevel: 4

            property variant cyclones : []

            /*********************************************
            *   plot data
            **********************************************/
            function plotHindCastResult(data){
//               console.log(data);                
                predictdataset = new Array(data.length)
                for(var i = 0; i < data.length; i++){
                    var points = data[i].result;
                    var temp = new Array(points.length);
                    for(var j = 0; j < points.length; j++){
                        console.log(points[j].x + " , " + points[j].y);
                        temp[j] = points[j].y;
                    }
                    predictdataset[i]=temp
                }
                var component = Qt.createComponent("MyhistogramWindow.qml")
                var myhisgwin    = component.createObject(window,{"predictionData":predictdataset});
                myhisgwin.show();
            }


            /*********************************************
            *   Open prediction window if nodel generated
            **********************************************/

            function onModelGenerated(){

                txtInfo.text = "";
                messageDialog.title = "Prediction"
                messageDialog.text = "model generated successfully..";
                messageDialog.open();

                stack.push(testPredictModel);


            }


            /*************************************
            *   Show Status
            **************************************/

            function showStatus(msg){
                txtInfo.text = msg;
            }



            /*************************************
            *   Clear cyclones from map
            **************************************/

            function clearMap(){
                map.clearMapItems();
                map.cyclones = [];
                btnExportCSV.visible = false;
                // 26092016 [S] ChartView show after search
                btnChart.visible = false;
                // 26092016 [E] ChartView show after search
                txtInfo.text = "";
                txtResultCount.text = ""
            }



            /**************************************************
            *   Enable mouse on map after region selection
            *************************************************/

            function enableMouse(){
                mapMouseArea.enabled = true;
            }



            /***********************************************
            *   Disable mouse on map before region selection
            ***********************************************/

            function disableMouse(){
                mapMouseArea.enabled = false;
            }


            /*************************************
            *   Show Report generation status
            **************************************/

            function reportGenerated(msg){
                txtInfo.text = msg;
            }


            /*************************************
            *   Display error message and clear memory
            **************************************/

            function searchError(){
//                cbSelectArea.checked = false;
                window.isSearching = false;
                btnExportCSV.visible = false;
                // 26092016 [S] ChartView show after search
                btnChart.visible = false;
                // 26092016 [E] ChartView show after search
                txtInfo.text = "Search Timeout: Server or connection error";
                txtResultCount.text = ""
                processing.z = 0
                for(var i = 0; i< cycloneInfo.length;i++)
                    cycloneInfo.pop();
                map.cyclones = [];
                map.clearMapItems();
            }



            /*****************************************************
            *   Display message no cyclone found and clear memory
            *****************************************************/

            function noResult(){
//                cbSelectArea.checked = false;
                window.isSearching = false;

                btnExportCSV.visible = false;
                // 26092016 [S] ChartView show after search
                btnChart.visible = false;
                // 26092016 [E] ChartView show after search
                txtInfo.text = "No Cyclones Found..";
                processing.z = 0
                for(var i = 0; i< cycloneInfo.length;i++)
                    cycloneInfo.pop();

                map.clearMapItems();
                map.cyclones = [];
            }

    //        activeMapType: supportedMapTypes[1]

            //1. each cyclone track woule be the same color
            //2. the point of cyclone use different color show the intensity
            function setChartInfo()
            {
                //clean
                catelist=[]
                catevalues=[]
                rangemax=[]
                rangemin=[]
//                   console.debug("[debug count]count cate:"+catelist.length+"\tvalue:"+catevalues.length + " - [cyc]:"+cycloneInfo.length)
//                if(selectinfo)
//                {
                    //var
                    var years=[]
                    var tempyearscount=0
                    var yearscount=[]
                    //
                //If select to show year
                    if(cycloneInfo.length===1)
                    {
                        years.push(cycloneInfo[cycloneInfo.length-1].seasonYear)
                        yearscount.push(cycloneInfo.length)
                    }
                    else{
                    for(var i=0;i<cycloneInfo.length;i++)
                    {
                        if(i==0)
                        {
                            years.push(cycloneInfo[i].seasonYear)
                            tempyearscount++
//                                    console.debug("[Debug]year:["+cycloneInfo[i].seasonYear+"]\tcount:[]"+tempyearscount+"]\n")
                        }
                        else
                        {
                            if(years[years.length-1]===cycloneInfo[i].seasonYear)
                            {// if the same year then
                                tempyearscount++
//                                console.debug("[Debug2]year:["+cycloneInfo[i].seasonYear+"]\tcount:[]"+tempyearscount+"]\n")
                            }
                            else // different year
                            {
                                yearscount.push(tempyearscount)
                                tempyearscount=1 //03102016 fix the issue
//                                console.debug("[Debug3]year:["+cycloneInfo[i].seasonYear+"]\tcount:[]"+tempyearscount+"]\n")
                                years.push(cycloneInfo[i].seasonYear)
                            }
                            if(i===cycloneInfo.length-1) //the last item
                            {
                                yearscount.push(tempyearscount)
//                                tempyearscount=0
//                                console.debug("[Debug4]year:["+cycloneInfo[i].seasonYear				+"]\tcount:[]"+tempyearscount+"]\n")
                            }
                        }
                    }
                    }
                    //update
//                    cvCleanFlag=true
                    catelist=years
                    catevalues=yearscount
                    rangemax=Math.max(yearscount)
                    rangemin=Math.min(yearscount)
//                    console.debug("[debug count_main2]count cate:"+catelist.length+"\tvalue:"+catevalues.length)
//                    cvCleanFlag=false
//                }
            }

            function searchResult(data, current, total){
                //ToDo: clear function
                console.log(" data len = " + data + " c =" + current + " t = " + total)
                //                cbSelectArea.checked = false;
                // 19092016 [S] area selection
                areaSelectMode  = false
                // 19092016 [E] area selection
                window.isSearching = false;


                //start drawing
                if(data !== undefined){

                    if(current === 0){

                        btnExportCSV.visible = false;
                        // 26092016 [S] ChartView show after search
                        btnChart.visible = false;
                        // 26092016 [E] ChartView show after search
                        txtInfo.text = "";
                        processing.z = 0
                        window.mapView = map;
                        for(var i = 0; i< cycloneInfo.length;i++)
                            cycloneInfo.pop();
                        cycloneInfo = []
                        map.cyclones = [];
                        map.clearMapItems();
                        if(isFilterScreen === true){
                            stack.pop(resultFilterView)
                            isFilterScreen = false
                            btnFilter.iconSource = "./images/" + dir[ppiRange] +"/filter.png"
                        }
                    }

                    txtResultCount.text = "Cyclones Loaded: " + (current+1) + " / " +total
                    btnClearMap.visible = true;

                    // start drawing
                    //for(var i=0;i<data.length;i++)
                    //{
                        cycloneInfo.push(data)
                        // drawing track (if tracks are available)
                        if( data.tracks.length>0)
                        {
                            var trackData = []
                            var points = [];
                            var lines = [];
                            var startpoint;
                            for(var j = 0; j < data.tracks.length;j++)
                            {
                                // 29092016 [S] the degree more than 180 issue - work around
                                if(data.tracks[j].longitude>180)
                                   data.tracks[j].longitude=data.tracks[j].longitude-360.0
                                // 29092016 [E] the degree more than 180 issue - work around

                                if(j==0 && data.tracks.length >1)
                                {// 14092016 start point
                                    startpoint = Qt.createQmlObject('import QtLocation 5.3;import QtQuick 2.7;
                                                                            MapQuickItem { id: cyclonemarker;
                                                                            anchorPoint.x: image.width * 0.5;
                                                                            anchorPoint.y: image.height * 0.5;
                                                                            sourceItem: Image { id: image;
                                                                            source: "./images/" + dir[ppiRange] +"/hurricane.png"}
                                                                            scale: map.zoomLevel/10
                                                                               }',map)
                                    startpoint.coordinate = QtPositioning.coordinate(data.tracks[j].latitude,data.tracks[j].longitude)
                                    map.addMapItem(startpoint)
                                }
                                else
                                {// 14092016 normal cycle
                                    var circle = Qt.createQmlObject('MapCircleCustom {}',map)
                                    circle.color = getTrackColor(data.tracks[j].windSpeed)
                                    circle.center = QtPositioning.coordinate(data.tracks[j].latitude,data.tracks[j].longitude)
                                    circle.track = data.tracks[j]
                                    map.addMapItem(circle)
                                    points.push(circle)

                                }
                                // // 28082016  update to match the requirement Line function
                                if(j>0)
                                {
                                    var Polyline = Qt.createQmlObject('MapPolylineCustom {}',map)
                                    Polyline.addCoordinate(QtPositioning.coordinate(data.tracks[j-1].latitude,data.tracks[j-1].longitude))
                                    Polyline.addCoordinate(QtPositioning.coordinate(data.tracks[j].latitude,data.tracks[j].longitude))
//                                    console.log(data[i].tracks[j-1].latitude+","+data[i].tracks[j-1].longitude +" - "+ data[i].tracks[j].latitude+","+data[i].tracks[j].longitude)
                                    Polyline.line.color = getTrackColor(data.tracks[j].windSpeed)
                                    Polyline.color = getTrackColor(data.tracks[j].windSpeed)
                                    Polyline.line.width = 5
                                    //Polyline.btnReport = btnExportCSV
                                    Polyline.platform = window._platform
                                    Polyline.txtInfo = txtInfo
                                    Polyline.track = data.tracks[j]
                                    Polyline.cyclone = data
                                    lines.push(Polyline)
                                }
                            }


                            trackData.push(startpoint);
                            trackData.push(points);
                            trackData.push(lines);
                            trackData.push(true);
                            map.cyclones.push(trackData);

                            for(var k = 0; k < lines.length;k++){
                                lines[k].otherLines = lines
                                map.addMapItem(lines[k])
                            }
                        }
                   // }
                        if(current+1===total)
                        {
                            setChartInfo()
                            if(window._platform === "2"){
                                btnExportCSV.visible = true;
                                // 26092016 [S] ChartView show after search
                                btnChart.visible=true;
                                txtResultCount.text = "Total Cyclones: " + total
                                btnFilter.visible = true
                                // 26092016 [E] ChartView show after search
                            }
                        }

                }else{
                    btnExportCSV.visible = false;
                    txtInfo.text = "";
                    processing.z = 0
                    txtResultCount.text = ""
                    window.mapView = map;
                    for(var i = 0; i< cycloneInfo.length;i++)
                        cycloneInfo.pop();
                    cycloneInfo = []
                    map.cyclones = [];
                    map.clearMapItems();

                    btnClearMap.visible = false;

                    if(window._platform === "2"){
                        btnExportCSV.visible = false
                        // 26092016 [S] ChartView show after search
                        btnChart.visible = false;
                        // 26092016 [E] ChartView show after search
                        btnFilter.visible = false
                    }
                    if(isFilterScreen === true){
                        stack.pop(resultFilterView)
                        isFilterScreen = false
                        btnFilter.iconSource = "./images/" + dir[ppiRange] +"/filter.png"
                    }

                }
            }

         }

        MouseArea {
                id : mapMouseArea
                anchors.fill: parent
                enabled: false
                property bool mouseDown : false
                property int lastX : -1
                property int lastY : -1

                onWheel: {
                   if(wheel.angleDelta.y > 0){
                       if (map.zoomLevel < map.maximumZoomLevel)
                           map.zoomLevel += 1
                   }else{
                       if (map.zoomLevel > map.minimumZoomLevel)
                           map.zoomLevel -= 1
                   }

                }

                onPressed : {

                    mouseDown = true
                    lastX = mouse.x
                    lastY = mouse.y
                    dragRect.x = lastX
                    dragRect.y = lastY
                }

                onReleased : {

                    mouseDown = false
                    lastX = -1
                    lastY = -1

//                    if(cbSelectArea.checked === true && window.isSearching === false){ //old
                        if(areaSelectMode && window.isSearching === false){
                        var startPoint = map.toCoordinate(Qt.point(dragRect.x, dragRect.y))
                        var endPoint = map.toCoordinate( Qt.point((dragRect.x + dragRect.width) , (dragRect.y + dragRect.height)))
                        //var radius = (startPoint.distanceTo(endPoint)/1000)/2;
                        //radius += "";
                        var lat1 = startPoint.latitude+"";
                        var lng1 = startPoint.longitude+"";
                        var lat2 = endPoint.latitude+"";
                        var lng2 = endPoint.longitude+"";

/*                        if(radius > 200){
                            processing.z = 60
                            window.isSearching = true;
                            searchByArea(lat, lng, radius )
                        }
*/
//                        searchByArea(lat1, lng1, lat2,lng2 )old
                        // 29092016 [E] var for searching
//                            console.debug("[dbg][mouse postition]")
                        selectingArea=[]; //26102016 fix area search bug
                        selectingArea.push(lat1, lng1, lat2,lng2)
                        areaSelectMode=false

                        if(predictAreaSel === true){
                            predictCyclones(lat1, lng1, lat2,lng2, modelID, _burnin, _update, _elSeason)

                            predictAreaSel = false
                        }else{
                            doSearch()
                            areaSearchCheck(areaSelectMode)//06102016 fix bug - doubleClicked not work
                        }
                        // 29092016 [E] var for searching
                        dragRect.x = 0
                        dragRect.y = 0
                        dragRect.height = 0
                        dragRect.width = 0
                    }


                    /*if( map.points.length > 0 ){//&& lastCheck == false){
                        var _points = []

                        for(var i = 0 ; i < map.points.length; i++){
                            if(isNaN(map.fromCoordinate(map.points[i][0].center).x) === false){
                                var point = []
                                point.push(map.fromCoordinate(map.points[i][0].center))
                                point.push(map.points[i][1])
                                _points.push(point)
                            }
                        }

                       // console.log(_points.length)
                        Utils.selectMapItem(Qt.point(mouse.x, mouse.y), _points)
                        lastCheck = true
                    }*/
                }

                onPositionChanged: {
                    if (mouseDown) {
                        var dx = mouse.x - lastX
                        var dy = mouse.y - lastY
                        lastX = mouse.x
                        lastY = mouse.y
//                        if(cbSelectArea.checked === true){//old
                        if(areaSelectMode === true){
                            dragRect.height = mouse.x - dragRect.x//mouse.y - dragRect.y
                            dragRect.width = mouse.x - dragRect.x
                        }else{
                            map.pan(-dx, -dy)
                        }

                 }
                }
                onDoubleClicked: {
                    map.center = map.toCoordinate(Qt.point(mouse.x, mouse.y))
                    if (map.zoomLevel < map.maximumZoomLevel)
                        map.zoomLevel += 1
//                    console.log(map.toCoordinate(Qt.point(mouse.x, mouse.y)))
                }
            }
       /*29082016 [S] add zoom in/out button*/


        Button {
            id: buttonZoomout
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            text: qsTr("-")
            onClicked: {
                map.zoomLevel=map.zoomLevel-0.2
            }
        }
        Button {
            id: buttonZoomin
            anchors.left: buttonZoomout.left
            anchors.bottom: buttonZoomout.top
            text: qsTr("+")
            onClicked: {
                    map.zoomLevel=map.zoomLevel+0.2
            }
        }
        /*29082016 [E] add zoom in/out button*/
    }

}


    Component {
        id: testPredictModel
        TestPredictionModel {

        }
    }

    Component {
        id: predictView
        PredictionView {
            id: pView


        }
    }


    Component {
            id: searchingView
            Searching {
                id: f2
            }
        }

    Component {
            id: reportView
            GenerateReport {
                id: report
            }
        }

    Component {
            id: resultFilterView
            ResultFilter {
                id: filter
                cyclones : cycloneInfo
                items : window.mapView.cyclones;
            }
        }

    Component.onCompleted: { stack.push(mapView);
                           // window.mapView = mapView;
    }
    // 21092016 [S] BarChart

    Component {
            id: mychartView
            MyChartView {
                categorieslist :  catelist
                categoriesvalues :   catevalues
                rangeMax : rangemax
                rangeMin : rangemin
                cvtitle: "The number of cyclone in the year"
            }

    }

    // 21092016 [E] BarChart
//    Component.onCompleted: { stack.push(mapView); }

    // [S] intensity info
    Rectangle{
                id: intensityinfo
                visible: true
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.margins: 10
                width: 30
                height : 200
                color: "transparent"
                ColumnLayout{
                    Rectangle{
                        id:iR0
                        anchors.top : parent.top
                        anchors.left:  parent.left
                        anchors.margins: 5
                        width: 20
                        height : 20
                        color: intensity_colours[0]
                        Text {
                            id: intensity0
                            text: qsTr("NA")
                            font.pixelSize:  if(window._platform === "1"){12}
                                             else{0}
                        }
                    }
                    Rectangle{
                        id:iR1
                        anchors.top: iR0.bottom
                        anchors.left:  parent.left
                        anchors.margins: 5
                        width: 20
                        height : 20
                        color: intensity_colours[1]
                        Text {
                            id: intensity1
                            text: qsTr("TD")
                            font.pixelSize:  if(window._platform === "1"){12}
                                            else{0}
                        }
                    }
                    Rectangle{
                        id:iR2
                        anchors.top :  iR1.bottom
                        anchors.left:  parent.left
                        anchors.margins: 5
                        width: 20
                        height : 20
                        color: intensity_colours[2]
                        Text {
                            id: intensity2
                            text: qsTr("TS")
                            font.pixelSize:  if(window._platform === "1"){12}
                                             else{0}
                        }
                    }
                    Rectangle{
                        id:iR3
                        anchors.top : iR2.bottom
                        anchors.left:  parent.left
                        anchors.margins: 5
                        width: 20
                        height : 20
                        color: intensity_colours[3]
                        Text {
                            id: intensity3
                            text: qsTr("H1")
                            font.pixelSize:  if(window._platform === "1"){12}
                                            else{0}
                        }
                    }
                    Rectangle{
                        id:iR4
                        anchors.top : iR3.bottom
                        anchors.left:  parent.left
                        anchors.margins: 5
                        width: 20
                        height : 20
                        color: intensity_colours[4]
                        Text {
                            id: intensity4
                            text: qsTr("H2")
                            font.pixelSize:  if(window._platform === "1"){12}
                                             else{0}
                        }
                    }
                    Rectangle{
                        id:iR5
                        anchors.top : iR4.bottom
                        anchors.left:  parent.left
                        anchors.margins: 5
                        width: 20
                        height : 20
                        color: intensity_colours[5]
                        Text {
                            id: intensity5
                            text: qsTr("H3")
                            font.pixelSize:  if(window._platform === "1"){12}
                                            else{0}
                        }
                    }
                    Rectangle{
                        id:iR6
                        anchors.top :iR5.bottom
                        anchors.left:  parent.left
                        anchors.margins: 5
                        width: 20
                        height : 20
                        color: intensity_colours[6]
                        Text {
                            id: intensity6
                            text: qsTr("H4")
                            font.pixelSize:  if(window._platform === "1"){12}
                                            else{0}
                        }
                    }
                    Rectangle{
                        id:iR7
                        anchors.top :iR6.bottom
                        anchors.left:  parent.left
                        anchors.margins: 5
                        width: 20
                        height : 20
                        color: intensity_colours[7]
                        Text {
                            id: intensity7
                            text: qsTr("H5")
                            font.pixelSize:  if(window._platform === "1"){12}
                                            else{0}
                        }
                    }
                }
            }
            // [S] intensity info
}
