import QtQuick
import QtQuick.Window 2.15
import QtQuick.Controls.Material 2.15

Window {
    id: mainWindow
    width: Screen.desktopAvailableWidth
    height: Screen.desktopAvailableHeight
    visible: true
    color: "transparent"

    Component.onCompleted: {
        windowController.get_window_position()
        screenbolt.source = ""
        screenbolt.source = "qrc:/qml/entry/ScreenBolt.qml"
        mainWindow.hide()
    }

    Loader { id: screenbolt }
}