import QtQuick 2.5
import QtQuick.Window 2.2
import QtQuick.Controls 1.4
import QtWebView 1.0

ApplicationWindow  {
    title: "TrAp - FedUni Project"
    width: 640
    height : 400
    visible: true

    TabView {
        id: tabView1
        anchors.fill: parent
        Tab {
               title: "Tab 1"
               Rectangle {
                anchors.fill: parent
                Text {
                    anchors.centerIn: parent
                    text: qsTr("TrAp Project")
                }
               }
        }
           Tab {
               title: "Map"
               Map{
                   anchors.rightMargin: 0
                   anchors.bottomMargin: 0
                   anchors.leftMargin: 0
                   anchors.topMargin: 0
                   anchors.fill: parent

               }
           }
           Tab {
               title: "Tab 3"
               MainForm {
                   anchors.rightMargin: 0
                   anchors.bottomMargin: 0
                   anchors.leftMargin: 0
                   anchors.topMargin: 0
                   anchors.fill: parent
                   //   mouseArea.onClicked: {
                   //   Qt.quit();
                   //}
               }
           }
    }

}
