import QtQuick 2.11
import QtQuick.Controls 2.4

Item {
    id:__root
    property alias model : listView.model;

    property alias title: titleLabel.text
    property alias subtitle: subtitleLabel.text
    property alias thumbnail: thumbnailImage.source

    signal itemClicked(int index)
    Item {
        id: container_info
        height: childrenRect.height
        anchors.top: parent.top
        anchors.topMargin: 16
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0

        Item {
            id: item1
            width: height
            height: thumbnailImage.status === Image.Ready ? __root.height * 0.2 : 0
            anchors.horizontalCenterOffset: 0
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top

            Image {
                id: thumbnailImage
                anchors.fill: parent
                fillMode: Image.PreserveAspectCrop
                mipmap:true
            }
        }

        Item {
            id: item2

            width: __root.width
            height: titleLabel.text !== "" ? __root.height * 0.2 : 0
            anchors.top: item1.bottom
            anchors.topMargin: 0

            Text {
                id: titleLabel
                color: "#ffffff"
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 18
                anchors.bottomMargin: 152
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Text {
                id: subtitleLabel
                color: "#ffffff"
                font.pixelSize: 12
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: titleLabel.bottom
            }
        }
    }

    ListView {
        id: listView
        clip: true
        anchors.top: container_info.bottom
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.topMargin: 0
        delegate: MediaListItem{
            onItemClicked: {
                __root.itemClicked(index);
            }
        }
        ScrollBar.vertical: ScrollBar {
        }
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
