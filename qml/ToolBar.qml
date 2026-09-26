import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs

Rectangle {
    id: toolBar

    property string selectedItem: ""

    property int closedWidth: 64
    property int launcherWidth: 500
    property int launcherHeight: 150
    property int penWidth: 64

    signal clearAll
    signal undo
    signal redo

    width: {
        if (selectedItem === "apps")
            return closedWidth + launcherWidth;
        else if (selectedItem === "pen")
            return closedWidth + penWidth;
        else
            return closedWidth;
    }
    height: selectedItem === "apps" ? iconCol.height + launcherHeight : iconCol.height

    radius: 18
    color: "#1e1e2e"
    clip: true

    Behavior on width {
        SpringAnimation {
            spring: 4
            damping: 0.37
        }
    }

    Behavior on height {
        SpringAnimation {
            spring: 4
            damping: 0.37
        }
    }

    Column {
        id: iconCol
        spacing: 8
        padding: 10
        anchors.verticalCenter: parent.verticalCenter

        ToolItem {
            iconSource: "../assets/icons/apps.svg"
            tooltip: "Applications"
            selectedItem: toolBar.selectedItem === "apps"
            onClicked: {
                toolBar.selectedItem = toolBar.selectedItem === "apps" ? "" : "apps";
            }
        }

        ToolItem {
            iconSource: "../assets/icons/select.svg"
            tooltip: "Select"
            selectedItem: root.currentMode === "select"
            onClicked: {
                root.currentMode = "select";
                toolBar.selectedItem = "";
            }
        }

        Row {
            spacing: 6
            anchors.horizontalCenter: parent.horizontalCenter

            ToolItem {
                width: 22
                height: 32

                iconSource: "../assets/icons/eraser.svg"
                tooltip: "Eraser"
                selectedItem: root.currentMode === "eraser"

                onClicked: {
                    root.currentMode = "eraser";
                    toolBar.selectedItem = "";
                }
            }

            ToolItem {
                width: 22
                height: 32
                iconSource: "../assets/icons/pen.svg"
                tooltip: "Pen"
                selectedItem: root.currentMode === "pen"

                onClicked: {
                    root.currentMode = "pen";
                    toolBar.selectedItem = toolBar.selectedItem === "pen" ? "" : "pen";
                }
            }
        }
        Row {
            spacing: 6
            anchors.horizontalCenter: parent.horizontalCenter

            ToolItem {
                width: 22
                height: 32
                tooltip: "Undo"
                iconSource: "../assets/icons/undo.svg"
                onClicked: toolBar.undo()
            }

            ToolItem {
                width: 22
                height: 32
                tooltip: "Redo"
                iconSource: "../assets/icons/redo.svg"
                onClicked: toolBar.redo()
            }
        }

        ToolItem {
            iconSource: "../assets/icons/clear.svg"
            tooltip: "Clear"

            onClicked: {
                toolBar.clearAll();
            }
        }

        Rectangle {
            width: 32
            height: 1
            color: "#313244"
            anchors.horizontalCenter: parent.horizontalCenter
        }

        ToolItem {
            id: zoomInButton
            tooltip: "Zoom In"
            iconSource: "../assets/icons/zoom-in.svg"

            onClicked: {
                board.scale = Math.min(3.0, board.scale + 0.25);
            }
        }

        ToolItem {
            id: zoomResetButton
            tooltip: "Zoom Reset"
            iconSource: "../assets/icons/zoom-reset.svg"

            onClicked: {
                board.scale = 1.0;
                board.x = 0;
                board.y = 0;
            }
        }

        ToolItem {
            id: zoomOutButton

            tooltip: "Zoom Out"

            iconSource: "../assets/icons/zoom-out.svg"

            onClicked: {
                board.scale = Math.max(0.20, board.scale - 0.25);
            }
        }
    }

    // separator
    Rectangle {
        id: launcherSeparator
        width: 1

        anchors.left: iconCol.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom

        color: "#313244"
        opacity: toolBar.selectedItem !== "" ? 1 : 0

        Behavior on opacity {
            NumberAnimation {
                duration: 120
            }
        }
    }

    Launcher {
        id: launcherPanel

        width: toolBar.launcherWidth
        height: iconCol.height + toolBar.launcherHeight

        anchors.left: launcherSeparator.right
        anchors.verticalCenter: parent.verticalCenter

        opacity: toolBar.selectedItem === "apps" ? 1 : 0

        Behavior on opacity {
            NumberAnimation {
                duration: 150
            }
        }
    }

    Column {
        id: penPanel

        width: toolBar.penWidth

        anchors.verticalCenter: parent.verticalCenter
        anchors.left: launcherSeparator.right

        anchors.leftMargin: 15

        spacing: 15

        opacity: toolBar.selectedItem === "pen" ? 1 : 0

        Rectangle {
            width: 28
            height: 28
            radius: 14

            color: root.currentPenColor

            MouseArea {
                anchors.fill: parent
                onClicked: colorDialog.open()
            }
        }

        Slider {
            width: 28
            height: 100

            orientation: Qt.Vertical

            from: 1
            to: 10
            value: root.currentPenSize

            onMoved: {
                root.currentPenSize = value;
            }
        }

        Text {
            text: Math.round(root.currentPenSize)

            color: "white"
            width: 28
            horizontalAlignment: Text.AlignHCenter
        }
    }

    ColorDialog {
        id: colorDialog

        selectedColor: root.currentPenColor

        onAccepted: {
            root.currentPenColor = selectedColor;
        }
    }
}
