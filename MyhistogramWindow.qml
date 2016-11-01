import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1
import QtQuick.Controls.Styles 1.4
import Model 1.0
import Variable 1.0
import QtCharts 2.1
ApplicationWindow {
    id:mhw
    modality : "ApplicationModal"
    title: "Prediction"
    width: 800; height: 600

    property variant predictionData :[]
    property variant showData :[]
    property variant yearrange:[]
    property variant categorieslist:[0,1,2,3,4,5,6,7,8,9]
//    property variant temp

    ColumnLayout {
        RowLayout{

            ColumnLayout {
                Layout.leftMargin: 10
                Layout.topMargin: 10
                spacing : 20
                ComboBox{

                    id: cbhgwin
                    onCurrentIndexChanged: selectdata()

                }

            }
            ColumnLayout {
//                Layout.leftMargin: 10
                Layout.topMargin: 10

                spacing : 20
                    Button{

                    id: btnhgwin

                    onClicked: selectdata()
                    text: "Select"
                   }
           }
        }

        RowLayout{

            ColumnLayout {
                Layout.leftMargin: 10
                Layout.topMargin: 10
                spacing : 20
            ChartView {
                id: cvShow
                title: {if(predictionData.length > 1){ "Hindcast of cyclones - " + cbhgwin.currentText}//yearrange[cbhgwin.currentIndex]}
                    else {"Forecast of cyclones in selected region - Year " + Qt.formatDateTime(new Date(), "yyyy")} }
                width: 780
                height: 550
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
                     min: 0
                     max: 1
                 }
                BarSeries {
                    id: mySeries
                    axisX: bca
                    axisY:valueAxisY
                    BarSet { label: "Cyclones"; values: showData }
                }

            }
        }
        }
    }    
    function selectdata()
    {
        showData=[]
//        var select = (parseInt(cbhgwin.textAt()) - 1970)
        showData=predictionData[cbhgwin.currentIndex]
//        console.debug(showData)
    }
    function loadData()
    {

       if(predictionData.length > 1){
           yearrange=[]
           var currentyear = parseInt(Qt.formatDateTime(new Date(), "yyyy") ) - 1
           for(var i=1970;i<=currentyear;i++)
                yearrange.push(i)
           cbhgwin.model=yearrange
       }else{
            cbhgwin.visible = false;
            btnhgwin.visible = false;
       }
//       selectdata()
    }
    Component.onCompleted: loadData();

    Component.onDestruction: { predictionData = [] }

}

