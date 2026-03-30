import QtQuick 2.6
import Sailfish.Silica 1.0

Rectangle {
    id: cell
    width: parent.cellSize
    height: parent.cellSize

    color: opened ? "#d0d0d0" : "#808080"

    property int index
    property bool opened: false
    property bool flagged: false
    property bool flagMode: false

    signal openRequested()
    signal flagRequested()

    MouseArea {
        anchors.fill: parent
        onClicked: {
            if (cell.flagMode)
                flagRequested()
            else
                openRequested()
        }
        onPressAndHold: {
            if (cell.flagMode)
                openRequested()
            else
                flagRequested()
        }
    }

    Text {
        id: label
        anchors.centerIn: parent
        text: ""
        font.pixelSize: 28
    }

    function reveal(data) {
        opened = true
        color = "#e0e0e0"
        if (data.mine) {
            label.text = "💣"
        } else if (data.count > 0) {
            label.text = data.count
        }
    }

    function setFlag(f) {
        flagged = f
        label.text = f ? "🚩" : ""
    }

    function reset() {
        opened = false
        flagged = false
        color = "#808080"
        label.text = ""
    }
}
