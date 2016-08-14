import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.2
import QtQuick.Window 2.0
import QtQuick.Layouts 1.1

Item {

    Label {
        id: labelTitle
        x: 22
        y: 21
        text: qsTr("Search options")
    }


    ExclusiveGroup { id: searchTypeGroup }

    Button {
        id: buttonSearch
        x: 22
        y: 240
        text: qsTr("Search")
    }

    Label {
        id: labelHintMsg
        x: 22
        y: 40
    }

    ComboBox {
        id: comboBoxCountry
        x: 22
        y: 161
    }

    TextField {
        id: textFieldKeyword
        x: 22
        y: 103
        placeholderText: qsTr("Text Field")
    }

    CheckBox {
        id: checkBoxName
        x: 22
        y: 80
        text: "Name"
    }

    CheckBox {
        id: checkBoxYear
        x: 101
        y: 80
        text: qsTr("Year")
    }

    CheckBox {
        id: checkBoxCountry
        x: 22
        y: 138
        text: qsTr("Country")
    }

}
