import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1
import QtQuick.Controls.Styles 1.4
import Model 1.0
import Variable 1.0
import QtQuick.Dialogs 1.1
ApplicationWindow {
    property variant count : []
    id:child
    modality : "ApplicationModal"
    title: "Years Count"
    width: 500; height: 600



    ColumnLayout {

        RowLayout{

            Rectangle {
                width: child.width
                height: child.height * .9

                Component {
                    id: listDelegate
                    Item {
                    width: 250; height: 50

                        Row {
                         Column {
                             width: 200
                             Text { text: year }
                            }


                         Column {
                             width: 200
                             Text { text: c }
                            }
                        }
                    }
                }

                ListModel {
                         id: listModel

                 }

                ListView {
                      id: listView
                      anchors.fill: parent; anchors.margins: 5
                      model: listModel
                      delegate: listDelegate
                      focus: true
                }
            }

        }

        RowLayout{
           id : topL
           Button {
                id: btnExport
                text: qsTr("Export")
                onClicked: {
                    saveYearsCount("");
                }
                Layout.topMargin: 10
                Layout.leftMargin: 10
            }

           Button {
                id: btnCancel
                text: qsTr("Cancel")
                onClicked: {
                    child.close();
                }
                Layout.topMargin: 10
                Layout.leftMargin: 10
            }
        }


    }
    Component.onCompleted: {

        var currentyear = parseInt(Qt.formatDateTime(new Date(), "yyyy") ) - 1
        var _c = 0;
        for(var i=1970;i<=currentyear;i++){
            listModel.append({year : i, c : count[_c] })
            _c++;
        }

    }
}
