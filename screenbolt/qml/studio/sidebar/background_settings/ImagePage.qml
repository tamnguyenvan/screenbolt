import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Qt.labs.platform

Item {
    id: imagePage
    width: parent.width
    height: 200

    ColumnLayout {
        anchors.fill: parent
        spacing: 10

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 150
            color: "transparent"
            border.width: 2
            border.color: "#c2c2c2"
            radius: 4

            DropArea {
                anchors.fill: parent
                onDropped: {
                    if (drop.hasUrls) {
                        imagePreview.source = drop.urls[0]
                        videoController.background = {
                            "type": "image",
                            "value": drop.urls[0]
                        }
                        if (!isPlaying) {
                            videoController.get_current_frame()
                        }
                    }
                }

                Image {
                    id: imagePreview
                    anchors.fill: parent
                    fillMode: Image.PreserveAspectFit
                    visible: source.toString() !== ""
                }

                Text {
                    anchors.centerIn: parent
                    color: "white"
                    text: "Drag and drop an image here or click to select"
                    visible: imagePreview.source.toString() === ""
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: fileDialog.open()
                }
            }
        }
    }

    FileDialog {
        id: fileDialog
        title: "Select an image"
        nameFilters: ["Image files (*.png *.jpg *.bmp)"]
        onAccepted: {
            imagePreview.source = fileDialog.currentFile
            videoController.background = {
                "type": "image",
                "value": fileDialog.currentFile
            }
            if (!isPlaying) {
                videoController.get_current_frame()
            }
        }
    }
}
