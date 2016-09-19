import QtQuick 2.0
import QtLocation 5.3
import Cyclone 1.0


MapPolyline {
        id : polyLine
        line.color : "blue"
        property variant cyclone
        property variant color
        property variant track
        property variant otherLines
        property variant platform
        property variant txtInfo
        property bool doubleClick : false


        MouseArea {

            anchors.fill: parent
            hoverEnabled: true
            onEntered: {

                if(platform === "2"){
                    if(doubleClick === false){
                        line.color = "red"
                    }

                    var info = "Cyclone Name : " + cyclone.cycloneName + "\n"
                    info += "TrackID : " + track.trackID + "\n"
                    info += "Wind Speed : " + track.windSpeed + "\n"
                    info += "Pressure : " + track.pressure + "\n"
                    info += "Latitude : " + track.latitude + "\n"
                    info += "Longitude : " + track.longitude + "\n"
                    info += "Basin : " + track.basin + "\n"
                    info += "Sub Basin : " + track.subBasin + "\n"
                    //var msg = Qt.createQmlObject('import QtQuick.Dialogs 1.2; MessageDialog {}',polyLine)
                    //msg.title = "Cyclone Info"
                    //msg.text = info
                    txtInfo.text = info
                    txtInfo.z  = 70


                }
                /*for(var i = 0; i < otherLines.length; i++){
                    otherLines[i].line.color = "yellow"
                    otherLines[i].line.width = 5
                }*/
            }

            onExited: {

                if(platform === "2"){
                    if(doubleClick === false){
                        line.color = color

                    }
                    txtInfo.text = ""
                    txtInfo.z  = 0
                }
                /*for(var i = 0; i < otherLines.length; i++){
                    otherLines[i].line.color = otherLines[i].color
                    otherLines[i].line.width = 3
                }*/

            }

            onDoubleClicked: {

                if(platform === "2"){

                    if(doubleClick == false){
                        for(var i = 0; i < otherLines.length; i++){
                            otherLines[i].line.color = "yellow"
                            otherLines[i].line.width = 5
                            otherLines[i].doubleClick = true
                        }
                        doubleClick = true
                        selectCyclone(cyclone);
                    }else{
                        for(var i = 0; i < otherLines.length; i++){
                            otherLines[i].line.color = otherLines[i].color
                            otherLines[i].line.width = 3
                            otherLines[i].doubleClick = false

                        }
                        doubleClick = false
                        removeCyclone(cyclone);
                    }
                }



            }

            onClicked: {

                //var info = "Cyclone Name : " + c.cycloneName + "\n"
                if(platform === "2"){
                    /*for(var i = 0; i < otherLines.length; i++){
                        otherLines[i].line.color = otherLines[i].color
                        otherLines[i].line.width = 3
                        otherLines[i].doubleClick = false

                    }*/
                    //doubleClick = false
                }else{


                }
            }
        }


}

