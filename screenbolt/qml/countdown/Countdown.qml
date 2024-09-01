import QtQuick
import QtQuick.Controls
import Qt.labs.platform

Window {
    id: countdownWindow
    visible: true
    width: Math.max(Screen.height / 3, 400)
    height: Math.max(Screen.height / 3, 400)
    x: (Screen.desktopAvailableWidth - width) / 2
    y: (Screen.desktopAvailableHeight - height) / 2
    flags: Qt.FramelessWindowHint | Qt.WindowStaysOnTopHint
    color: "transparent"

    readonly property int countdownTime: 3
    property bool isSystemTrayAvailable: false

    Item {
        anchors.fill: parent
        Rectangle {
            id: countdown
            anchors.fill: parent
            color: "#303030"
            radius: countdownWindow.width / 2
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
                        if (isSystemTrayAvailable) {
                            tray.visible = true
                            countdownWindow.visible = false
                        } else {
                            // Change ui to a stop button
                            countdownWindow.showMinimized()
                        }
                    }
                }
            }
        }

        Rectangle {
            anchors.fill: parent
            radius: countdownWindow.width / 2
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
            visible: timer.count > 0
        }

        Button {
            text: qsTr('Stop')
            anchors.centerIn: parent
            visible: timer.count <= 0
            onClicked: {
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
                        // tray.hide()
                        if (isSystemTrayAvailable) {
                            tray.hide()
                        } else {
                            countdownWindow.hide()
                        }
                    } else {}
            }
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
                        // tray.hide()
                        if (isSystemTrayAvailable) {
                            tray.hide()
                        }
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

    Component.onCompleted: {
        isSystemTrayAvailable = systemTrayChecker.isAvailable
        // isSystemTrayAvailable = false
    }

    onClosing: {
        videoRecorder.cancel_recording()
        Qt.quit()
    }
}
