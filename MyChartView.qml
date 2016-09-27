import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.1
import QtCharts 2.1

Rectangle {
    id: myChartView
    color : "transparent"
    width: parent.width*0.25
    height: parent.height*0.25
    anchors.top :parent.top
    anchors.right: parent.right
    property variant categorieslist : [] // year...
    property variant categoriesvalues : []         // number of cyclone
    property variant maxcycloneNo : []
    property variant mincycloneNo : []
    Button {
         id: btnCVclose
         z:10
         width: 25
         height: 25
         anchors.top :parent.top
         anchors.right: parent.right
         anchors.margins: 10
         text: qsTr("X")
         onClicked: {
             window.isReportScreen = false;
             stack.pop()
         }
     }

    ChartView {
        id: cvShow
        title: "The number of cyclone in the year"
        width: parent.width*0.25
        height: parent.height*0.25
        anchors.top :parent.top
        anchors.right: parent.right
//        anchors.margins: 10
//        property variant categorieslist : [] // year...
//        property variant values : []         // number of cyclone
//        property variant maxcycloneNo : 50
//        property variant mincycloneNo : 0
//        legend.alignment: Qt.AlignBottom
        antialiasing: true

        BarCategoryAxis{
            id: bca
//            categories: cvShow.categorieslist
            categories: categorieslist
        }
        ValueAxis{
             id: valueAxisY
//             min: cvShow.mincycloneNo
//             max: cvShow.maxcycloneNo
             min: mincycloneNo
             max: maxcycloneNo
         }
        BarSeries {
            id: mySeries
            axisX: bca
            axisY:valueAxisY
            BarSet { label: "Cyclones"; values: categoriesvalues }
        }
//        PropertyChanges {
//            target: categoriesvalues
//            onTargetChanged: addAbar()
//        }
//        function addAbar(){
//            mySeries.append("cyclones",categoriesvalues)
//        }
    }


    //function
    //close button
//    ColumnLayout {
//        id: columnLayout1
//        spacing : 20
//        RowLayout{
//            Button {
//                    id: close

//            }
//        }
//    }

}
