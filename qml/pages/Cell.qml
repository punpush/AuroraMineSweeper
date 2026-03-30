import QtQuick 2.6
import Sailfish.Silica 1.0

Rectangle {
    id: cell
    width: parent.cellSize
    height: parent.cellSize

    property int index
    property bool opened: false
    property bool flagged: false
    property bool flagMode: false

    color: opened ? "#d0d0d0" : "#808080"

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
        if (data.mine)
            label.text = "💣"
        else if (data.count > 0)
            label.text = data.count

        switch (data.count) {
        case 0:
            color = "#e0e0e0"
            break
        case 1:
            color = "#b6ffb6"
            break
        case 2:
            color = "#fff7a8"
            break
        case 3:
            color = "#ffcf8a"
            break
        case 4:
            color = "#ff9e9e"
            break
        case 5:
            color = "#ff7f7f"
            break
        case 6:
            color = "#ff5c5c"
            break
        case 7:
            color = "#ff3d3d"
            break
        case 8:
            color = "#ff1f1f"
            break
        default:
            color = "#ff6666"
            break
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
