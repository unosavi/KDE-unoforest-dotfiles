import QtQuick 2.15
import QtQuick.Layouts 1.15
//import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.components as PlasmaComponents
import org.kde.plasma.plasma5support as Plasma5Support
import org.kde.kirigami as Kirigami
import Qt5Compat.GraphicalEffects

import org.kde.plasma.private.mpris as Mpris

import "../lib" as Lib

Lib.Card {
    id: mediaPlayer
    visible: root.showMediaPlayer
    property bool small: width < (root.fullRepWidth / 4)*3 
    Layout.fillWidth: true
    Layout.fillHeight: true
    
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true

        onClicked: {
            fullRep.togglePage(fullRep.defaultInitialWidth, fullRep.defaultInitialHeight, mediaPlayerPage);
        }
    }

    GridLayout {
        anchors.fill: parent
        anchors.margins: root.largeSpacing

        rows: small ? 4 : 1
        columns: small? 1 : 3

        Image {
            id: audioThumb
            fillMode: Image.PreserveAspectCrop
            source: mediaPlayerPage.albumArt || "../../assets/music.svg"
            Layout.fillHeight: true
            Layout.preferredWidth: height
            Layout.rowSpan: small ? 2 : 1
            enabled: mediaPlayerPage.track || (mediaPlayerPage.playbackStatus > Mpris.PlaybackStatus.Stopped) ? true : false

            ColorOverlay {
                visible: !mediaPlayerPage.albumArt && audioThumb.enabled
                anchors.fill: audioThumb
                source: audioThumb
                color: Kirigami.Theme.textColor
            }

            layer.enabled: true
            layer.effect: OpacityMask {
                maskSource: Item {
                    width: audioThumb.width
                    height: audioThumb.height
                    Rectangle {
                        anchors.centerIn: parent
                        width: audioThumb.adapt ? audioThumb.width : Math.min(audioThumb.width, audioThumb.height)
                        height: audioThumb.adapt ? audioThumb.height : width
                        radius: 12//Math.min(width, height)
                    }
                }
            }
        }
        ColumnLayout {
            id: mediaNameWrapper
           // Layout.margins: root.smallSpacing
            Layout.fillHeight: true
            spacing: 0

            PlasmaComponents.Label {
                id: audioTitle
                Layout.fillWidth: true
                font.capitalization: Font.Capitalize
                font.weight: Font.Bold
                font.pixelSize: root.largeFontSize
                enabled: mediaPlayerPage.track || (mediaPlayerPage.playbackStatus > Mpris.PlaybackStatus.Stopped) ? true : false
                elide: Text.ElideRight
                text: mediaPlayerPage.track ? mediaPlayerPage.track : (mediaPlayerPage.playbackStatus > Mpris.PlaybackStatus.Stopped) ? i18n("No title") : i18n("No media playing")
            }
            PlasmaComponents.Label {
                id: audioArtist
                Layout.fillWidth: true
                font.pixelSize: root.mediumFontSize
                text: mediaPlayerPage.artist
                elide: Text.ElideRight
            }
        }
        RowLayout {
            id: audioControls
            Layout.alignment: small ? Qt.AlignHCenter : Qt.AlignRight
            Layout.fillWidth: true

            PlasmaComponents.ToolButton {
                id: previousButton
                Layout.preferredHeight: mediaNameWrapper.implicitHeight
                Layout.preferredWidth: height
                icon.name: "media-skip-backward"
                enabled: mediaPlayerPage.canGoPrevious
                onClicked: {
                    //seekSlider.value = 0    // Let the media start from beginning. Bug 362473
                    mediaPlayerPage.previous()
                }
            }

            PlasmaComponents.ToolButton { // Pause/Play
                id: playPauseButton

                Layout.preferredHeight: mediaNameWrapper.implicitHeight
                Layout.preferredWidth: height

                Layout.alignment: Qt.AlignVCenter
                enabled: mediaPlayerPage.isPlaying ? mediaPlayerPage.canPause : mediaPlayerPage.canPlay
                icon.name: mediaPlayerPage.isPlaying ? "media-playback-pause" : "media-playback-start"

                onClicked: mediaPlayerPage.togglePlaying()
            }


            PlasmaComponents.ToolButton {
                id: nextButton
                Layout.preferredHeight: mediaNameWrapper.implicitHeight
                Layout.preferredWidth: height
                icon.name: "media-skip-forward"
                enabled: mediaPlayerPage.canGoNext
                onClicked: {
                    //seekSlider.value = 0    // Let the media start from beginning. Bug 362473
                    mediaPlayerPage.next()
                }
            }
        }
    }


}
