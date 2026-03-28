import QtQuick 2.6
import Sailfish.Silica 1.0
import "../logic.js" as Logic

Item {
    id: board
    property int rows
    property int cols
    property int mines
    property bool flagMode

    signal firstClick()
    signal flagChanged(int flags)
    signal gameLost()
    signal gameWon()

    property var grid
    property int flags: 0

    Grid {
        id: gridView
        rows: board.rows
        columns: board.cols
        spacing: 2

        Repeater {
            model: rows * cols
            delegate: Cell {
                index: model.index
                onOpenRequested: board.handleOpen(index)
                onFlagRequested: board.handleFlag(index)
            }
        }
    }

    function reset() {
        grid = Logic.createGrid(rows, cols, mines)
        flags = 0
        flagChanged(flags)
        for (let i = 0; i < gridView.count; i++)
            gridView.itemAt(i).reset()
    }

    Component.onCompleted: reset()

    function handleOpen(i) {
        if (grid[i].flag) return

        if (!grid.generated) {
            Logic.placeMines(grid, rows, cols, mines, i)
            grid.generated = true
            firstClick()
        }

        if (grid[i].mine) {
            revealAll()
            gameLost()
            return
        }

        Logic.openCell(grid, rows, cols, i, function(idx) {
            gridView.itemAt(idx).reveal(grid[idx])
        })

        if (Logic.checkWin(grid)) {
            revealAll()
            gameWon()
        }
    }

    function handleFlag(i) {
        if (grid[i].opened) return

        grid[i].flag = !grid[i].flag
        flags += grid[i].flag ? 1 : -1
        flagChanged(flags)
        gridView.itemAt(i).setFlag(grid[i].flag)
    }

    function revealAll() {
        for (let i = 0; i < grid.length; i++)
            gridView.itemAt(i).reveal(grid[i])
    }
}
