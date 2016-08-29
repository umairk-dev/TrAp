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

    //Info Box
    function showInfo(_data, x, y){
        messageDialog.text = _data;
        messageDialog.open();
    }

    /*****************************************/

    //signals
    signal submitTextField(string text)
    signal searchByName(string text)//18082016
  //  signal sendWebView(WebEngineView view)

    // slots
    function setTextField(text){
         console.log("setTextField: " + text)

        stack.zoomIn();
    }

    function doSearch(type, content){
        window.isSearchScreen = false;
        if(type === "name")
        {
            searchByName(content);
        }else if(type === "year" ){

        }else if(type === "country" ){

        }

      //  window.newWidth = screenWidth
      //  window.newHeight = screenHeight
        console.log("Search: " + content)
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


          function zoomIn(){

              mapView.webView.zoomIn();

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
        anchors.fill: parent

        Rectangle{
            color: "red"
            x : 0
            y : 0
            width: 0
            height: 0
            z : 55
            id : dragRect
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
            center : myCentre.coordinate //22082016
            zoomLevel: 4

            property variant points : []

    //        activeMapType: supportedMapTypes[1]

            //1. each cyclone track woule be the same color
            //2. the point of cyclone use different color show the intensity
            function searchResult(data){
                //ToDo: clear function

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
                                var Polyline = Qt.createQmlObject('import QtLocation 5.3; MapPolyline {}',map)
                                var circle = Qt.createQmlObject('import QtLocation 5.3; MapCircle {}',map)
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
                                circle.radius = 10000.0
                                circle.border.width = 2
                                //
                                map.addMapItem(circle)

                                var point = []
                                point.push(circle)
                                point.push(data[i].tracks[j])
                                map.points.push(point)
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

            function selectMapItem(p){
                var select = map.fromCoordinate(p)
                console.log(" p = " + map.fromCoordinate(p))

                console.log(map.points)
                for(var i = 0 ; i < map.points.length; i++){

                    var point = map.fromCoordinate(map.points[i][0].center)
                   // console.log(point.x)
                    if(isNaN(parseFloat(point.x))){
                       // console.log("nan " + point)
                    }else{
                        console.log(point)
                        var l1 = Number(point.x)
                        var l2 = Number(select.x)

                        var l3 = l1 - l2
                        //console.log(point[0])
                       // console.log( l3 + " - " + (point[1] - select[1]) )
                        if(  Math.abs(parseFloat(point.x) - parseFloat(select.x)) <=5 &&  Math.abs(parseFloat(point.x) - parseFloat(select.x)) <=5){

                            var info = "TrackID : " + map.points[i][1].trackID + "\n"
                            info += "Wind Speed : " + map.points[i][1].windSpeed + "\n"
                            info += "Latitude : " + map.points[i][1].latitude + "\n"
                            info += "Longitude : " + map.points[i][1].longitude + "\n"
                            info += "Nature : " + map.points[i][1].nature + "\n"
                            console.log("Wind Speed: " + map.points[i][1].windSpeed)
                            console.log("Latitude: " + map.points[i][1].latitude)
                            console.log("Longitude: " + map.points[i][1].longitude)
                            console.log("Nature: " + map.points[i][1].nature)
                            showInfo(info, select.x, select.y);

                         //   detail.text = info;
                         //   info.x = map.points[i][1].latitude;
                         //   info.y = map.points[i][1].longitude;
                            //detail.visible = true;
                         //   info.visible = true;
                        }
                    }
                }
            }

         }

        MouseArea {
                anchors.fill: parent

                property bool mouseDown : false
                property int lastX : -1
                property int lastY : -1

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

                    dragRect.x = 0
                    dragRect.x = 0
                    dragRect.height = 0
                    dragRect.width = 0

                    map.selectMapItem(map.toCoordinate(Qt.point(mouse.x, mouse.y)))
                }

                onPositionChanged: {
                    if (mouseDown) {
                        var dx = mouse.x - lastX
                        var dy = mouse.y - lastY
                        map.pan(-dx, -dy)
                        lastX = mouse.x
                        lastY = mouse.y

                         console.log("x " + dragRect.x + " y" + dragRect.y + " nX" + mouse.x + " nY" + mouse.y )
                        dragRect.height = mouse.y - dragRect.y
                        dragRect.width = mouse.x - dragRect.x

                        console.log(dragRect.height)
                        console.log(dragRect.width)


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
