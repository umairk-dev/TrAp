import QtQuick 2.0

import QtQuick 2.2
import QtQuick.Controls 1.2
import QtQuick.Dialogs 1.1
import QtQuick.Window 2.0
import QtQuick.Layouts 1.1
import QtQuick.Controls.Styles 1.4
Rectangle {

    objectName: "predictView"
    property var ellaList : ["DJF", "JFM","FMA", "MAM", "AMJ","MJJ","JJA", "JAS","ASO","SON","OND", "NDJ"]
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
                    text : "Selected Season: " + ellaList[_elSeason-1]
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
                    text : "From: " + window.selectingArea[0].toFixed(3) + " , " + selectingArea[1].toFixed(3) + "\nTo: "+ window.selectingArea[2].toFixed(3) + "," + selectingArea[3].toFixed(3)
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

                Label{
                    text : "Verification: "
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

                Button{
                    text : "Cyclone Count"
                    onClicked: {

                        getYearsCount();



                    }
                }
            }


            ColumnLayout {
                Layout.topMargin: 5
                spacing : 20
                Button{
                    id: btnSelect
                    text:"Hindcast"

                    onClicked: {
                        Prediction.doBackcast();
                    }
                }
            }
        }

        RowLayout{

            ColumnLayout {
                Layout.leftMargin: 10
                Layout.topMargin: 5
                spacing : 20

                Label{
                    text : "Prediction: "
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

                Button{
                    text : "Forecast"
                    onClicked: {
                        Prediction.doForecast();
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

    Component.onCompleted: {txtInfo.text = ""}
}
