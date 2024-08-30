import QtQuick
import QtQuick.Window
import QtQuick.Dialogs
import QtQuick.Controls.Material
import QtQuick.Layouts

Item {
    id: root
    Layout.fillWidth: true
    Layout.fillHeight: true

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
        color: "black"

        Item {
            anchors.fill: parent
            focus: true

            Image {
                anchors.fill: parent
                source: videoPreview.source
                fillMode: Image.PreserveAspectFit
                anchors.centerIn: parent
            }

            Keys.onPressed: event => {
                            if (event.key === Qt.Key_Escape) {
                                fullScreenWindow.hide()
                            } else if (event.key === Qt.Key_Space) {
                                videoController.toggle_play_pause()
                            } else if (event.key === Qt.Key_Left) {
                                videoController.prev_frame()
                            } else if (event.key === Qt.Key_Right) {
                                videoController.next_frame()
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