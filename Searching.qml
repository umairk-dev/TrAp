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
        spacing : 2
        Label {
            id: labelTitle
            color : "white"
            text: qsTr("Search options")

        }


        ExclusiveGroup { id: searchTypeGroup }



        Label {
            id: labelHintMsg
            color : "white"
        }


       CheckBox {
                id: checkBoxName

                text: "Name"
       }


        CheckBox {
            id: checkBoxYear

            text: qsTr("Year")
        }
        CheckBox {
            id: checkBoxCountry

            text: qsTr("Country")
        }


        ComboBox {
            id: comboBoxCountry

        }

        TextField {
            id: textFieldKeyword

            placeholderText: qsTr("Text Field")
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
        }
    }




}
