import QtQuick 2.6
import Sailfish.Silica 1.0
import "../../js/logic.js" as Logic

Item {
    id: board
    anchors.fill: parent

    property int rows: 1
    property int cols: 1
    property int mines: 0
    property bool flagMode: false

    signal firstClick()
    signal flagChanged(int flags)
    signal gameLost()
    signal gameWon()

    property var grid
    property int flags: 0

    property real cellSize: (rows > 0 && cols > 0)
                            ? Math.floor(
                                  Math.min(
                                      (width - Theme.paddingLarge * 2) / cols,
                                      (height - Theme.paddingLarge * 2) / rows
                                  )
                              )
                            : 0

    Grid {
        id: gridView
        rows: board.rows
        columns: board.cols
        spacing: 2
        anchors.centerIn: parent

        width: board.cols * board.cellSize + (board.cols - 1) * spacing
        height: board.rows * board.cellSize + (board.rows - 1) * spacing

        Repeater {
            id: rep
            model: (board.rows > 0 && board.cols > 0)
                   ? board.rows * board.cols
                   : 0

            delegate: Cell {
                index: model.index
                width: board.cellSize
                height: board.cellSize
                flagMode: board.flagMode

                onOpenRequested: board.handleOpen(index)
                onFlagRequested: board.handleFlag(index)
            }
        }
    }

    function reset() {
        grid = Logic.createGrid(rows, cols, mines)
        flags = 0
        flagChanged(flags)

        for (var i = 0; i < rep.count; i++) {
            var item = rep.itemAt(i)
            if (item)
                item.reset()
        }
    }

    function restoreGrid() {
        for (var i = 0; i < rep.count; i++) {
            var item = rep.itemAt(i);
            if (!item) continue;

            var cell = grid[i];

            if (cell.opened)
                item.reveal(cell);
            else if (cell.flag)
                item.setFlag(true);
            else
                item.reset();
        }
    }

    Component.onCompleted: reset()

    function handleOpen(i) {
        if (!grid || !grid[i]) return
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
            var item = rep.itemAt(idx)
            if (item)
                item.reveal(grid[idx])
        })

        if (Logic.checkWin(grid)) {
            revealAll()
            gameWon()
        }
    }

    function handleFlag(i) {
        if (!grid || !grid[i]) return
        if (grid[i].opened) return

        grid[i].flag = !grid[i].flag
        flags += grid[i].flag ? 1 : -1
        flagChanged(flags)

        var item = rep.itemAt(i)
        if (item)
            item.setFlag(grid[i].flag)
    }

    function revealAll() {
        if (!grid) return
        for (var i = 0; i < grid.length; i++) {
            var item = rep.itemAt(i)
            if (item)
                item.reveal(grid[i])
        }
    }
}
