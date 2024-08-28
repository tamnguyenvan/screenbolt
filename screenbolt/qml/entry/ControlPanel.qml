import QtQuick
import QtQuick.Effects
import QtQuick.Controls 2.15
import QtQuick.Layouts
import QtQuick.Dialogs
import "../components"

Item {
    id: layout
    width: homeWidth + closeButtonSize / 2
    height: homeHeight + closeButtonSize / 2
    anchors.bottom: parent.bottom
    anchors.bottomMargin: bottomMargin
    anchors.horizontalCenter: parent.horizontalCenter

    readonly property int homeWidth: 326
    readonly property int homeHeight: 200
    readonly property int closeButtonSize: 38
    property int bottomMargin: 120

    // Control panel
    Rectangle {
        id: home
        width: parent.homeWidth
        height: parent.homeHeight
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        color: "#1c1c1c"
        radius: 30
        border.width: 1
        border.color: "#464646"

        ColumnLayout {
            anchors.fill: parent
            anchors.top: parent.top
            anchors.topMargin: 20
            spacing: 10

            // First row: Mode buttons
            RowLayout {
                Layout.fillWidth: true
                Layout.preferredHeight: parent.height / 2
                Layout.alignment: Qt.AlignCenter
                spacing: 10

                ModeButton {
                    id: customButton
                    text: "Custom"
                    iconPath: "qrc:/resources/icons/custom.svg"
                    onClicked: {
                        customButton.activated = true
                        screenButton.activated = false
                        windowButton.activated = false
                        startupWindow.selectedMode = "custom"
                    }
                    Layout.preferredWidth: 90
                    Layout.preferredHeight: 80
                }

                ModeButton {
                    id: screenButton
                    text: "Screen"
                    iconPath: "qrc:/resources/icons/screen.svg"
                    activated: true
                    onClicked: {
                        customButton.activated = false
                        screenButton.activated = true
                        windowButton.activated = false
                        startupWindow.selectedMode = "screen"
                    }
                    Layout.preferredWidth: 90
                    Layout.preferredHeight: 80
                }

                ModeButton {
                    id: windowButton
                    text: "Window"
                    iconPath: "qrc:/resources/icons/window.svg"
                    onClicked: {
                        customButton.activated = false
                        screenButton.activated = false
                        windowButton.activated = true
                        startupWindow.selectedMode = "window"
                    }
                    Layout.preferredWidth: 90
                    Layout.preferredHeight: 80
                }
            }

            // Second row: record button + browse button
            RowLayout {
                Layout.fillWidth: true
                Layout.preferredHeight: parent.height / 2

                Item {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                }

                // Record button
                Item {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    RecordButton {
                        id: recordButton
                        anchors.centerIn: parent
                        onClicked: {
                            if (startupWindow.selectedMode == "custom") {
                                var region = [
                                    customSelector.customRegionX,
                                    customSelector.customRegionY,
                                    customSelector.customRegionWidth,
                                    customSelector.customRegionHeight
                                ]
                            } else if (startupWindow.selectedMode == "screen") {
                                var region = [
                                    startupWindow.x,
                                    startupWindow.y,
                                    startupWindow.width,
                                    startupWindow.height
                                ]
                            } else if (startupWindow.selectedMode == "window") {
                                var region = [
                                    windowController.left,
                                    windowController.top,
                                    Screen.desktopAvailableWidth,
                                    Screen.desktopAvailableHeight
                                ]
                            }

                            videoRecorder.region = region
                            countdownLoader.source = ""
                            countdownLoader.source = "qrc:/qml/countdown/Countdown.qml"
                            startupWindow.hide()
                        }
                    }
                }

                // Browse button
                Item {
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    ToolButton {
                        id: browseButton
                        anchors.centerIn: parent
                        icon.source: "qrc:/resources/icons/folder.svg"
                        icon.color: "#e8eaed"
                        icon.width: 24
                        icon.height: 24
                        padding: 10

                        onClicked: {
                            startupWindow.hide()
                            videoFileDialog.open()
                        }

                        background: Rectangle {
                            radius: width / 2
                            color: browseButton.hovered ? "#242424" : "#212121"
                        }
                    }
                }
            }
        }
    }

    Button {
        id: closeButton
        anchors.top: parent.top
        anchors.left: parent.left
        width: layout.closeButtonSize
        height: layout.closeButtonSize
        z: 1

        background: Item {
            anchors.fill: parent
            Rectangle {
                anchors.fill: parent
                radius: layout.closeButtonSize / 2
                color: closeButton.hovered ? Qt.lighter("#393939",
                                                        1.2) : "#393939"
                border.width: 1
                border.color: "#404040"
            }
            Image {
                anchors.centerIn: parent
                source: "qrc:/resources/icons/close.svg"
                width: parent.width / 2
                height: parent.height / 2
            }
        }

        onClicked: Qt.quit()
    }

    MultiEffect {
        source: home
        anchors.fill: home
        shadowBlur: 1.0
        shadowEnabled: true
        shadowColor: "black"
        shadowVerticalOffset: 0
        shadowHorizontalOffset: 0
    }
}
