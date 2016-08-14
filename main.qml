import QtQuick 2.3
import QtQuick.Window 2.2
import QtQuick.Controls 1.4
import QtWebView 1.0
import QtQuick.Layouts 1.1
import QtQuick.Controls.Styles 1.4
import QtQuick.Dialogs 1.2


ApplicationWindow  {
    title: "TrAp - FedUni Project"
    width: 640
    height : 400
    visible: true
    id : window

    //signals
    signal submitTextField(string text)



    // slots
    function setTextField(text){
         console.log("setTextField: " + text)


    }



    Menu {
        id: menuFile
        title: qsTr("&File")
        MenuItem {
            text: qsTr("&Open")
            onTriggered: messageDialog.show(qsTr("Open action triggered"));
        }
        MenuItem {
            text: qsTr("E&xit")
            onTriggered: Qt.quit();
        }
    }

    toolBar : ToolBar {
            RowLayout {
                anchors.fill: parent

                ToolButton {
                    text: "Search"
                    //iconSource: "open.png"
                    onClicked: submitTextField("hello")
                }
                ToolButton {

                    iconSource: "setting.png"
                    onClicked: menuFile.popup()
                }
                ToolButton {
                    text: "About"
                    iconSource: "save-as.png"
                }
                Item { Layout.fillWidth: true }
                CheckBox {
                    text: "Enabled"
                    checked: true
                    Layout.alignment: Qt.AlignRight
                }
            }
        }




    Map{
        anchors.rightMargin: 0
        anchors.bottomMargin: 0
        anchors.leftMargin: 0
        anchors.topMargin: 0
        anchors.fill: parent
        anchors.bottom: parent.toolBar
        url: initialUrl
    }
}
