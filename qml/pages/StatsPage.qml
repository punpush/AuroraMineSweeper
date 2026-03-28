import QtQuick 2.6
import Sailfish.Silica 1.0
import "../stats.js" as Stats

Page {
    SilicaListView {
        anchors.fill: parent
        model: ["Новичок", "Средний", "Эксперт"]

        delegate: ListItem {
            Label {
                text: modelData + ": Побед " + Stats.get(modelData).wins +
                      ", Поражений " + Stats.get(modelData).losses +
                      ", Лучшее время: " + (Stats.get(modelData).best || "-")
            }
        }
    }
}
