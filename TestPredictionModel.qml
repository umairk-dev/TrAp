import QtQuick 2.0

import QtQuick 2.2
import QtQuick.Controls 1.2
import QtQuick.Dialogs 1.1
import QtQuick.Window 2.0
import QtQuick.Layouts 1.1
import QtQuick.Controls.Styles 1.4
import Model 1.0
Rectangle {

    objectName: "predictView"
    property var modelList
    property var models
    color : "transparent"


    ColumnLayout {

        RowLayout{

            ColumnLayout {
                Layout.leftMargin: 10
                Layout.topMargin: 5
                spacing : 20

                Label{
                    text : "** Summary **"
                    font.bold: true
                    font.pointSize: 15
                    color: "white"
                }
            }
        }



        RowLayout{

            ColumnLayout {
                Layout.leftMargin: 10
                Layout.topMargin: 5
                spacing : 20

                Label{
                    text : "Selected Region: "
                    font.bold: true
                    font.pointSize: 15
                    color: "white"
                }

                Label{
                    id : txtSelectedArea
                    text : "From: " + window.selectingArea[0] + " , " + selectingArea[1] + "\nTo: "+ window.selectingArea[2] + "," + selectingArea[3]
                    font.pointSize: 12
                    color: "white"
                }
            }
        }

        RowLayout{

            ColumnLayout {
                Layout.leftMargin: 10
                Layout.topMargin: 5
                spacing : 20

                Button{
                    text : "Export Cyclone Count"


                }
            }
        }

        RowLayout{

            ColumnLayout {
                Layout.leftMargin: 10
                Layout.topMargin: 5
                spacing : 20
                Button{
                    id: btnSelect
                    text:"Hindcast"

                    onClicked: {
                        doBackcast();
                    }
                }
            }

            ColumnLayout {
                Layout.leftMargin: 10
                Layout.topMargin: 5
                spacing : 20
                Button{
                    id: btnCancel
                    text:"Cancel"

                    onClicked: {
                        stack.pop()
                    }
                }
            }
        }


    }


}
