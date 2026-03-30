import QtQuick 2.6
import Sailfish.Silica 1.0
import "../../js/storage.js" as Stats

Page {
    id: statsPage

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height

        Column {
            id: column
            width: parent.width
            spacing: Theme.paddingLarge
            anchors.top: parent.top
            anchors.topMargin: Theme.paddingLarge

            PageHeader {
                title: qsTr("Statistics")
            }

            Repeater {
                model: ListModel {
                    ListElement{name: qsTr("Beginner"); value: 0}
                    ListElement{name: qsTr("Average"); value: 1}
                    ListElement{name: qsTr("Expert"); value: 2}
                }

                delegate: BackgroundItem {
                    width: parent.width - Theme.horizontalPageMargin * 2
                    anchors.horizontalCenter: parent.horizontalCenter
                    height: Theme.itemSizeExtraLarge * 1.4

                    Rectangle {
                        anchors.fill: parent
                        radius: Theme.paddingMedium
                        color: Theme.secondaryHighlightColor
                        opacity: pressed ? 0.25 : 0.15
                    }

                    Column {
                        anchors.fill: parent
                        anchors.margins: Theme.paddingLarge
                        spacing: Theme.paddingSmall

                        Label {
                            text: name
                            font.pixelSize: Theme.fontSizeLarge
                            color: Theme.primaryColor
                        }

                        Label {
                            text: qsTr("Wins") + ": " + ((Stats.get(value) || {}).wins || 0)
                            font.pixelSize: Theme.fontSizeMedium
                            color: Theme.secondaryColor
                        }

                        Label {
                            text: qsTr("Loses") + ": " + ((Stats.get(value) || {}).losses || 0)
                            font.pixelSize: Theme.fontSizeMedium
                            color: Theme.secondaryColor
                        }

                        Label {
                            text: qsTr("Best time") + ": " + ((Stats.get(value) || {}).best || "-")
                            font.pixelSize: Theme.fontSizeMedium
                            color: Theme.secondaryColor
                        }
                    }
                }
            }
        }
    }
}
