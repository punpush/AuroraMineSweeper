import QtQuick 2.6
import Sailfish.Silica 1.0
import "../../js/storage.js" as Stats

Page {
    id: game

    property int rows
    property int cols
    property int mines
    property string difficulty

    property int flagsUsed: 0
    property int seconds: 0
    property bool flagMode: false
    property bool gameOver: false
    property bool started: false

    property bool boardCreated: false
    property bool saveLoaded: false

    Timer {
        id: timer
        interval: 1000
        repeat: true
        running: started && !gameOver
        onTriggered: seconds++
    }

    PageHeader {
        id: header
        title: "⏱ " + seconds + "   🚩 " + flagsUsed + "/" + mines
    }

    Loader {
        id: boardLoader
        anchors.top: header.bottom
        anchors.bottom: modeRow.top
        anchors.left: parent.left
        anchors.right: parent.right
    }

    Connections {
        target: boardLoader
        onLoaded: {
            if (!boardCreated || saveLoaded)
                return

            var b = boardLoader.item
            b.flagMode = Qt.binding(function() { return game.flagMode })

            var saved = Stats.loadGame()

            if (saved &&
                saved.rows === rows &&
                saved.cols === cols &&
                saved.mines === mines &&
                !saved.gameOver) {

                b.grid = saved.grid
                b.grid.generated = saved.generated
                b.restoreGrid()

                seconds = saved.seconds
                flagsUsed = saved.flagsUsed
                flagMode = saved.flagMode
                started = saved.started
                gameOver = saved.gameOver

                if (started && !gameOver)
                    timer.start()

            } else {
                restart()
            }

            saveLoaded = true
        }
    }

    function tryCreateBoard() {
        if (rows > 0 && cols > 0 && mines > 0 && !boardCreated) {
            boardLoader.setSource("Board.qml", {
                rows: rows,
                cols: cols,
                mines: mines
            })
            boardCreated = true
        }
    }

    Row {
        id: modeRow
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: Theme.paddingLarge

        Button {
            width: Theme.itemSizeLarge
            text: game.flagMode ? qsTr("Flag") : qsTr("Open")
            onClicked: game.flagMode = !game.flagMode
        }

        Button {
            width: Theme.itemSizeLarge
            text: qsTr("Menu")
            onClicked: pageStack.pop()
        }

        Button {
            width: Theme.itemSizeLarge
            text: "↻"
            onClicked: game.restart()
        }
    }

    Connections {
        target: boardLoader.item
        ignoreUnknownSignals: true

        onGameLost: {
            game.gameOver = true
            timer.stop()
            Stats.addLoss(difficulty)
            Stats.clearSave()
        }

        onGameWon: {
            game.gameOver = true
            timer.stop()
            Stats.addWin(difficulty, seconds)
            Stats.clearSave()
        }

        onFlagChanged: game.flagsUsed = flags
        onFirstClick: {
            game.started = true
            timer.start()
        }
    }

    function restart() {
        seconds = 0
        flagsUsed = 0
        gameOver = false
        started = false

        if (boardLoader.item)
            boardLoader.item.reset()
    }

    onRowsChanged: tryCreateBoard()
    onColsChanged: tryCreateBoard()
    onMinesChanged: tryCreateBoard()

    onStatusChanged: {
        if (status === PageStatus.Deactivating && boardLoader.item) {
            Stats.saveGame({
                rows: rows,
                cols: cols,
                mines: mines,
                seconds: seconds,
                flagsUsed: flagsUsed,
                flagMode: flagMode,
                started: started,
                gameOver: gameOver,
                generated: boardLoader.item.grid.generated,
                grid: boardLoader.item.grid
            })
        }
    }
}
