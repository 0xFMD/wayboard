import QtQuick
import QtQuick.Controls

Item {
    id: toolItem

    width: 48
    height: 48

    property string iconSource: ""
    property string tooltip: ""
    property bool selectedItem: false
    property color secondaryColor: "#89b4fa"

    signal clicked

    Rectangle {

        anchors.fill: parent
        radius: 12

        color: {
            if (toolItem.selectedItem)
                return toolItem.secondaryColor;

            if (mouseArea.containsMouse)
                return "#2c89b4fa";

            return "transparent";
        }

        Behavior on color {
            ColorAnimation {
                duration: 120
            }
        }
    }

    ToolButton {
        anchors.centerIn: parent

        icon.source: toolItem.iconSource
        icon.width: 24
        icon.height: 24
        icon.color: toolItem.selectedItem ? "#11111b" : "#cdd6f4"
        enabled: false

        Behavior on icon.color {
            ColorAnimation {
                duration: 120
            }
        }
    }

    MouseArea {
        id: mouseArea

        anchors.fill: parent
        hoverEnabled: true

        onClicked: {
            toolItem.clicked();
        }
    }

    ToolTip {
        visible: mouseArea.containsMouse
        text: toolItem.tooltip
        delay: 1200
    }
}
