import QtQuick 2.15
import QtQuick.Layouts 1.15
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.components as PlasmaComponents2
import org.kde.plasma.components as PlasmaComponents
import org.kde.kquickcontrolsaddons as KQuickAddons
import org.kde.coreaddons as KCoreAddons
import org.kde.plasma.workspace.components 2.0
import Qt5Compat.GraphicalEffects
import org.kde.kirigami as Kirigami

import "../lib" as Lib

Lib.Card {
    id: sysActions

    Layout.fillHeight: true
    Layout.fillWidth: true

   property bool showToolTip: false

    visible: root.showSessionActions
 
    PlasmaComponents.ToolTip {
        text: i18n("Power Off")
    }

    Kirigami.Icon {
        id: powerImage
        width: 23
        height: width
        anchors.centerIn: parent
        source: Qt.resolvedUrl("../icons/feather/pwr.svg")
        isMask: true
        color: Kirigami.Theme.textColor
    }

    PlasmaComponents.ToolTip {
        parent: sysActions
        visible: showToolTip
        text: i18n("Power Off")
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        hoverEnabled: true
        onClicked: {
            fullRep.togglePage(300, 350, systemSessionActionsPage);
        }
        onEntered: showToolTip = true
        onExited: showToolTip = false
    }
}



