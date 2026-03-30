import QtQuick 2.6
import Sailfish.Silica 1.0

Page {
    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height

        Column {
            PageHeader {
                title: qsTr("Select difficulty")
            }

            id: column
            width: parent.width
            spacing: Theme.paddingLarge
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: Theme.paddingLarge

            Repeater {
                model: [
                    { name: qsTr("Beginner"), rows: 9, cols: 9, mines: 10 },
                    { name: qsTr("Average"), rows: 16, cols: 16, mines: 40 },
                    { name: qsTr("Expert"), rows: 30, cols: 16, mines: 99 }
                ]

                delegate: BackgroundItem {
                    width: parent.width * 0.9
                    height: Theme.itemSizeExtraLarge
                    anchors.horizontalCenter: parent.horizontalCenter

                    Rectangle {
                        anchors.fill: parent
                        radius: Theme.paddingMedium
                        color: pressed ? Theme.highlightColor : Theme.secondaryHighlightColor
                        opacity: pressed ? 0.25 : 0.15
                    }

                    Row {
                        anchors.fill: parent
                        anchors.margins: Theme.paddingLarge
                        spacing: Theme.paddingLarge

                        Item {
                            width: 100
                            height: 100
                            Item {
                                id: previewContainer
                                anchors.centerIn: parent

                                width: modelData.cols * 10
                                height: modelData.rows * 10

                                scale: Math.min(100 / width, 100 / height)

                                Grid {
                                    anchors.fill: parent
                                    rows: modelData.rows
                                    columns: modelData.cols
                                    spacing: 1

                                    Repeater {
                                        model: modelData.rows * modelData.cols

                                        Rectangle {
                                            width: 10
                                            height: 10
                                            color: "#d0d0d0"
                                            border.color: "#808080"
                                            border.width: 1
                                        }
                                    }
                                }
                            }
                        }

                        Column {
                            spacing: Theme.paddingSmall
                            anchors.verticalCenter: parent.verticalCenter

                            Label {
                                text: modelData.name
                                font.pixelSize: Theme.fontSizeLarge
                            }

                            Label {
                                text: modelData.rows + "×" + modelData.cols + " · " + modelData.mines + qsTr(" mines")
                                font.pixelSize: Theme.fontSizeSmall
                                color: Theme.secondaryColor
                            }
                        }
                    }

                    onClicked: pageStack.push(
                        Qt.resolvedUrl("GamePage.qml"),
                        {
                            rows: modelData.rows,
                            cols: modelData.cols,
                            mines: modelData.mines,
                            difficulty: modelData.name
                        }
                    )
                }
            }

            Button {
                width: parent.width
                text: qsTr("Statistics")
                onClicked: pageStack.push(Qt.resolvedUrl("StatsPage.qml"))
            }
        }
    }
}
