function createGrid(rows, cols, mines) {
    var grid = [];
    for (var i = 0; i < rows * cols; i++)
        grid.push({ mine: false, count: 0, opened: false, flag: false });
    grid.generated = false;
    return grid;
}

function placeMines(grid, rows, cols, mines, safeIndex) {
    var fx = safeIndex % cols;
    var fy = Math.floor(safeIndex / cols);

    function isForbidden(x, y) {
        return Math.abs(x - fx) <= 1 && Math.abs(y - fy) <= 1;
    }

    function clearGrid() {
        for (var i = 0; i < grid.length; i++) {
            grid[i].mine = false;
            grid[i].count = 0;
        }
    }

    function computeNumbers() {
        for (var y = 0; y < rows; y++) {
            for (var x = 0; x < cols; x++) {
                var idx = y * cols + x;
                if (grid[idx].mine) continue;

                var count = 0;
                for (var dy = -1; dy <= 1; dy++) {
                    for (var dx = -1; dx <= 1; dx++) {
                        if (dx === 0 && dy === 0) continue;
                        var nx = x + dx;
                        var ny = y + dy;
                        if (nx >= 0 && nx < cols && ny >= 0 && ny < rows) {
                            if (grid[ny * cols + nx].mine)
                                count++;
                        }
                    }
                }
                grid[idx].count = count;
            }
        }
    }

    while (true) {
        clearGrid();

        var placed = 0;
        while (placed < mines) {
            var x = Math.floor(Math.random() * cols);
            var y = Math.floor(Math.random() * rows);

            if (isForbidden(x, y))
                continue;

            var idx = y * cols + x;
            if (!grid[idx].mine) {
                grid[idx].mine = true;
                placed++;
            }
        }

        computeNumbers();
        if (grid[safeIndex].count === 0)
            break;
    }
}

function updateCounts(grid, rows, cols) {
    for (var i = 0; i < grid.length; i++) {
        if (grid[i].mine) continue;
        var c = 0;

        var neigh = neighbors(i, rows, cols);
        for (var j = 0; j < neigh.length; j++) {
            if (grid[neigh[j]].mine)
                c++;
        }

        grid[i].count = c;
    }
}

function neighbors(i, rows, cols) {
    var r = Math.floor(i / cols);
    var c = i % cols;
    var list = [];

    for (var dr = -1; dr <= 1; dr++) {
        for (var dc = -1; dc <= 1; dc++) {
            if (dr === 0 && dc === 0) continue;

            var rr = r + dr;
            var cc = c + dc;

            if (rr >= 0 && rr < rows && cc >= 0 && cc < cols)
                list.push(rr * cols + cc);
        }
    }

    return list;
}

function openCell(grid, rows, cols, i, callback) {
    if (grid[i].opened || grid[i].flag) return;

    grid[i].opened = true;
    callback(i);

    if (grid[i].count === 0) {
        var neigh = neighbors(i, rows, cols);
        for (var j = 0; j < neigh.length; j++) {
            var n = neigh[j];
            if (!grid[n].opened)
                openCell(grid, rows, cols, n, callback);
        }
    }
}

function checkWin(grid) {
    for (var i = 0; i < grid.length; i++) {
        var c = grid[i];
        if (!c.opened && !c.mine)
            return false;
    }
    return true;
}
