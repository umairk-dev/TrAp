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
            color : if(window._platform === "1"){"black"
                    rview.color="#ffff99"
                    }
                    else
                    {"white"}
            text: qsTr("Search options")
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
                /*18082016 [S] Search signal*/
                var type,content;
                if(radioButtonName.checked == true)
                {
                    type = "name"
                    content = textFieldKeyword.text
                }else if(radioButtonYear.checked == true)
                {
                    type = "year"
                    content = textFieldKeyword.text
                }else if(radioButtonCountry.checked == true)
                {
                    type = "country"
                    content= comboBoxCountry.currentText
                }
                /*18082016 [E] Search signal*/
                doSearch(type,content)

                stack.pop()
            }
            Layout.topMargin: 10
            Layout.leftMargin: 10
        }
        /*29082016 [S] Search signal*/
        Button {
            id: buttonCancel
            text: qsTr("Cancel")
            onClicked: {
                window.isSearchScreen = false;
                                stack.pop()
            }
            Layout.topMargin: 10
            Layout.leftMargin: 10
        }
        /*29082016 [E] Search signal*/
        Label {
            id: labelHintMsg
            color : "white"
            Layout.topMargin: 10
            Layout.leftMargin: 10
        }
    }
}
