import QtQuick 2.3
import QtQuick.Window 2.2
import QtQuick.Controls 1.4
import QtWebView 1.0
import QtQuick.Layouts 1.1
import QtQuick.Controls.Styles 1.4
import QtQuick.Dialogs 1.2
import Cyclone 1.0
ApplicationWindow  {
    title: "TrAp - FedUni Project"
    width: screenWidth
    height : screenHeight
    visible: true
    id : window

    Cyclone{

    }
    property string _platform: platform
    property string mapUrl: initialUrl
    property bool isSearchScreen: false
    property int ppi: Screen.pixelDensity*25.4

    property var dir: ["MDPI","HDPI","XHDPI","XXHDPI",
                                        "XXXHDPI","XXXXHDPI"]
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



    Component {
        id: mapView

        WebView{
             id: webView
             anchors.fill: parent
             url: window.mapUrl
            objectName: "map"

            function searchResult(data){

                if(data.size() > 0){
                    console.log(data[0].cycloneName);
                    console.log(data[0].cycloneID);
                    console.log(data[0].basin);
                    console.log(data[0].subBasin);
                    console.log(data[0].seasonYear);


                    webView.runJavaScript("alert('hello');");
                }
            }
        }

        /*Map{
            id : map
            property string _url : window.mapUrl
        }*/
    }


    Component {
            id: searchingView
            Searching {
                id: f2
            }
        }

    Component.onCompleted: { stack.push(mapView); }

}
