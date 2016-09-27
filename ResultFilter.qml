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
                                    checked: {console.log(name + " " + cstate + " C-D"); if(cstate === true){ return true;} else{return false;}}
                                    onClicked:{
                                            var tracks = window.mapView.cyclones[index];
                                            console.log("length = " + tracks.length)
                                            console.log(tracks)

                                            tracks[0].visible = cbEnable.checked
                                            tracks[3] = cbEnable.checked
                                            cstate = cbEnable.checked
                                            for(var i = 1; i < tracks.length-1; i++){
                                                var mapItems = tracks[i]

                                                for(var j = 0; j < mapItems.length; j++)
                                                    mapItems[j].visible = cbEnable.checked;
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
            var track = window.mapView.cyclones[i];
            cycloneModel.get(0).cdata.append({name : cyclones[i].cycloneName, serial : "S#:"+cyclones[i].num, year : "Y:"+cyclones[i].seasonYear, cstate : track[3] , index : i })
       }
    }


    Component.onCompleted: loadData();

}
