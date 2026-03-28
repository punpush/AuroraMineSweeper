function createGrid(rows, cols, mines) {
    let grid = []
    for (let i = 0; i < rows * cols; i++)
        grid.push({ mine: false, count: 0, opened: false, flag: false })
    grid.generated = false
    return grid
}

function placeMines(grid, rows, cols, mines, safeIndex) {
    let placed = 0
    while (placed < mines) {
        let i = Math.floor(Math.random() * grid.length)
        if (i === safeIndex || grid[i].mine) continue
        grid[i].mine = true
        placed++
    }
    updateCounts(grid, rows, cols)
}

function updateCounts(grid, rows, cols) {
    for (let i = 0; i < grid.length; i++) {
        if (grid[i].mine) continue
        let c = 0
        neighbors(i, rows, cols).forEach(n => {
            if (grid[n].mine) c++
        })
        grid[i].count = c
    }
}

function neighbors(i, rows, cols) {
    let r = Math.floor(i / cols)
    let c = i % cols
    let list = []
    for (let dr = -1; dr <= 1; dr++)
        for (let dc = -1; dc <= 1; dc++) {
            if (dr === 0 && dc === 0) continue
            let rr = r + dr
            let cc = c + dc
            if (rr >= 0 && rr < rows && cc >= 0 && cc < cols)
                list.push(rr * cols + cc)
        }
    return list
}

function openCell(grid, rows, cols, i, callback) {
    if (grid[i].opened || grid[i].flag) return
    grid[i].opened = true
    callback(i)

    if (grid[i].count === 0) {
        neighbors(i, rows, cols).forEach(n => {
            if (!grid[n].opened)
                openCell(grid, rows, cols, n, callback)
        })
    }
}

function checkWin(grid) {
    return grid.every(c => c.opened || c.mine)
}
