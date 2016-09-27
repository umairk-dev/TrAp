import QtQuick 2.0
import Cyclone 1.0
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.1
import QtQuick.Controls.Styles 1.4

Rectangle {
    property variant cyclones
    property variant items
    id: rview
    color : if(window._platform === "1"){"#ffff99"}
                else{"transparent"}
    y : parent.height / 2
    x : 0
    ScrollView {
        ListView {
            ListModel {
                id: cycloneModel

                ListElement{
                    name: "Filter Cyclones"
                    cdata : [

                            ]
                }

            }
            Component {
                id: cycloneDelegate

                    Column {
                        Text { text: name
                            color: "white"
                            font.bold: true
                        }
                        Repeater {
                        model: cdata
                        Row {
                            spacing: 10
                                CheckBox {
                                    id: cbEnable
                                    Layout.topMargin: 10
                                    Layout.leftMargin: 10
                                    Layout.rightMargin: 10
                                    style : CheckBoxStyle{
                                        label: Text {
                                            color: "white"
                                            text: name
                                        }
                                    }
                                    checked: visible
                                    onClicked:{
                                            var tracks = items[index];
                                            tracks[0].visible = cbEnable.checked
                                            var lines = tracks[1];
                                            console.log(lines.length)
                                            for(var i = 0; i < lines.length; i++){
                                                 lines[i].visible = cbEnable.checked;
                                            }
                                            var points = tracks[2];
                                            for(var j = 0; j < points.length; j++){
                                                 points[j].visible = cbEnable.checked;
                                            }
                                    }


                                }

                                Label{
                                    Layout.topMargin: 10
                                    Layout.leftMargin: 10
                                    Layout.rightMargin: 10
                                    text : serial
                                    color: "white"
                                }

                                Label{
                                    Layout.topMargin: 10
                                    Layout.leftMargin: 10
                                    Layout.rightMargin: 10
                                    text : year
                                    color: "white"
                                }

                            }
                        }
                    }

            }

            width: 300
            height: 100
            model: cycloneModel
            delegate: cycloneDelegate
        }
    }

    function loadData(){


        for(var i = 0; i < cyclones.length; i++){
            var track = items[i];
            cycloneModel.get(0).cdata.append({name : cyclones[i].cycloneName, serial : cyclones[i].num, year : cyclones[i].seasonYear, visible : track[0].visible , index : i })
       }
    }


    Component.onCompleted: loadData();

}
