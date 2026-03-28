import QtQuick 2.6
import Sailfish.Silica 1.0
import "../logic.js" as Logic
import "../stats.js" as Stats

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

    SilicaFlickable {
        anchors.fill: parent

        Column {
            width: parent.width

            // HEADER
            Row {
                width: parent.width
                spacing: Theme.paddingLarge
                anchors.horizontalCenter: parent.horizontalCenter

                Label { text: "⏱ " + seconds }
                Label { text: "🚩 " + flagsUsed + "/" + mines }

                Button {
                    text: "Меню"
                    onClicked: pageStack.pop()
                }
                Button {
                    text: "↻"
                    onClicked: game.restart()
                }
            }

            // BOARD
            Board {
                id: board
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

            // CLICK MODE SWITCH
            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: Theme.paddingLarge

                Button {
                    text: game.flagMode ? "Режим: Флажок" : "Режим: Открытие"
                    onClicked: game.flagMode = !game.flagMode
                }
            }
        }
    }

    function restart() {
        seconds = 0
        flagsUsed = 0
        gameOver = false
        started = false
        board.reset()
    }
}
