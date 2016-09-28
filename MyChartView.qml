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
    property bool clearflag:false
    property variant categorieslist : [] // year...
    property variant categoriesvalues : []         // number of cyclone
    property variant maxcycloneNo : []
    property variant mincycloneNo : []

    Button {
         id: btnCVclose
         z:10
         width: 20
         height: 20
         anchors.top :cvShow.top
         anchors.right: cvShow.right
         anchors.margins: 10
         text: qsTr("X")
         onClicked: {
             window.isReportScreen = false;

             stack.pop()
         }
     }

    //max
    Button {
         id: btnCVmaxwin
         z:10
         width: 20
         height: 20
         anchors.top :cvShow.top
         anchors.right: btnCVclose.left
         anchors.margins: 10
         text: qsTr("^")
         onClicked: {
             cvShow.width=parent.width
             cvShow.height=parent.height
             btnCVmaxwin.visible=false
             btnCVsmallwin.visible=true
         }
     }

    //original size
    Button {
         id: btnCVsmallwin
         z:10
         width: 20
         height: 20
         visible: false
         anchors.top :cvShow.top
         anchors.right: btnCVclose.left
         anchors.margins: 10
         text: qsTr("v")
         onClicked: {
             cvShow.width=parent.width*0.5
             cvShow.height=parent.height*0.5
             btnCVmaxwin.visible=true
             btnCVsmallwin.visible=false
         }
     }

    ChartView {
        id: cvShow
        title: "The number of cyclone in the year"
        width: parent.width*0.5
        height: parent.height*0.5
        anchors.top :parent.top
        anchors.right: parent.right
        antialiasing: true
        titleFont: Qt.font({pointSize:12})

        BarCategoryAxis{
            id: bca
            categories: categorieslist
        }
        ValueAxis{
             id: valueAxisY
             min: mincycloneNo
             max: maxcycloneNo
         }
        BarSeries {
            id: mySeries
            axisX: bca
            axisY:valueAxisY
            BarSet { label: "Cyclones"; values: categoriesvalues }
        }
        function cvClear()
        {
            if(clearflag===true)
            {
                mySeries.clear()
                categorieslist=[] // year...
                categoriesvalues=[]         // number of cyclone
//                maxcycloneNo=[]
//                mincycloneNo=[]
                console.debug("[debug clear]categoriesvalues:"+categoriesvalues.length+"\tlist:"+categorieslist.length)
                clearflag=false
            }
        }
    }
//    onCategoriesvaluesChanged:cvShow.cvClear()
//    onClearflagChanged: cvShow.cvClear()

//    Component.onCompleted: {
//        console.log("[debug inside cv]"+categorieslist.length);
//    }
//    Component.onDestruction:   {

//        bca.clear()
//        mySeries.clear()
//        categorieslist = [];
//        console.log("[debug inside cv2]"+categorieslist.length);

//    }
}
