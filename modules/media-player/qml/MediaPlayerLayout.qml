import QtQuick 2.11
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.0
import QtMultimedia 5.7
import Qt.labs.settings 1.0
import QtGraphicalEffects 1.0
import QtQml 2.3

import HUDTheme 1.0

Item {
    id: __root
    function getReadableTime(milliseconds){
        var minutes = Math.floor(milliseconds / 60000);
        var seconds = ((milliseconds % 60000) / 1000).toFixed(0);
        return (seconds == 60 ? (minutes+1) + ":00" : minutes + ":" + (seconds < 10 ? "0" : "") + seconds);
    }
    clip: true

    Item {
        id: main
        anchors.top: top_menu.bottom
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.left: parent.left

        Item {
            id: background
            anchors.fill: parent
            anchors.leftMargin: parent.width * 0.05
            anchors.rightMargin: parent.width * 0.05
            anchors.bottomMargin: parent.height * 0.05
            anchors.topMargin: parent.height * 0.05
            visible: (thumbnail_image.status === Image.Ready)
            Rectangle {
                id:bgRec
                anchors.fill: parent
                visible: false
            }

            Image {
                id: background_image
                anchors.fill: parent
                horizontalAlignment: Image.AlignRight
                source: thumbnail_image.source
                mipmap: true
                fillMode: Image.PreserveAspectCrop
                smooth: true
                visible: false
                cache : true
                onSourceChanged: {
                    bgCanvas.loadImage(source)
                    bgCanvas.requestPaint()
                }
            }
            FastBlur {
                id: imageBlur
                anchors.fill: background_image
                source: background_image
                radius: 32
                smooth: true
                visible: false
            }

            LinearGradient {
                id: mask
                anchors.fill: parent
                gradient: Gradient {
                    GradientStop { position: 0.4; color: "#00ffffff" }
                    GradientStop { position: 0.7; color: "#ffffffff" }
                }
                start: Qt.point(0, 0)
                end: Qt.point(background_image.width, 0)
                visible: false
            }


            OpacityMask {
                id:opacityMask
                anchors.fill: imageBlur
                source: imageBlur
                maskSource:mask
                visible: false
            }
            Blend {
                anchors.fill: parent
                source: bgRec
                foregroundSource: opacityMask
                mode: "lighten"
            }

            Canvas {
                anchors.fill: parent
                visible: false
                id: bgCanvas
                renderStrategy : Canvas.Threaded
                onPaint: {
                    var ctx = bgCanvas.getContext('2d');
                    ctx.clearRect(0, 0, 255, 255);
                    ctx.drawImage(background_image.source,0,0, 255, 255)

                    var arr = ctx.getImageData(0, 0, 255, 255).data;
                    var len = arr.length;

                    var red = 0;
                    var green = 0;
                    var blue = 0;
                    var i = 0;

                    for (; i < len; i += 4) {
                        red += arr[i];
                        green += arr[i + 1];
                        blue += arr[i + 2];
                    }
                    var count = i/4;

                    var r = Math.round(red / count).toString(16);
                    var g = Math.round(green / count).toString(16);
                    var b = Math.round(blue / count).toString(16);

                    var color = "#"+r + g + b;
                    bgRec.color = color;
                    bgRec.visible = true;
                }
                onImageLoaded: {
                    requestPaint()
                }
            }
            Rectangle {
                anchors.fill: parent
                color: "#80000000"
            }
        }

        Item {
            id: wrapper
            anchors.fill: background
            anchors.rightMargin: 16
            anchors.leftMargin: 16
            anchors.bottomMargin: 16
            anchors.topMargin: 16

            Image {
                id: thumbnail_image
                width: parent.width * 0.3
                height: width
                anchors.verticalCenter: parent.verticalCenter
                fillMode: Image.PreserveAspectCrop
                anchors.left: parent.left
                anchors.leftMargin: 0
                mipmap:true
                cache : true
                source: "image://MediaPlayer/"+playlist.currentItemSource
            }

            Item {
                id: track_info
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: buttons.top
                anchors.topMargin: 0
                anchors.rightMargin: 8
                anchors.left: thumbnail_image.right
                anchors.leftMargin: 0

                Text {
                    id: media_title
                    color: "#ffffff"
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    anchors.right: parent.right
                    anchors.bottom: media_author.top
                    anchors.rightMargin: 0
                    anchors.left: parent.left
                    anchors.leftMargin: 0
                    font.pixelSize: 24
                    renderType: Text.NativeRendering;
                    font.hintingPreference: Font.PreferVerticalHinting
                }

                Text {
                    id: media_author
                    color: "#ffffff"
                    text:mediaplayer.metaData.contributingArtist?mediaplayer.metaData.contributingArtist:""
                    anchors.verticalCenter: parent.verticalCenter
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    anchors.right: parent.right
                    anchors.rightMargin: 0
                    anchors.left: parent.left
                    anchors.leftMargin: 0
                    font.pixelSize: 16
                    renderType: Text.NativeRendering;
                    font.hintingPreference: Font.PreferVerticalHinting
                }

                Text {
                    id: media_album_title
                    color: "#ffffff"
                    text: mediaplayer.metaData.albumTitle?mediaplayer.metaData.albumTitle:""
                    verticalAlignment: Text.AlignTop
                    horizontalAlignment: Text.AlignHCenter
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    anchors.right: parent.right
                    anchors.rightMargin: 0
                    anchors.left: parent.left
                    anchors.leftMargin: 0
                    anchors.top: media_author.bottom
                    anchors.topMargin: 0
                    font.pixelSize: 16
                    renderType: Text.NativeRendering;
                    font.hintingPreference: Font.PreferVerticalHinting
                }


            }

            RowLayout {
                id: buttons
                width: height * 5
                height: parent.height*0.15
                anchors.horizontalCenter: track_info.horizontalCenter
                anchors.bottom: slider_wrapper.top
                anchors.bottomMargin: 0

                ImageButton{
                    id: shuffle_button
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    checkable: true
                    imageSource: "qrc:/qml/icons/shuffle.png"
                    changeColorOnPress:false
                    onClicked: {
                        if(checked){
                            playlist.playbackMode = Playlist.Random
                        } else {
                            playlist.playbackMode = Playlist.Sequential
                        }
                    }
                }

                ImageButton{
                    id: prev_button
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    imageSource: "qrc:/qml/icons/skip-backward.png"
                    onClicked: mediaplayer.playlist.previous()
                }

                ImageButton{
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    imageSource: "qrc:/qml/icons/play.png"
                    id:playButton
                    onClicked: {
                        switch (mediaplayer.playbackState){
                        case MediaPlayer.PlayingState:
                            mediaplayer.pause()
                            break;
                        case MediaPlayer.PausedState:
                        case MediaPlayer.StoppedState:
                            mediaplayer.play()
                            break;
                        }
                    }
                }

                ImageButton{
                    id: next_button
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    imageSource: "qrc:/qml/icons/skip-forward.png"
                    onClicked: mediaplayer.playlist.next()
                }


                ImageButton {
                    id: loop_button
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    checked: (playlist.playbackMode == Playlist.CurrentItemInLoop || playlist.playbackMode == Playlist.Loop)
                    imageSource: "qrc:/qml/icons/refresh.png"
                    changeColorOnPress:false
                    text: {
                        switch(playlist.playbackMode){
                        case Playlist.CurrentItemInLoop:
                            return "1";
                        case Playlist.Loop:
                            return "All";
                        default:
                            return "";
                        }
                    }
                    onClicked: {
                        shuffle_button.checked = false
                        if(playlist.playbackMode == Playlist.Sequential || playlist.playbackMode == Playlist.Random){
                            playlist.playbackMode = Playlist.CurrentItemInLoop;
                        } else if (playlist.playbackMode == Playlist.CurrentItemInLoop){
                            playlist.playbackMode = Playlist.Loop;
                        } else {
                            playlist.playbackMode = Playlist.Sequential;
                        }
                    }
                }
            }

            Item {
                id: slider_wrapper
                height: parent.height * 0.2
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 8
                anchors.left: thumbnail_image.right
                anchors.leftMargin: 8
                anchors.right: parent.right
                anchors.rightMargin: 8

                Slider {
                    id: sliderHorizontal1
                    anchors.top: parent.top
                    anchors.topMargin: 0
                    value: mediaplayer.position
                    to: mediaplayer.duration
                    stepSize: 1
                    anchors.right: parent.right
                    anchors.rightMargin: 0
                    anchors.left: parent.left
                    anchors.leftMargin: 0
                    onValueChanged: {
                        if(value != mediaplayer.position){
                            mediaplayer.seek(value)
                        }
                    }
                }

                Text {
                    id: text1
                    color: "#ffffff"
                    text: getReadableTime(mediaplayer.position)
                    anchors.top: sliderHorizontal1.bottom
                    anchors.topMargin: 0
                    anchors.left: parent.left
                    anchors.leftMargin: 0
                    font.pixelSize: 12
                }

                Text {
                    id: text2
                    color: "#ffffff"
                    text: getReadableTime(mediaplayer.duration)
                    anchors.right: parent.right
                    anchors.rightMargin: 0
                    anchors.top: sliderHorizontal1.bottom
                    font.pixelSize: 12
                    anchors.topMargin: 0
                }
            }
        }

    }

    Rectangle {
        id: overlay
        color: "#000000"
        opacity: 0
        anchors.fill : parent

        MouseArea {
            id: mouseArea5
            enabled: false
            anchors.fill: parent
            onClicked: __root.state=""
        }
    }

    Playlist{
        id: playlist
        playbackMode : Playlist.Sequential
        onCurrentIndexChanged: {
            mediaplayer_settings.nowPlayingCurrentIndex = currentIndex
        }
    }


    MediaPlayer {
        id: mediaplayer
        playlist: playlist
        autoLoad: true
        audioRole: MediaPlayer.MusicRole

        onError: {
            console.log("Media Player error : " , error, errorString)
        }

        onStatusChanged: {
            if(status === 3 || status === 6){
                if(mediaplayer.metaData.title && mediaplayer.metaData.title !== ""){
                    media_title.text = mediaplayer.metaData.title
                } else {
                    var url = String(playlist.currentItemSource);
                    media_title.text = url.substring(url.lastIndexOf('/')+1);
                }
            }
        }

        onPaused: {
            playButton.imageSource = "qrc:/qml/icons/play.png";
        }
        onStopped: {
            playButton.imageSource = "qrc:/qml/icons/play.png";
        }
        onPlaying: {
            playButton.imageSource = "qrc:/qml/icons/pause.png";
        }
    }


    Component {
        id: mediaList

        MediaList {
            model: MediaPlayerPlugin.MediaListModel

            onItemClicked: {
                playlist.clear();

                MediaPlayerPlugin.PlaylistModel.setItems(MediaPlayerPlugin.MediaListModel.getItems());
                playlist.addItems(MediaPlayerPlugin.PlaylistModel.sources);

                __root.state = "";
                mediaDrawer.state = ""

                playlist.currentIndex = index;
                mediaplayer.play();
                stackView.clear()
            }
            onBack: stackView.pop()
        }

    }

    Component {
        id: mediaContainerList
        MediaContainerList {
            model:MediaPlayerPlugin.ContainerModel

            onItemClicked: {
                var item = MediaPlayerPlugin.ContainerModel.getItem(index)

                var filter = item.title
                if(item_type === "folders"){
                    filter = item.folder_id
                } else if(item_type === "playlists"){
                    filter = item.path
                }

                MediaPlayerPlugin.MediaListModel.setFilter(item_type, filter)
                stackView.push(mediaList,{
                                   "thumbnail" : "file://" + item.thumbnail,
                                   "title" : item.title,
                                   "subtitle" : item.subtitle }
                               )
                __root.state = "libraryView"
            }
        }
    }

    StackView {
        id: stackView
        width: parent.width * 0.7
        anchors.leftMargin: parent.width
        anchors.top: top_menu.bottom
        anchors.topMargin: 0
        anchors.left: main.left
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
    }

    MediaDrawer {
        id: mediaDrawer
        width: parent.width * 0.3
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.top: top_menu.bottom
        anchors.right: main.left
        anchors.rightMargin: 0
        currentPlaying: playlist.currentIndex
        onPlayListItemClicked: {
            playlist.currentIndex = index;
            __root.state="";
            mediaplayer.play();
        }

        onMediaPlayeritemClicked: {

            stackView.clear()
            switch(item_type){
            case "folders":
            case "playlists":
            case "artists":
            case "albums":
            case "genres":
                MediaPlayerPlugin.ContainerModel.setFilter(item_type);
                stackView.push(mediaContainerList,{"icon" : icon, "name" : name, "item_type" : item_type})
                break;
            case "songs":
                MediaPlayerPlugin.MediaListModel.setFilter("", "")
                stackView.push(mediaList,{"icon" : icon, "name" : name, "item_type" : item_type})
                break;
            default:
                break;
            }
            __root.state = "libraryView"
        }
    }

    TopMenu {
        id: top_menu
        height: parent.height*0.10
        anchors.top: parent.top
        anchors.topMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.right: parent.right
        anchors.rightMargin: 0
        onMenuClicked: {
            if(!menuButtonActive){
                __root.state="drawer";
            } else {
                __root.state="";
                stackView.clear()
            }
        }
        bg_opacity: 0
    }


    states: [
        State {
            name: "drawer"
            PropertyChanges {
                target: main
                anchors.topMargin: 0
                anchors.rightMargin: -1* parent.width * 0.3
                anchors.leftMargin: parent.width * 0.3
            }

            PropertyChanges {
                target: overlay
                opacity: 0.5
            }

            PropertyChanges {
                target: mouseArea5
                enabled: true
            }

            PropertyChanges {
                target: top_menu
                menuButtonActive: true
            }
        },
        State {
            name: "libraryView"
            PropertyChanges {
                target: main
                anchors.topMargin: 0
                anchors.leftMargin: parent.width * 0.3
                anchors.rightMargin: -1* parent.width * 0.3
            }

            PropertyChanges {
                target: overlay
                opacity: 0.9
            }

            PropertyChanges {
                target: __root
                clip: true
            }

            PropertyChanges {
                target: stackView
                anchors.leftMargin: 0
            }

            PropertyChanges {
                target: top_menu
                menuButtonActive: true
            }
        }
    ]
    transitions:[
        Transition {
            NumberAnimation { properties: "anchors.leftMargin,anchors.rightMargin,opacity,width,x"; duration: 250}
        }
    ]

    Settings {
        id: mediaplayer_settings
        property int nowPlayingCurrentIndex
        property alias thumbnailImage: thumbnail_image.source
    }

    Component.onCompleted : {
        playlist.addItems(MediaPlayerPlugin.PlaylistModel.sources);
        playlist.currentIndex = mediaplayer_settings.nowPlayingCurrentIndex;
    }

}

/*##^##
Designer {
    D{i:0;autoSize:true;formeditorColor:"#808080";height:480;width:640}
}
##^##*/
