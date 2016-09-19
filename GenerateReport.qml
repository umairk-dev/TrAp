import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.2
import QtQuick.Window 2.0
import QtQuick.Layouts 1.1
import QtQuick.Controls.Styles 1.4

Rectangle {
    id: rview
    color : "transparent"

    FileDialog {
        id: fileDialog
        property string type
        title: "Save Report"
        folder: shortcuts.home
        modality : "ApplicationModal"
        selectExisting: false

        onAccepted: {
            console.log("You chose: " + fileDialog.fileUrls)
            fileDialog.close();
            fileDialog.visible = false;
            _generateReport(type, fileDialog.fileUrl)
            window.isReportScreen = false
            stack.pop();
        }
        onRejected: {
            console.log("Canceled");
            fileDialog.close();
            fileDialog.visible = false;
        }
        //Component.onCompleted: {visible = false; close();}
    }

    ColumnLayout {
        id: columnLayout1
        spacing : 20
        Label {
            id: labelTitle
            color : "white"
            text: qsTr("Generate Report: ")
            Layout.topMargin: 10
            Layout.leftMargin: 10
        }

       ExclusiveGroup { id: searchTypeGroup }
       RadioButton {
                id: rbAll
                exclusiveGroup: searchTypeGroup
                checked: true
                style: RadioButtonStyle{ label: Text {
                        color: "white"
                        text: "All Cyclones"
                    }}
                Layout.topMargin: 10
                Layout.leftMargin: 10
       }


       RadioButton {
            id: rbSelected
            exclusiveGroup: searchTypeGroup
            style: RadioButtonStyle{ label: Text {
                    color: "white"
                    text: "Selected Cyclones"
                }}
            Layout.topMargin: 10
            Layout.leftMargin: 10
        }

    RowLayout{
       Button {
            id: buttonSearch
            text: qsTr("Generate Report")
            onClicked: {
                var type,content;
                if(rbAll.checked === true)
                {
                    type = "all"
                }else if(rbSelected.checked === true)
                {
                    type = "selected"
                }
                fileDialog.type = type;
                fileDialog.open();

            }
            Layout.topMargin: 10
            Layout.leftMargin: 10
        }

       Button {
            id: btnCancel
            text: qsTr("Cancel")
            onClicked: {
                window.isReportScreen = false;
                stack.pop()
            }
            Layout.topMargin: 10
            Layout.leftMargin: 10
        }
    }
    }
    Component.onCompleted: fileDialog.close();
}
