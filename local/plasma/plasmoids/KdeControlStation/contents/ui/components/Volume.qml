import QtQml 2.15
import QtQuick 2.15
import QtQuick.Layouts 1.15

import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.private.volume as Vol

import "../lib" as Lib
import "../js/funcs.js" as Funcs

Lib.Slider {
    Layout.fillWidth: true
    Layout.fillHeight: true
    visible: sinkAvailable && root.showVolume
    useIconButton: true
    title: i18n("Volume")
    canTogglePage: true
    
    // Volume Feedback
    Vol.VolumeFeedback {
        id: feedback
    }
    
    // Audio source
    property var sink: Vol.PreferredDevice.sink
    readonly property bool sinkAvailable: sink && !(sink && sink.name == "auto_null")
    readonly property Vol.SinkModel paSinkModel: Vol.SinkModel {
        id: paSinkModel
    }
    
    value: Math.round(sink.volume / Vol.PulseAudio.NormalVolume * 100)
    secondaryTitle: Math.round(sink.volume / Vol.PulseAudio.NormalVolume * 100) + "%"

    showTitle: root.volume_widget_title
    thinSlider: root.volume_widget_thin
    flat: root.volume_widget_flat // bind to Lib.Card property
    
    // Changes icon based on the current volume percentage
    source: Funcs.volIconName(sink.volume, sink.muted)

    onPressedChanged: {
        if (!pressed) {
            // Make sure to sync the volume once the button was
            // released.
            // Otherwise it might be that the slider is at v10
            // whereas PA rejected the volume change and is
            // still at v15 (e.g.).
            volumePage.playFeedback(sink.Index);
        }
    }
    
    onMoved: {
        sink.volume = value * Vol.PulseAudio.NormalVolume / 100
    }
    // Display view that shows audio devices list
    onTogglePage: {
        var pageHeight =  volumePage.contentItemHeight + volumePage.headerHeight;
        fullRep.togglePage(fullRep.defaultInitialWidth, pageHeight, volumePage);
    }
    
    property var oldVol: 100 * Vol.PulseAudio.NormalVolume / 100
    onClicked: {
        if(value!=0){
            oldVol = sink.volume
            sink.volume=0
        } else {
            sink.volume=oldVol
        }
    }
}