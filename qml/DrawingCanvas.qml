import QtQuick
import QtQuick.Shapes

Item {
    id: drawingCanvas

    property string penColor
    property string penSize
    property var shapes: []
    property var stack: []

    z: 998

    function undo() {
        if (shapes.length === 0)
            return;

        stack.push(shapes[shapes.length - 1]);
        shapes = shapes.slice(0, shapes.length - 1);
    }

    function redo() {
        if (stack.length === 0)
            return;

        shapes = [...shapes, stack.pop()];
    }

    function clearAnnotations() {
        shapes = [];
    }

    function eraseOnClick(mouse) {
        for (let i = 0; i < drawingCanvas.shapes.length; i++) {
            const strokeWidth = Number(drawingCanvas.shapes[i].strokeWidth);
            for (let j = 0; j < drawingCanvas.shapes[i].points.length; j++) {
                const currentPoint = drawingCanvas.shapes[i].points[j];
                if (mouse.x >= currentPoint.x - strokeWidth && mouse.x <= currentPoint.x + strokeWidth && mouse.y >= currentPoint.y - strokeWidth && mouse.y <= currentPoint.y + strokeWidth) {
                    drawingCanvas.shapes = drawingCanvas.shapes.filter(shape => shape !== drawingCanvas.shapes[i]);
                    return;
                }
            }
        }
    }

    MouseArea {
        id: drawArea

        anchors.fill: parent
        enabled: root.currentMode === "pen" || root.currentMode === "eraser"

        onPressed: mouse => {
            if (root.currentMode === "pen") {
                currentShape.points = [Qt.point(mouse.x, mouse.y)];
            } else if (root.currentMode === "eraser") {
                drawingCanvas.eraseOnClick(mouse);
            }
        }

        onPositionChanged: mouse => {
            if (root.currentMode === "pen") {
                currentShape.points = [...currentShape.points, Qt.point(mouse.x, mouse.y)];
            } else if (root.currentMode === "eraser") {
                drawingCanvas.eraseOnClick(mouse);
            }
        }

        onReleased: {
            if (root.currentMode !== "pen")
                return;

            drawingCanvas.shapes = [...drawingCanvas.shapes,
                {
                    strokeColor: drawingCanvas.penColor,
                    strokeWidth: drawingCanvas.penSize,
                    points: currentShape.points
                }
            ];
            currentShape.points = [];
        }
    }

    Repeater {
        model: drawingCanvas.shapes

        delegate: Shape {
            required property var modelData
            ShapePath {
                strokeColor: modelData.strokeColor
                strokeWidth: modelData.strokeWidth

                fillColor: "transparent"
                capStyle: ShapePath.RoundCap
                joinStyle: ShapePath.RoundJoin

                PathPolyline {
                    path: modelData.points
                }
            }
        }
    }

    Shape {
        id: currentShape

        property var points: []

        ShapePath {
            strokeColor: drawingCanvas.penColor
            strokeWidth: drawingCanvas.penSize

            fillColor: "transparent"
            capStyle: ShapePath.RoundCap
            joinStyle: ShapePath.RoundJoin

            PathPolyline {
                path: currentShape.points
            }
        }
    }
}
