import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1
import QtQuick.Controls.Styles 1.4
import Model 1.0
import Variable 1.0
ApplicationWindow {
    property Model model
    property variant dataL : []
    id:child
    modality : "ApplicationModal"
    title: "Modify Model"
    width: 500; height: 600

    ColumnLayout {
        RowLayout{

            ColumnLayout {
                Layout.leftMargin: 10
                Layout.topMargin: 10
                spacing : 20
                Label{
                    text:"Model:"
                }
            }
        }

        RowLayout{
            ColumnLayout {
                Layout.leftMargin: 10
                Layout.topMargin: 10
                spacing : 20
                TextArea{
                    id: txtModel
                }
            }
        }


        RowLayout{

            ColumnLayout {
                Layout.leftMargin: 10
                Layout.topMargin: 5
                spacing : 20
                Label{
                    text:"Data:"
                }
            }

        }



        RowLayout{
            ColumnLayout {
                Layout.leftMargin: 10
                Layout.topMargin: 5
                spacing : 20

                ListView {
                    ListModel {
                        id: dataModel

                        ListElement{
                            name: "Data"
                            cdata : [

                                    ]
                        }

                    }
                    Component {
                        id: dataDelegate

                            Column {

                                Repeater {
                                model: cdata
                                Row {
                                    spacing: 10


                                        TextField{
                                            id : txtName
                                            Layout.topMargin: 10
                                            Layout.leftMargin: 10
                                            Layout.rightMargin: 10
                                            text : name
                                            onTextChanged: {name = txtName.text}
                                        }


                                        TextField{
                                            id : txtValue
                                            Layout.topMargin: 10
                                            Layout.leftMargin: 10
                                            Layout.rightMargin: 10
                                            text : value
                                            onTextChanged: {value = txtValue.text}
                                        }


                                        Button{
                                            Layout.topMargin: 10
                                            Layout.leftMargin: 10
                                            Layout.rightMargin: 10
                                            onClicked: {

                                            }
                                        }

                                    }
                                }
                            }

                    }

                    width: 300
                    height: 100
                    model: dataModel
                    delegate: dataDelegate
                }

                function loadData(){
                    txtModel.text = child.model.modelData;
                    child.dataL = child.model.variables;

                    for(var i = 0; i < child.dataL.length; i++){

                        var d = child.dataL[i];

                        if(d.dataType === 1 || d.dataType === "1")
                            dataModel.get(0).cdata.append({name : d.dataName, value: d.dataValue, index:i, id : d.dataID});
                    }
                    dataModel.get(0).cdata.append({name : "", value: "", index:child.dataL.length});

                }


                Component.onCompleted: loadData();
            }
        }

        RowLayout{

            ColumnLayout {
                Layout.leftMargin: 10
                Layout.topMargin: 5
                spacing : 20
                Label{
                    text:"Init Values:"
                }
            }

        }
        RowLayout{
            ColumnLayout {
                Layout.leftMargin: 10
                Layout.topMargin: 5
                spacing : 20

                ListView {
                    ListModel {
                        id: initModel

                        ListElement{
                            name: "Init"
                            idata : [

                                    ]
                        }

                    }
                    Component {
                        id: initDelegate

                            Column {

                                Repeater {
                                model: idata
                                Row {
                                    spacing: 10


                                        TextField{
                                            id : txtName
                                            Layout.topMargin: 10
                                            Layout.leftMargin: 10
                                            Layout.rightMargin: 10
                                            text : name

                                            onTextChanged: {name = txtName.text}
                                        }


                                        TextField{
                                            id : txtValue
                                            Layout.topMargin: 10
                                            Layout.leftMargin: 10
                                            Layout.rightMargin: 10
                                            text : value
                                            onTextChanged: {value = txtValue.text}
                                        }

                                    }
                                }
                            }

                    }

                    width: 300
                    height: 100
                    model: initModel
                    delegate: initDelegate
                }

                function loadInitData(){
                    console.log("init");
                    child.dataL = child.model.variables;

                    for(var i = 0; i < child.dataL.length; i++){
                        var d = child.dataL[i];
                       // console.log(d.dataType);
                        if(d.dataType === 2 || d.dataType === "2"){
                            initModel.get(0).idata.append({name : d.dataName, value: d.dataValue, index:i, id : d.dataID});
                            //count++;
                        }
                    }
                    initModel.get(0).idata.append({name : "", value: "", index:-1});

                }


                Component.onCompleted: loadInitData();
            }
        }


        RowLayout{
            ColumnLayout {
                Layout.leftMargin: 10
                Layout.topMargin: 5
                spacing : 20
                Button{
                    id: btnSave
                    text:"Save"
                    onClicked: {
                        var initSize = initModel.get(0).idata.count;
                        if(initModel.get(0).idata.get(initModel.get(0).idata.count-1).name === "")
                            initSize = initModel.get(0).idata.count -1;

                        var varSize = dataModel.get(0).cdata.count;
                        if(dataModel.get(0).cdata.get(dataModel.get(0).cdata.count-1).name === "")
                            varSize = dataModel.get(0).cdata.count -1;

                        var initD = new Array(initSize);
                        var varD = new Array(varSize);
                        var c = 0;
                        console.log(initModel.get(0).idata.get(0));
                        for(var i = 0; i < initSize; i++){
                            if(initModel.get(0).idata.get(i).name !== ""){
                                var d = new Array(2);
                                d[0] = initModel.get(0).idata.get(i).name;
                                d[1] = initModel.get(0).idata.get(i).value;
                                d[2] = initModel.get(0).idata.get(i).id;
                                initD[c] = d;
                                c++;
                            }
                        }

                        c = 0;

                        for(var j = 0; j < varSize; j++){

                                var v = new Array(2);
                                v[0] = dataModel.get(0).cdata.get(j).name;
                                v[1] = dataModel.get(0).cdata.get(j).value;
                                v[2] = dataModel.get(0).cdata.get(j).id;
                                varD[c] = v;
                                c++;
                        }


                        console.log(varD);
                        console.log(initD);

                        updateModel(txtModel.text, varD, model.modelID);

                        child.close();
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
                    onClicked: child.close();
                }
            }
        }

    }

}
