import QtQuick 2.15
import QtQuick.Layouts 1.15
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.components as PlasmaComponents2
import org.kde.plasma.components as PlasmaComponents
import org.kde.kquickcontrolsaddons as KQuickAddons
import org.kde.coreaddons as KCoreAddons
import org.kde.plasma.workspace.components 2.0
import org.kde.kirigami as Kirigami
import org.kde.plasma.plasma5support as Plasma5Support

import "../lib" as Lib

Lib.Card { 
    id: battery

    Layout.fillHeight: true
    Layout.fillWidth: true
    smallTopMargins: true
    smallBottomMargins: true

    Plasma5Support.DataSource {
        id: pmSource
        engine: "powermanagement"
        connectedSources: sources
        function performOperation(what) {
            var service = serviceForSource("PowerDevil")
            var operation = service.operationDescription(what)
            service.startOperationCall(operation)
        }
    }

    property var battery: pmSource.data["Battery"]

    visible: battery.battery["Has Battery"] && root.showBattery

    RowLayout {
        anchors.fill: parent
        anchors.margins: root.mediumSpacing
        spacing: 0
        clip: true
        
        BatteryIcon {
            id: batteryIcon

            Layout.alignment: Qt.AlignRight | Qt.AlignVcenter
            Layout.rightMargin: 5
            Layout.preferredWidth: Kirigami.Units.iconSizes.medium
            Layout.preferredHeight: Kirigami.Units.iconSizes.medium

            percent: battery.battery.Percent
            hasBattery: battery.battery["Has Battery"]
            pluggedIn: battery.battery.State === "Charging"

        }

        PlasmaComponents.Label {
            id: percentLabel
            horizontalAlignment: Text.AlignLeft
            text: i18nc("Placeholder is battery percentage", "%1%", battery.battery.Percent)
            font.pixelSize: root.mediumFontSize
            font.weight:Font.Bold
        }
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        hoverEnabled: false
        onClicked: {
            var pageHeight =  batteryPage.contentItemHeight + batteryPage.headerHeight;
            fullRep.togglePage(fullRep.defaultInitialWidth, pageHeight, batteryPage);
        }
    }
}
