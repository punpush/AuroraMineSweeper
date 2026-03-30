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

    Board {
        id: board
        anchors.top: header.bottom
        anchors.bottom: modeRow.top
        anchors.left: parent.left
        anchors.right: parent.right

        rows: game.rows
        cols: game.cols
        mines: game.mines
        flagMode: game.flagMode

        onFirstClick: {
            game.started = true
            timer.start()
        }

        onFlagChanged: game.flagsUsed = flags
        onGameLost: {
            game.gameOver = true
            timer.stop()
            Stats.addLoss(difficulty)
        }
        onGameWon: {
            game.gameOver = true
            timer.stop()
            Stats.addWin(difficulty, seconds)
        }
    }

    Row {
        id: modeRow
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: Theme.paddingLarge

        Button {
            width: Theme.itemSizeLarge
            text: game.flagMode ? "Флаг" : "Откр."
            onClicked: game.flagMode = !game.flagMode
        }

        Button {
            width: Theme.itemSizeLarge
            text: "Меню"
            onClicked: pageStack.pop()
        }

        Button {
            width: Theme.itemSizeLarge
            text: "↻"
            onClicked: game.restart()
        }
    }

    function restart() {
        seconds = 0
        flagsUsed = 0
        gameOver = false
        started = false
        board.reset()
    }

    Component.onCompleted: {
        var saved = Stats.loadGame();
        if (saved && saved.rows === rows && saved.cols === cols && saved.mines === mines) {
            seconds = saved.seconds;
            flagsUsed = saved.flagsUsed;
            flagMode = saved.flagMode;
            started = saved.started;
            gameOver = saved.gameOver;

            board.grid = saved.grid;
            board.restoreGrid();
        }
    }

    onStatusChanged: {
        if (status === PageStatus.Deactivating) {
            Stats.saveGame({
                rows: game.rows,
                cols: game.cols,
                mines: game.mines,
                seconds: game.seconds,
                flagsUsed: game.flagsUsed,
                flagMode: game.flagMode,
                started: game.started,
                gameOver: game.gameOver,
                grid: board.grid
            })
        }
    }
}
