import QtQuick 2.3
import QtQuick.Window 2.2
import QtQuick.Controls 1.4
import QtWebView 1.0
import QtQuick.Layouts 1.1
import QtQuick.Controls.Styles 1.4
import QtQuick.Dialogs 1.2
import Cyclone 1.0
import QtLocation 5.5
import QtPositioning 5.3

ApplicationWindow  {
    title: "TrAp - FedUni Project"
    width: screenWidth
    height : screenHeight
    color: "#4355e6"
    visible: true
    id : window
    property bool isSearching: false
    property string info : ""
    property string _platform: platform
    property string mapUrl: initialUrl
    property bool isSearchScreen: false
    property int ppi: Screen.pixelDensity*25.4
    property variant cycloneInfo: []
    property var dir: ["MDPI","HDPI","XHDPI","XXHDPI",
                                        "XXXHDPI","XXXXHDPI"]

    property var intensity_colours: ['#ffffff','#5ebaff','#00faf4','#ffff99','#ffe775','#ffc140','#ff8f20','#ff6060'] //28082016 Changed from #ffffcc to #ffff99

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



    //Info Box
    function showTrackInfo(_data){
     //   console.log(_data)

        messageDialog.text = _data;
        messageDialog.open();
    }


    function getCycloneByID(_id){
        console.log("cycloneID = " +  _id);
        console.log("cycloneInfo length = " + cycloneInfo.length);

        for(var i = 0; i < cycloneInfo.length; i++){
            if(cycloneInfo[i].cycloneID === _id){
                console.log()
                return cycloneInfo[i];
            }
        }
        return null;
    }

    /*****************************************/

    //signals
    signal submitTextField(string text)
    signal searchByName(string text)//18082016
    signal searchByYear(string text)
    signal searchByArea(string lat, string lng, string radius)
    signal controlMapMouse(bool status);
    //  signal sendWebView(WebEngineView view)

    // slots
    function setTextField(text){
         console.log("setTextField: " + text)

        stack.zoomIn();
    }

    function doSearch(type, content){
        window.isSearchScreen = false;
            console.log("Search: " + type + " "+ content)
        if(type === "name")
        {
            searchByName(content);
        }else if(type === "year" ){
            searchByYear(content);
        }else if(type === "country" ){

        }

      //  window.newWidth = screenWidth
      //  window.newHeight = screenHeight

    }


    Menu {
        id: menuFile
        title: qsTr("&File")
        MenuItem {
            text: qsTr("&Open")
            onTriggered: submitTextField("hello")
        }
        MenuItem {
            text: qsTr("E&xit")
            onTriggered: Qt.quit();
        }
    }

    toolBar : ToolBar {
            RowLayout {
                anchors.fill: parent
                CheckBox{
                    id : cbSelectArea
                    text : "Select Area"
                    onCheckedChanged: {controlMapMouse(cbSelectArea.checked)}
                }
                Item { Layout.fillWidth: true }
                ToolButton {

                    iconSource: "./images/" + dir[ppiRange] +"/search.png"
                    onClicked: if(window.isSearchScreen == false){
                                   window.isSearchScreen = true;
                                 //  window.newWidth = screenWidth - screenWidth*.5
                                   //window.newHeight = screenHeight - screenHeight*.5
                                   stack.push(searchingView);}

                }
                ToolButton {

                    iconSource: "./images/" + dir[ppiRange] +"/setting.png"
                    onClicked: menuFile.popup()
                }
                ToolButton {
                    text: "About"
                   //iconSource: "save-as.png"
                    onClicked: console.log(dir[ppiRange])
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
            radius: width*0.5
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

            property variant points : []


            function enableMouse(){
                mapMouseArea.enabled = true;
            }


            function disableMouse(){
                mapMouseArea.enabled = false;
            }

    //        activeMapType: supportedMapTypes[1]

            //1. each cyclone track woule be the same color
            //2. the point of cyclone use different color show the intensity

            function searchResult(data){
                //ToDo: clear function
               // console.log(" data len = " + data.length)

                cbSelectArea.checked = false;
                window.isSearching = false;
                processing.z = 0

                for(var i = 0; i< cycloneInfo.length;i++)
                    cycloneInfo.pop();

                map.clearMapItems();

                for(var i = 0; i< cycloneInfo.length;i++)
                    map.points.pop();

                //start drawing
                if(data.length > 0){
                    // start drawing
                    for(var i=0;i<data.length;i++)
                    {
                        cycloneInfo.push(data[i])
                        // drawing track (if tracks are available)
                        if( data[i].tracks.length>0 )
                        {
                            for(var j = 0; j < data[i].tracks.length;j++)
                            {
                               // console.log(data[i].tracks[j].latitude + " " + data[i].tracks[j].longitude);
                                var Polyline = Qt.createQmlObject('import QtLocation 5.3; MapPolyline {}',map)
                                var circle = Qt.createQmlObject('MapCircleCustom {}',map)

                                Polyline.addCoordinate(QtPositioning.coordinate(data[i].tracks[j].latitude,data[i].tracks[j].longitude))
                                // 28082016  update to match the requirement
                                if(data[i].tracks[j].windSpeed===-999)
                                        circle.color = intensity_colours[0]
                                else if(data[i].tracks[j].windSpeed<34)
                                        circle.color = intensity_colours[1]
                                else if(data[i].tracks[j].windSpeed<64)
                                        circle.color = intensity_colours[2]
                                else if(data[i].tracks[j].windSpeed<83)
                                        circle.color = intensity_colours[3]
                                else if(data[i].tracks[j].windSpeed<96)
                                        circle.color = intensity_colours[4]
                                else if(data[i].tracks[j].windSpeed<113)
                                        circle.color = intensity_colours[5]
                                else if(data[i].tracks[j].windSpeed<137)
                                        circle.color = intensity_colours[6]
                                else
                                        circle.color = intensity_colours[7]
                                //
                                circle.center = QtPositioning.coordinate(data[i].tracks[j].latitude,data[i].tracks[j].longitude)
                                circle.track = data[i].tracks[j]
                                //
                                map.addMapItem(circle)

                                // // 28082016  update to match the requirement Line function
                                if(j>0)
                                {
                                    Polyline.addCoordinate(QtPositioning.coordinate(data[i].tracks[j-1].latitude,data[i].tracks[j-1].longitude))
                                    Polyline.addCoordinate(QtPositioning.coordinate(data[i].tracks[j].latitude,data[i].tracks[j].longitude))
                                    //

                                    if(data[i].tracks[j-1].windSpeed===-999)
                                            Polyline.line.color = intensity_colours[0]
                                    else if(data[i].tracks[j-1].windSpeed<34)
                                            Polyline.line.color = intensity_colours[1]
                                    else if(data[i].tracks[j-1].windSpeed<64)
                                            Polyline.line.color = intensity_colours[2]

                                    else if(data[i].tracks[j-1].windSpeed<83)
                                           Polyline.line.color = intensity_colours[3]
                                    else if(data[i].tracks[j-1].windSpeed<96)
                                           Polyline.line.color = intensity_colours[4]
                                    else if(data[i].tracks[j-1].windSpeed<113)
                                            Polyline.line.color = intensity_colours[5]
                                    else if(data[i].tracks[j-1].windSpeed<137)
                                            Polyline.line.color = intensity_colours[6]
                                    else
                                            Polyline.line.color = intensity_colours[7]

                                    Polyline.line.width = 3
                                    map.addMapItem(Polyline)
                                }
                            }
                        }
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

                    if(cbSelectArea.checked === true && window.isSearching === false){

                        var startPoint = map.toCoordinate(Qt.point(dragRect.x, dragRect.y))
                        var endPoint = map.toCoordinate( Qt.point((dragRect.x + dragRect.width) , (dragRect.y + dragRect.height)))
                        var radius = (startPoint.distanceTo(endPoint)/1000)/2;
                        radius += "";
                        var lat = startPoint.latitude+"";
                        var lng = startPoint.longitude+"";
                        if(radius > 200){
                            processing.z = 60
                            window.isSearching = true;
                            searchByArea(lat, lng, radius )
                        }
                        dragRect.x = 0
                        dragRect.y = 0
                        dragRect.height = 0
                        dragRect.width = 0
                    }


                    if( map.points.length > 0 ){//&& lastCheck == false){
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
                    }
                }

                onPositionChanged: {
                    if (mouseDown) {
                        var dx = mouse.x - lastX
                        var dy = mouse.y - lastY
                        lastX = mouse.x
                        lastY = mouse.y
                        if(cbSelectArea.checked === true){
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
                    console.log(map.toCoordinate(Qt.point(mouse.x, mouse.y)))
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
            anchors.left: buttonZoomout.left +10
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
            id: searchingView
            Searching {
                id: f2
            }
        }

    Component.onCompleted: { stack.push(mapView); }
}
