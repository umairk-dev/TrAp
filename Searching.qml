import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.2
import QtQuick.Window 2.0
import QtQuick.Layouts 1.1
import QtQuick.Controls.Styles 1.4

Rectangle {    
    color : "transparent"
    ColumnLayout {
        id: columnLayout1
        spacing : 20
        Label {
            id: labelTitle
            color : if(window._platform === "1"){"black"}
                    else
                    {"white"}
            text: qsTr("Search options")
            Layout.topMargin: 10
            Layout.leftMargin: 10
        }

        Label {
            id: labelHintMsg
            color : "white"
            Layout.topMargin: 10
            Layout.leftMargin: 10
        }

       ExclusiveGroup { id: searchTypeGroup }
       RadioButton {
                id: radioButtonName
                exclusiveGroup: searchTypeGroup
                checked: true
                style: RadioButtonStyle{ label: Text {
                        color: if(window._platform === "1"){"black"}
                               else
                               {"white"}
                        text: "Name"
                    }}
                Layout.topMargin: 10
                Layout.leftMargin: 10
       }


        RadioButton {
            id: radioButtonYear
            exclusiveGroup: searchTypeGroup
            style: RadioButtonStyle{ label: Text {
                    color: if(window._platform === "1"){"black"}
                           else
                           {"white"}
                    text: "Year"
                }}
            Layout.topMargin: 10
            Layout.leftMargin: 10
        }

        RadioButton {
            id: radioButtonCountry
            exclusiveGroup: searchTypeGroup
            style: RadioButtonStyle{ label: Text {
                    color: if(window._platform === "1"){"black"}
                           else
                           {"white"}
                    text: "Country"
            }}
            Layout.topMargin: 10
            Layout.leftMargin: 10
        }


        ComboBox {
            id: comboBoxCountry

            model: ListModel {
                id: countryItems
                ListElement { text: "Fiji"}
                ListElement { text: "Solomon" }
                ListElement { text: "Tonga"}
            }
            Layout.topMargin: 10
            Layout.leftMargin: 10
        }

        TextField {
            id: textFieldKeyword
            placeholderText: qsTr("Text Field")
            Layout.topMargin: 10
            Layout.leftMargin: 10
        }

        Button {
            id: buttonSearch
            text: qsTr("Search")
            onClicked: {
                //var prev = stack.get(f2.Stack.index - 1)
                //prev.

                doSearch(textFieldKeyword.text)
                stack.pop()
            }
            Layout.topMargin: 10
            Layout.leftMargin: 10
        }
    }
}
