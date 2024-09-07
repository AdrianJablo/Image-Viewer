import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import Qt.labs.platform 1.1
import Qt.labs.folderlistmodel 2.1

Rectangle {
    id: root
    anchors.fill: parent

    FolderDialog {
        id: folderDialog
        title: "Choose a folder"
        onAccepted: {
            folderListModel.folder = folderDialog.folder
        }
    }

    FolderListModel {
        id: folderListModel
        nameFilters: ["*.jpg", "*.jpeg", "*.png", "*.bmp"]
    }

    ColumnLayout {
        anchors.fill: parent

        Button {
            text: "Choose Folder"
            onClicked: folderDialog.open()
        }

        ComboBox {
            id: viewSelector
            model: ["List View", "Table View", "Path View"]
        }

        Loader {
            id: viewLoader
            Layout.fillWidth: true
            Layout.fillHeight: true
            sourceComponent: viewSelector.currentIndex === 0 ? listViewComponent : (viewSelector.currentIndex === 1 ? tableViewComponent : pathViewComponent)
        }
    }

    Component {
        id: listViewComponent
        ListView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            model: folderListModel
            delegate: imageDelegate
        }
    }

    Component {
        id: tableViewComponent
        GridView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            model: folderListModel
            cellWidth: 100
            cellHeight: 100
            delegate: imageDelegate
        }
    }

    Component {
        id: pathViewComponent
        PathView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            model: folderListModel
            delegate: imageDelegate
            path: Path {
                startX: 0; startY: 0
                PathLine { x: 800; y: 600 }
            }
        }
    }

    Component {
        id: imageDelegate
        Item {
            width: 100
            height: 100
            Rectangle {
                width: 100
                height: 100
                border.color: "black"
                Image {
                    anchors.fill: parent
                    source: fileURL
                    fillMode: Image.PreserveAspectCrop
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        imagePopup.open();
                        enlargedImage.source = fileURL;
                    }
                }
            }
        }
    }

    Popup {
        id: imagePopup
        width: parent.width * 0.8
        height: parent.height * 0.8
        modal: true
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

        Rectangle {
            width: parent.width
            height: parent.height
            color: "white"
            border.color: "black"
            Image {
                id: enlargedImage
                anchors.fill: parent
                source: ""
                fillMode: Image.PreserveAspectFit
            }
        }
    }
}
