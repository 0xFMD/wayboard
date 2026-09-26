import QtQuick
import QtQuick.Controls

Rectangle {
    color: "transparent"
    anchors.margins: 10

    Behavior on width {
        SpringAnimation {
            duration: 300
            spring: 4
            damping: 0.37
        }
    }

    Behavior on height {
        SpringAnimation {
            duration: 300
            spring: 4
            damping: 0.37
        }
    }

    GridView {
        anchors.fill: parent

        model: launcher.list_apps()

        delegate: Column {
            required property var modelData

            spacing: 5

            ToolButton {
                id: appButton
                anchors.horizontalCenter: parent.horizontalCenter
                width: 60
                height: 60

                icon.name: modelData.icon
                icon.width: 48
                icon.height: 48

                background: Rectangle {
                    radius: 10
                    color: appButton.hovered ? '#2c89b4fa' : "transparent"
                }
                onClicked: {
                    launcher.launch(modelData.exec);
                    toolBar.selectedItem = "";
                }
            }

            Text {
                width: parent.width

                text: modelData.name
                color: "white"

                horizontalAlignment: Text.AlignHCenter
                elide: Text.ElideRight
            }
        }
    }
}
