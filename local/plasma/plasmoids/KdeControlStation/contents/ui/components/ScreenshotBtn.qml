import QtQml 2.15
import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.0

import org.kde.plasma.plasmoid
//import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.plasma5support as Plasma5Support
import org.kde.kirigami as Kirigami 

import "../lib" as Lib
import "../js/colorType.js" as ColorType

Lib.CardButton {
    id: screenshotBtn

    visible: root.showScreenshot

    property bool mini: false 

    Layout.fillHeight: true
    Layout.fillWidth: true
    title: i18n("Screenshot")
    property string command:  "spectacle"
    Kirigami.Icon {
        anchors.fill: parent
        anchors.centerIn: parent
        source: "camera-photo-symbolic"
    }

    onClicked: {
        executable.exec(command);
    }

    Plasma5Support.DataSource {
        id: executable
        engine: "executable"
        connectedSources: []
        onNewData: { 
            disconnectSource(sourceName)
        }
        
        function exec(cmd) {
            connectSource(cmd)
        }
    }
}
