var stats = {
    "Новичок": { wins: 0, losses: 0, best: null },
    "Средний": { wins: 0, losses: 0, best: null },
    "Эксперт": { wins: 0, losses: 0, best: null }
}

function save() {
    localStorage.setItem("minesweeper_stats", JSON.stringify(stats))
}

function load() {
    let s = localStorage.getItem("minesweeper_stats")
    if (s) stats = JSON.parse(s)
}

load()

function addWin(diff, time) {
    stats[diff].wins++
    if (stats[diff].best === null || time < stats[diff].best)
        stats[diff].best = time
    save()
}

function addLoss(diff) {
    stats[diff].losses++
    save()
}

function get(diff) {
    return stats[diff]
}
