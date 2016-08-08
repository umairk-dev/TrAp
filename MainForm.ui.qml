import QtQuick 2.4
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.1
import QtQml 2.2


Rectangle {
anchors.fill: parent

    ToolBar {
        id: toolBar1
        x: 0
        y: 0

        ToolButton {
            id: toolButton1
            text: "Hello"
        }

        ToolButton {
            id: toolButton2
            x: 42
            y: 0
            text: "World"
        }
    }
}
