import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.2
import QtQuick.Window 2.0
import QtQuick.Layouts 1.1
import QtQuick.Controls.Styles 1.4

Rectangle {
    id: rview
    color : "transparent"
    ColumnLayout {
        id: columnLayout1
        spacing : 20
        Label {
            id: labelTitle
            color : "white"
            text: qsTr("Generate Report:")
            Layout.topMargin: 10
            Layout.leftMargin: 10
        }

       ExclusiveGroup { id: searchTypeGroup }
       RadioButton {
                id: radioButtonName
                exclusiveGroup: searchTypeGroup
                checked: true
                style: RadioButtonStyle{ label: Text {
                        color: "white"
                        text: "Export CSV"
                    }}
                Layout.topMargin: 10
                Layout.leftMargin: 10
       }


       RadioButton {
            id: radioButtonYear
            exclusiveGroup: searchTypeGroup
            style: RadioButtonStyle{ label: Text {
                    color: "white"
                    text: "Generate PDF Report"
                }}
            Layout.topMargin: 10
            Layout.leftMargin: 10
        }

       Rectangle{
           Label {
               id: charts
               color : "white"
               text: qsTr("Add Charts:")
               Layout.topMargin: 10
               Layout.leftMargin: 10
           }

           CheckBox{
               id : cbWind
               style: CheckBoxStyle{ label: Text {
                       color: "white"
                       text: "Wind"
                   }}
           }


           CheckBox{
               id : cbPressure
               style: CheckBoxStyle{ label: Text {
                       color: "white"
                       text: "Pressure"
                   }}
           }


           CheckBox{
               id : cbWind
               style: CheckBoxStyle{ label: Text {
                       color: "white"
                       text: "Wind"
                   }}
           }

       }

       Button {
            id: buttonSearch
            text: qsTr("Generate Report")
            onClicked: {
                var type,content;
                if(radioButtonName.checked == true)
                {
                    type = "csv"
                }else if(radioButtonYear.checked == true)
                {
                    type = "report"
                }

                genReport(type)

                stack.pop()
            }
            Layout.topMargin: 10
            Layout.leftMargin: 10
        }

       Button {
            id: btnCancel
            text: qsTr("Cancel")
            onClicked: {
                window.isSearchScreen = false;
                                stack.pop()
            }
            Layout.topMargin: 10
            Layout.leftMargin: 10
        }
    }
}
