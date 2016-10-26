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
                    text: "Initial Values:"
                    color: "white"
                    font.pixelSize: 12
                }
            }
            ColumnLayout {
                TextField{
                    id: initData
                    width:100
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
