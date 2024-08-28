import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import Qt.labs.platform

Window {
    id: coutndownWindow
    visible: true
    width: Math.max(Screen.height / 3, 400)
    height: Math.max(Screen.height / 3, 400)
    x: (Screen.desktopAvailableWidth - width) / 2
    y: (Screen.desktopAvailableHeight - height) / 2
    flags: Qt.FramelessWindowHint | Qt.WindowStaysOnTopHint
    color: "transparent"
    readonly property int countdownTime: 3

    Item {
        anchors.fill: parent
        Rectangle {
            id: countdown
            anchors.fill: parent
            color: "#303030"
            radius: coutndownWindow.width / 2
            opacity: 0.9
            Timer {
                id: timer
                interval: 1000
                repeat: true
                running: true
                property int count: countdownTime
                onTriggered: {
                    count--
                    if (count == 0) {
                        timer.stop()
                        videoRecorder.start_recording()
                        tray.visible = true
                        coutndownWindow.visible = false
                    }
                }
            }
        }

        Rectangle {
            anchors.fill: parent
            radius: coutndownWindow.width / 2
            color: "transparent"
            border.width: 3
            border.color: "#c4c4c4"
        }

        Text {
            text: timer.count
            anchors.centerIn: parent
            font.pixelSize: 120
            font.weight: 700
            color: "white"
        }
    }

    SystemTrayIcon {
        id: tray
        visible: false
        icon.source: "qrc:/resources/icons/screenbolt.svg"
        menu: Menu {
            MenuItem {
                text: qsTr("Stop")
                onTriggered: {
                    videoRecorder.stop_recording()
                    var metadata = {
                        'mouse_events': videoRecorder.mouse_events,
                        'region': videoRecorder.region,
                    }
                    var success = videoController.load_video(videoRecorder.output_path, metadata)
                    if (success) {
                        clipTrackModel.set_fps(videoController.fps)
                        clipTrackModel.set_video_len(0, videoController.video_len)
                        studioLoader.source = ""
                        studioLoader.source = "qrc:/qml/studio/Studio.qml"
                        studioLoader.item.showMaximized()
                        tray.hide()
                    } else {}
                }
            }
            MenuItem {
                text: qsTr("Cancel")
                onTriggered: {
                    videoRecorder.cancel_recording()
                    Qt.quit()
                }
            }
        }
    }

    Loader {
        id: studioLoader
    }
}
