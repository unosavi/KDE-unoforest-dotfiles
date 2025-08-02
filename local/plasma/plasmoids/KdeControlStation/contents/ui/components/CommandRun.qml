import QtQml 2.15
import QtQuick 2.15
import QtQuick.Layouts 1.15

import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.plasma5support as Plasma5Support
import org.kde.kirigami as Kirigami

import "../lib" as Lib
import "../js/funcs.js" as Funcs

Lib.CardButton {
    id: cmdRunButton
    Layout.fillWidth: true
    Layout.fillHeight: true
    property string icon;
    property string command;
    
    property color normalBgColor: root.enableTransparency ? 
           Qt.rgba(root.themeBgColor.r, root.themeBgColor.g, root.themeBgColor.b, root.transparencyLevel/100)
           : root.themeBgColor
           
    function exec(cmd) {
        executable.connectSource(cmd)
    }
    
    Kirigami.Icon {
        anchors.fill: parent
        source: icon
    }
    
    Timer {
        id: timer
        interval: 1500; 
        onTriggered: {
            cmdRunButton.customBgColor = normalBgColor;
        }
    }
    
    Plasma5Support.DataSource {
        id: executable
        engine: "executable"
        connectedSources: []

        onNewData: {
            disconnectSource(connectedSources)
            if(data["exit code"] == 0){
                timer.running = false;
                timer.restart();
                cmdRunButton.customBgColor = Kirigami.Theme.positiveTextColor;
                timer.running = true;
                
            } else {
                cmdRunButton.customBgColor = Kirigami.Theme.negativeTextColor;
                timer.running = true;
            }
        }
    }
    
    onClicked: {
        exec(command)
    }
}