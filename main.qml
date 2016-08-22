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

    property string _platform: platform
    property string mapUrl: initialUrl
    property bool isSearchScreen: false
    property int ppi: Screen.pixelDensity*25.4
    property variant cycloneInfo: []
    property var dir: ["MDPI","HDPI","XHDPI","XXHDPI",
                                        "XXXHDPI","XXXXHDPI"]

    property var track_colours: ['yellow','green','red','pink','white','ruby']
    property var intensity_colours: ['#ffffff','#3333ff','#006699','#009933','#cc9900','#cc0000','#cc00cc']

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

//    MapPolyline{
//        id : lines
//        line.width: 10
//        line.color: 'yellow'

//    }
//mycentre
Location{
    id: myCentre
    coordinate {
        latitude : -30.00
        longitude : 135.00
    }
}


Component {
    id: mapView
    Map {
        id : map
        objectName: "map"
        anchors.fill: parent
        plugin: mapProvider
        gesture.enabled: true
        center : myCentre.coordinate //22082016
        zoomLevel: 4
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
//                    var co = Qt.createComponent('polyLine.qml')
                    cycloneInfo.push(data[i])
                    // drawing track (if tracks are available)
                    if( data[i].tracks.length>0 )
                    {
                        var Polyline = Qt.createQmlObject('import QtLocation 5.3; MapPolyline {}',map)                        
                        for(var j = 0; j < data[i].tracks.length;j++)
                        {
                            var circle = Qt.createQmlObject('import QtLocation 5.3; MapCircle {}',map)
                            Polyline.addCoordinate(QtPositioning.coordinate(data[i].tracks[j].latitude,data[i].tracks[j].longitude))
                            //Note: ET >  TS TD > SS SD >  L > NR
                            switch(data[i].tracks[j].nature)
                            {
                                case 'NA':
                                case 'NR':
                                    circle.color = intensity_colours[0]
                                    break
                                case 'L':
                                    circle.color = intensity_colours[1]
                                    break
                                case 'SS':
                                    circle.color = intensity_colours[2]
                                    break
                                case 'SD':
                                    circle.color = intensity_colours[3]
                                    break
                                case 'TS':
                                    circle.color = intensity_colours[4]
                                    break
                                case 'TD':
                                    circle.color = intensity_colours[5]
                                    break
                                case 'ET':
                                    circle.color = intensity_colours[6]
                                    break
                            }
                            //
                            circle.center = QtPositioning.coordinate(data[i].tracks[j].latitude,data[i].tracks[j].longitude)
                            circle.radius = 10000.0
                            circle.border.width = 5
                            map.addMapItem(circle)
                        }
                            Polyline.line.color = track_colours[i%track_colours.length]//'yellow'
                            Polyline.line.width = 3
                            map.addMapItem(Polyline)
                    }
                }

            }
        }

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
