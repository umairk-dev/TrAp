import QtQuick 2.5
import QtQuick.Dialogs 1.2
import QtQuick.Window 2.0
import QtQuick.Layouts 1.1
import QtQuick.Controls.Styles 1.4
import QtQuick.Controls 2.0
import QtQuick.Controls 1.4

Rectangle {
    property var serchingitem: ['year','wind','pressure','area','country']
    property var countrylist: ["Fiji","Solomon","Tonga"]
    id: rview
    color : if(window._platform === "1"){"#ffff99"}
            else{"transparent"}
    ColumnLayout {
        id: columnLayout1
        spacing : 20        
        RowLayout{
            Button {
                    id: buttonSearch
                    text: qsTr("Search")
                    onClicked: {
                        /*18082016 [S] Search signal*/
                        var type,content;
                        doClearCondition()//12092016 [S] Search signal
                        if(cbYear.checked){
                            type=serchingitem[0]
                            if(rsYear.first.value===rsYear.second.value)
                                content= String(parseInt(rsYear.first.value))
                            else
                                content= String(parseInt(rsYear.first.value)+","+parseInt(rsYear.second.value))

                            addSearchCondtion(type,content)//12092016 [S] Search signal
                        }
                        if(cbWind.checked){
                            type=serchingitem[1]
//                            if(rsWind.first.value === rsWind.second.value)
//                                content= String(parseInt(rsWind.first.value))
//                            else
                                content= String(parseInt(rsWind.first.value)+","+parseInt(rsWind.second.value))
                            addSearchCondtion(type,content)//12092016 [S] Search signal
                        }
                        // 19092016 [S] searching by pressure
                        if(cbPressure.checked){
                            type=serchingitem[2]
                            content= String(parseInt(rsPressure.first.value)+","+parseInt(rsPressure.second.value))
                            addSearchCondtion(type,content)//12092016 [S] Search signal
                        }
                        // 19092016 [E] searching by pressure
                        // 18092016 [S] predefine country search
                        if(cbCountry.checked){
                            type=serchingitem[4]
                            content=String(comboBoxCountry.currentIndex)
                            addSearchCondtion(type,content)
                        }                        
                        // 18092016 [E] predefine country search
                        // 19092016 [S] area selection
                        if(cbArea.checked){
                            areaSearchCheck(cbArea.checked)
                        }
                        // 19092016 [E] area selection
                        /*18082016 [E] Search signal*/
                        doSearch()//12092016 [S] Search signal

                        stack.pop()
                    }
                    Layout.topMargin: 10
                    Layout.leftMargin: 10
                }
                /*29082016 [S] Search signal*/
                Button {
                    id: buttonCancel
                    text: qsTr("Cancel")
                    onClicked: {
                        window.isSearchScreen = false;
                                        stack.pop()
                    }
                    Layout.topMargin: 10
                    Layout.leftMargin: 10
                }
                /*29082016 [E] Search signal*/
                Label {
                    id: labelHintMsg
                    color : "white"
                    Layout.topMargin: 10
                    Layout.leftMargin: 10
                }
        }
        Label {
            id: labelTitle
            color : if(window._platform === "1")
                    {"black"}
                    else
                    {"white"}
            text: qsTr("Search options")
            Layout.topMargin: 10
            Layout.leftMargin: 10
        }
        //SelectArea
        RowLayout{
            visible: if(window._platform === "1"){false}
                     else{true}

            CheckBox{
                id:cbArea
                Layout.topMargin: 10
                Layout.leftMargin: 10

                style:
                    CheckBoxStyle{
                       label: Text {
                            id: txtAreaCB
                            color: "white"
                            text: "Area"
                        }
                    }
            onCheckedChanged:
            {
                if(cbArea.checked)
                    cbCountry.checked=false

                controlMapMouse(cbArea.checked)
            }

            }
        }

        //RsYear
        RowLayout{
            CheckBox{
                id:cbYear
                Layout.topMargin: 10
                Layout.leftMargin: 10

                style: CheckBoxStyle{
                     label: Text {
                         id: txtYearCB
                            color: if(window._platform === "1"){"black"}
                                   else
                                   {"white"}
                            text: serchingitem[0]
                        }
                    }
            }
            Text {
                id: txtYear
                Layout.topMargin: 10
                Layout.leftMargin: 25
                text: qsTr("From:["+ parseInt(rsYear.first.value)+"] to:["+parseInt(rsYear.second.value)+"]")
                color: if(window._platform === "1"){"black"}
                       else                        {"white"}
                visible: if(cbYear.checked){true}
                         else{false}
            }
        }
        RangeSlider{
            id: rsYear
            Layout.topMargin: 10
            Layout.leftMargin: 10
            from: 1900
            to:2016
            first.value: 1910
            second.value: 2000
            stepSize: 1.0
        }

        //RsWind
        RowLayout{
            CheckBox{
                id:cbWind
                Layout.topMargin: 10
                Layout.leftMargin: 10
                style: CheckBoxStyle{
                     label: Text {
                         id: txtWindCB
                            color: if(window._platform === "1"){"black"}
                                   else
                                   {"white"}
                            text: "Wind"
                        }
                    }
            }
            Text {
                id: txtWind
                Layout.topMargin: 10
                Layout.leftMargin: 25
                text: qsTr("From:["+ parseInt(rsWind.first.value)+"] to:["+parseInt(rsWind.second.value)+"] knots")
                color: if(window._platform === "1"){"black"}
                       else                        {"white"}
                visible: if(cbWind.checked){true}
                         else{false}
            }
        }
        RangeSlider{
            id: rsWind
            Layout.topMargin: 10
            Layout.leftMargin: 10
            from: 10
            to:160//MAX 145
            first.value: 30
            second.value: 140
            stepSize: 1.0
        }

        //RsPressure
        RowLayout{
            CheckBox{
                id:cbPressure
                Layout.topMargin: 10
                Layout.leftMargin: 10
                style: CheckBoxStyle{
                     label: Text {
                         id: txtPressureCB
                            color: if(window._platform === "1"){"black"}
                                   else
                                   {"white"}
                            text: "Pressure"
                        }
                    }
            }
            Text {
                id: txtPressure
                Layout.topMargin: 10
                Layout.leftMargin: 25
                text: qsTr("From:["+ parseInt(rsPressure.first.value)+"] to:["+parseInt(rsPressure.second.value)+"] millibars")
                color: if(window._platform === "1"){"black"}
                       else                        {"white"}
                visible: if(cbPressure.checked){true}
                         else{false}
            }
        }
        RangeSlider{
            id: rsPressure
            Layout.topMargin: 10
            Layout.leftMargin: 10
            from: 900
            to:1020//MAX 1014
            first.value: 920
            second.value: 1000
            stepSize: 1.0
        }
        // 18092016 [S] predefine country search
        RowLayout{
            CheckBox{
                id:cbCountry
                Layout.topMargin: 10
                Layout.leftMargin: 10

                style: CheckBoxStyle{
                     label: Text {
                         id: txtCountryCB
                            color: if(window._platform === "1"){"black"}
                                   else
                                   {"white"}
                            text: "Country"
                        }
                    }
                onCheckedChanged:  {
                if(cbCountry.checked)
                    cbArea.checked=false
                }
            }
            Item {
                id: icomboBoxCountry
                visible: cbCountry.checked
//                Layout.topMargin: 10
                Layout.leftMargin: 10
                    ComboBox {
                            id: comboBoxCountry
                            model: countrylist
                    }
            }
        }
        // 18092016 [E] predefine country search
    }
}
