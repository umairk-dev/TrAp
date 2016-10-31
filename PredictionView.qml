import QtQuick 2.2
import QtQuick.Controls 1.2
import QtQuick.Dialogs 1.1
import QtQuick.Window 2.0
import QtQuick.Layouts 1.1
import QtQuick.Controls.Styles 1.4
import QtQml 2.2

import QtQuick.Controls 2.0
import QtQuick.Controls 1.4
import Model 1.0
Rectangle {

    objectName: "predictView"
    property var modelList
    property var models
    property var ellaList : ["DJF", "JFM","FMA", "MAM", "AMJ","MJJ","JJA", "JAS","ASO","SON","OND", "NDJ"]
    color : "transparent"

    function loadModels(_models){
        console.log(_models);
        models = _models;
        modelList = [];


        for(var i = 0; i < _models.length; i++){
            var model = _models[i];

            modelList.push(model.modelName);
        }

        cbModel.model = modelList;
        cbModel.currentIndex = 0;
       /// console.log(modelList);
    }

    ColumnLayout {
        RowLayout{

                Rectangle {
                    color: "black"

                    Label{
                        text: "Cyclone Prediction"
                        color: "white"
                        font.pixelSize: 22
                        font.bold: true

                    }
                }
            }

            RowLayout{


                Item {
                    Layout.leftMargin: 10
                    Layout.topMargin: 10

                }
            }
            RowLayout{


                ColumnLayout {
                    Layout.leftMargin: 10
                    Layout.topMargin: 10
                    spacing : 20

                    Label{
                        text: "Select Model:"
                        color: "white"
                        font.pixelSize: 12

                    }
                }
                ColumnLayout {
                    Layout.leftMargin: 10
                    Layout.topMargin: 10
                    spacing : 20

                    ComboBox {
                         id: cbModel
                         model: modelList

                    }
                }

                ColumnLayout {
                    Layout.leftMargin: 10
                    Layout.topMargin: 10
                    spacing : 20

                    Button{
                        id: btnEdit
                        text: "Edit"
                        onClicked:  {
                             var component = Qt.createComponent("ModelEditView.qml")
                             var w    = component.createObject(window,{"model":models[cbModel.currentIndex]});

                             w.show();


                         }
                    }

                }
        }

        RowLayout{
            ColumnLayout {
                Layout.leftMargin: 10
                Layout.topMargin: 10
                spacing : 20
                width:200
                Label{
                    text: "Parameters:"
                    color: "white"
                    font.pixelSize: 15
                    font.bold: true
                }
            }
        }


        RowLayout{
            ColumnLayout {
                Layout.leftMargin: 10
                Layout.topMargin: 10
                spacing : 20
                width:200
                Label{
                    text: "Nino Season:"
                    color: "white"
                    font.pixelSize: 12
                }
            }
            ColumnLayout {
                ComboBox {
                     id: cbElNinoLaNina
                     model: ellaList
                     currentIndex: 5
                }
            }
        }



        RowLayout{
            ColumnLayout {
                Layout.leftMargin: 10
                Layout.topMargin: 10
                spacing : 20
                width:200
                Text {
                    id: txtYear
                    color: "white"
                    font.pixelSize: 12
                    text: qsTr("Training: From:["+ parseInt(rsYear.first.value)+"] to:["+parseInt(rsYear.second.value)+"]")
                }
            }

            ColumnLayout {
                Layout.leftMargin: 10
                Layout.topMargin: 10
                spacing : 20
                width:300
                RangeSlider{
                    id: rsYear
                    Layout.topMargin: 10
                    Layout.leftMargin: 10
                    from: 1970
                    to:Qt.formatDateTime(new Date(), "yyyy")
                    first.value: 1970
                    second.value: parseInt(Qt.formatDateTime(new Date(), "yyyy") ) - 1
                    stepSize: 1.0
                }
            }
        }

        RowLayout{
            ColumnLayout {
                Layout.leftMargin: 10
                Layout.topMargin: 10
                spacing : 20
                width:200
                Label{
                    text: "BurnIn: "
                    color: "white"
                    font.pixelSize: 12
                }
            }
            ColumnLayout {
                TextField{
                    id: txtBurnin
                    width:100
                    text:"5000"
                }
            }
        }


        RowLayout{
            ColumnLayout {
                Layout.leftMargin: 10
                Layout.topMargin: 10
                spacing : 20
                width:200
                Label{
                    text: "Iteration: "
                    color: "white"
                    font.pixelSize: 12
                }
            }
            ColumnLayout {
                TextField{
                    id: txtUpdate
                    width:100
                    text:"5000"
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
                    text:"Select Area"

                    onClicked: {

                        predictAreaSel = true;
                        areaSelectMode = true;
                        window.modelID =  models[cbModel.currentIndex].modelID;
                        if(txtUpdate.text === "" || txtUpdate.text.length === 0)
                            txtUpdate.text = "5000";
                        if(txtBurnin.text === "" || txtBurnin.text.length === 0)
                            txtBurnin.text = "5000";

                        window._update = txtUpdate.text;
                        window._burnin = txtBurnin.text;
                        window._elSeason = cbElNinoLaNina.currentIndex + 1;
                        console.log(window._elSeason)
                        txtInfo.text = "Select Area to start generatig model.."
                        areaSearchCheck(areaSelectMode);
                        window.isPredictScreen = false;
                        stack.pop()
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
                        window.isPredictScreen = false;
                        stack.pop()
                    }
                }
            }
        }


    }


    Component.onCompleted: getModelList();
}
