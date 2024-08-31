import QtQuick
import QtQuick.Window
import QtQuick.Dialogs
import QtQuick.Controls.Material
import QtQuick.Layouts

Item {
    id: root
    Layout.fillWidth: true
    Layout.fillHeight: true

    readonly property string accentColor: "#e85c0d"
    Material.theme: Material.Dark
    Material.primary: accentColor
    Material.accent: accentColor

    Rectangle {
        anchors.fill: parent
        radius: 4
        clip: true
        color: "#131519"
        Image {
            id: videoPreview
            anchors.fill: parent
            fillMode: Image.PreserveAspectFit
            onStatusChanged: {
                if (status === Image.Error) {
                    console.error("Error loading image:", source)
                }
            }
        }
    }

    // Full screen button
    ToolButton {
        id: fullScreenButton
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 0
        icon.source: "qrc:/resources/icons/full_screen.svg"
        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            hoverEnabled: true
            onPressed: {
                fullScreenWindow.showFullScreen()
            }
        }
    }

    // Full screen window
    Window {
        id: fullScreenWindow
        width: Screen.width
        height: Screen.height
        flags: Qt.Window | Qt.FramelessWindowHint
        visible: false

        Item {
            anchors.fill: parent
            focus: true

            Image {
                id: fullScreenImage
                anchors.fill: parent
                source: videoPreview.source
                fillMode: Image.PreserveAspectFit
                anchors.centerIn: parent
            }

            // The progress bar and controls
            Rectangle {
                id: controlBar
                width: parent.width - 4
                height: 80
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                visible: false
                color: "#3c3c3c"

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 8
                    spacing: 4

                    RowLayout {
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        Layout.preferredHeight: 1

                        Text {
                            text: qsTr("00:00")
                            color: "#fff"
                        }

                        // Rectangle {
                        //     Layout.fillWidth: true
                        //     Layout.preferredHeight: 12
                        //     color: studioWindow.accentColor
                        //     radius: height / 2
                        // }
                        Slider {
                            from: 0
                            to: 100
                            value: 0
                            Layout.fillWidth: true
                            Layout.preferredHeight: 12
                        }

                        Text {
                            text: qsTr("00:00")
                            color: "#fff"
                        }
                    }

                    RowLayout {
                        Layout.fillHeight: true
                        Layout.fillWidth: true

                        Layout.preferredHeight: 1

                        Item {
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                        }

                        ToolButton {
                            icon.source: "qrc:/resources/icons/prev.svg"
                            icon.color: "#e8eaed"
                            onClicked: videoController.prev_frame()
                        }
                        ToolButton {
                            icon.source: isPlaying ? "qrc:/resources/icons/pause.svg" : "qrc:/resources/icons/play.svg"
                            icon.color: "#e8eaed"
                            onClicked: videoController.toggle_play_pause()
                        }
                        ToolButton {
                            icon.source: "qrc:/resources/icons/next.svg"
                            icon.color: "#e8eaed"
                            onClicked: videoController.next_frame()
                        }
                        Item {
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                        }

                    }
                }
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onPositionChanged: {
                    controlBar.visible = true
                    hideControlBarTimer.restart()
                }
            }

            Timer {
                id: hideControlBarTimer
                interval: 2000
                repeat: false
                onTriggered: controlBar.visible = false
            }

            Keys.onPressed: event => {
                if (event.key === Qt.Key_Escape) {
                    fullScreenWindow.hide()
                } else if (event.key === Qt.Key_F) {
                    fullScreenWindow.hide()
                } else if (event.key === Qt.Key_Space) {
                    videoController.toggle_play_pause()
                    controlBar.visible = true
                    hideControlBarTimer.restart()
                } else if (event.key === Qt.Key_Left) {
                    videoController.prev_frame()
                    controlBar.visible = true
                    hideControlBarTimer.restart()
                } else if (event.key === Qt.Key_Right) {
                    videoController.next_frame()
                    controlBar.visible = true
                    hideControlBarTimer.restart()
                }
            }
        }
    }

    Connections {
        target: videoController
        function onFrameReady(frame) {
            videoPreview.source = "image://frames/frame?" + Date.now()
        }
    }
}
