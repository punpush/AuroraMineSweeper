.import QtQuick.LocalStorage 2.0 as LS

function getDB() {
    return LS.LocalStorage.openDatabaseSync(
        "MineSweeperStats",
        "1.0",
        "Stats database",
        10000
    )
}

function init() {
    var db = getDB()
    db.transaction(function(tx) {
        tx.executeSql(
            'CREATE TABLE IF NOT EXISTS stats (difficulty TEXT UNIQUE, wins INTEGER, losses INTEGER, best INTEGER)'
        )

        var diffs = ["Beginner", "Average", "Expert"]
        for (var i = 0; i < diffs.length; i++) {
            tx.executeSql(
                'INSERT OR IGNORE INTO stats VALUES (?, 0, 0, NULL)',
                [diffs[i]]
            )
        }
    })
}

function addWin(diff, time) {
    var db = getDB()
    db.transaction(function(tx) {
        var rs = tx.executeSql('SELECT best FROM stats WHERE difficulty = ?', [diff])
        var best = rs.rows.item(0).best

        if (best === null || time < best)
            best = time;

        tx.executeSql(
            'UPDATE stats SET wins = wins + 1, best = ? WHERE difficulty = ?',
            [best, diff]
        )
    })
}

function addLoss(diff) {
    var db = getDB()
    db.transaction(function(tx) {
        tx.executeSql(
            'UPDATE stats SET losses = losses + 1 WHERE difficulty = ?',
            [diff]
        )
    })
}

function get(diff) {
    var db = getDB()
    var result = null

    db.transaction(function(tx) {
        var rs = tx.executeSql(
            'SELECT wins, losses, best FROM stats WHERE difficulty = ?',
            [diff]
        )
        if (rs.rows.length > 0)
            result = rs.rows.item(0)
    })

    return result
}

function initSave() {
    var db = getDB()
    db.transaction(function(tx) {
        tx.executeSql(
            "CREATE TABLE IF NOT EXISTS savegame (" +
            "id INTEGER PRIMARY KEY, " +
            "rows INTEGER, cols INTEGER, mines INTEGER, " +
            "seconds INTEGER, flagsUsed INTEGER, " +
            "flagMode INTEGER, started INTEGER, gameOver INTEGER, " +
            "generated INTEGER, " +
            "grid TEXT)"
        )
    })
}

function saveGame(state) {
    var db = getDB()
    db.transaction(function(tx) {
        tx.executeSql("DELETE FROM savegame")
        tx.executeSql(
            "INSERT INTO savegame VALUES (1,?,?,?,?,?,?,?,?,?,?)",
            [
                state.rows,
                state.cols,
                state.mines,
                state.seconds,
                state.flagsUsed,
                state.flagMode ? 1 : 0,
                state.started ? 1 : 0,
                state.gameOver ? 1 : 0,
                state.generated ? 1 : 0,
                JSON.stringify(state.grid)
            ]
        )
    })
}

function loadGame() {
    var db = getDB()
    var result = null

    db.transaction(function(tx) {
        var rs = tx.executeSql("SELECT * FROM savegame WHERE id=1")
        if (rs.rows.length > 0) {
            var r = rs.rows.item(0)
            result = {
                rows: r.rows,
                cols: r.cols,
                mines: r.mines,
                seconds: r.seconds,
                flagsUsed: r.flagsUsed,
                flagMode: !!r.flagMode,
                started: !!r.started,
                gameOver: !!r.gameOver,
                generated: !!r.generated,
                grid: JSON.parse(r.grid)
            }
        }
    })

    return result
}

function clearSave() {
    var db = getDB();
    db.transaction(function(tx) {
        tx.executeSql("DELETE FROM savegame");
    });
}

// Инициализация таблицы при загрузке
init()
initSave()
