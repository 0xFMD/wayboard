import QtQuick
import QtQuick.Window

Window {
    id: root

    width: 1920
    height: 1080
    visible: true

    color: "#151520"

    property string currentMode: "select"
    property string currentPenColor: "white"
    property int currentPenSize: 4

    MouseArea {
        anchors.fill: parent
        drag.target: root.currentMode === "select" ? board : null

        onWheel: wheel => {
            board.x += wheel.angleDelta.x;
            board.y += wheel.angleDelta.y;
        }
    }

    Item {
        id: board
        objectName: "board"

        DrawingCanvas {
            id: drawingCanvas
            x: -width / 2
            y: -height / 2
            width: 10000
            height: 10000
            enabled: root.currentMode === "pen" || root.currentMode === "eraser"
            penColor: root.currentPenColor
            penSize: root.currentPenSize
        }

        Behavior on scale {
            SpringAnimation {
                duration: 180
                spring: 4
                damping: 0.37
            }
        }

        Behavior on x {
            SpringAnimation {
                duration: 180
                spring: 4
                damping: 0.37
            }
        }

        Behavior on y {
            SpringAnimation {
                duration: 180
                spring: 4
                damping: 0.37
            }
        }
    }

    ToolBar {
        id: toolBar

        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        z: 1000
        onClearAll: {
            drawingCanvas.clearAnnotations();
        }
        onUndo: drawingCanvas.undo()
        onRedo: drawingCanvas.redo()
    }
}
