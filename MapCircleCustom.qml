import QtQuick 2.0
import QtLocation 5.3
import QtLocation 5.5
import Cyclone 1.0
import QtPositioning 5.3


MapCircle {
        id : circle
        radius: 10000.0
        border.width : 2
        color : "blue"
        property variant track

        MouseArea {

            anchors.fill: parent
            onClicked: {

                //var info = "Cyclone Name : " + c.cycloneName + "\n"
                var info = "TrackID : " + track.trackID + "\n"
                info += "Wind Speed : " + track.windSpeed + "\n"
                info += "Latitude : " + track.latitude + "\n"
                info += "Longitude : " + track.longitude + "\n"
                info += "Nature : " + track.nature + "\n"
                console.log("Wind Speed: " + track.windSpeed)
                console.log("Latitude: " + track.latitude)
                console.log("Longitude: " + track.longitude)
                console.log("Nature: " + track.nature)
                //showInfo(info);
                var msg = Qt.createQmlObject('import QtQuick.Dialogs 1.2; MessageDialog {}',circle)
                msg.title = "Cyclone Info"
                msg.text = info
                //msg.OnAccepted = {msg:close()}
                msg.visible = true

                //console.log("clicked!" + track.trackID);



            }
        }


}

