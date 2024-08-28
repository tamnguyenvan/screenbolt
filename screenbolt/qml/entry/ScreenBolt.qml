import QtQuick
import QtQuick.Window 2.15
import QtQuick.Layouts 1.15
import QtQuick.Effects
import QtQuick.Controls.Material 2.15
import QtQuick.Dialogs
import "../components"

Window {
    id: startupWindow
    visible: true
    width: Screen.width
    height: Screen.height
    visibility: Window.FullScreen
    flags: Qt.FramelessWindowHint
    color: "transparent"

    property string selectedMode: "screen"
    property bool showCountdownFlag: false
    property bool showStudioFlag: false

    Item {
        id: homeItem
        anchors.fill: parent
        focus: true

        Rectangle {
            id: background
            anchors.fill: parent
            color: "transparent"
        }

        // Visualize selected region in screen mode mode
        Rectangle {
            id: screenModeSelector
            anchors.fill: parent
            color: "transparent"
            border.width: 2
            border.color: "#fff"
            visible: startupWindow.selectedMode == "screen"
        }

        // Visualize selected region in window mode
        Item {
            id: windowModeSelector
            anchors.fill: parent
            visible: startupWindow.selectedMode == "window"
            Rectangle {
                x: windowController.left
                y: windowController.top
                width: Screen.desktopAvailableWidth
                height: Screen.desktopAvailableHeight
                color: "transparent"
                border.width: 2
                border.color: "#fff"
            }
        }

        CustomSelector {
            id: customSelector
            visible: startupWindow.selectedMode == "custom"
        }

        // Control panel
        ControlPanel {}

        FileDialog {
            id: videoFileDialog
            nameFilters: ["Video files (*.mp4)"]
            onAccepted: {
                startupWindow.visible = true
                if (selectedFile) {
                    const metadata = {
                        'mouse_events': {'click': [], 'move': {}},
                        'region': [],
                    }
                    videoController.load_video(selectedFile,
                                            metadata)
                    clipTrackModel.set_video_len(0, videoController.video_len)

                    studioLoader.source = ""
                    studioLoader.source = "qrc:/qml/studio/Studio.qml"
                    studioLoader.item.showMaximized()
                    startupWindow.hide()
                }
            }

            onRejected: {
                startupWindow.showFullScreen()
            }
        }

        Keys.onPressed: event => {
                            if (event.key === Qt.Key_Escape) {
                                Qt.quit()
                            }
                        }
    }

    Loader {
        id: countdownLoader
    }

    Loader {
        id: studioLoader
    }
}
