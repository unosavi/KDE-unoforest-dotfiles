import QtQml 2.0
import QtQuick 2.0
import QtQuick.Layouts 1.15

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.kirigami as Kirigami

import "../../../components" as Components
import "../../../lib" as Lib

Lib.Card {
    id: sectionScreenControls
    Layout.fillWidth: true
    Layout.preferredHeight: root.sectionHeight
    Layout.alignment: Qt.AlignTop
   // visible: brightnessSlider.visible || root.showBrightness || root.showColorSwitcher || root.showNightLight
    flat: true
    noMargins: true
    // All Buttons
    ColumnLayout {
        id: buttonsColumn
        anchors.fill: parent
        anchors.margins: 1
        spacing: 1

        Components.DndButton{}
        RowLayout {
            id: secondaryRow
            visible: root.showColorSwitcher || root.showNightLight
            anchors.margins: 1
            spacing: 1
            Components.NightLight{}
            Components.KDEConnect{}
            Components.ScreenshotBtn {
            }
            Components.CommandRun{
                visible: root.showCmd1
                title: root.cmdTitle1
                icon: root.cmdIcon1
                command: root.cmdRun1
            }
            Components.CommandRun{
                visible: root.showCmd2
                title: root.cmdTitle2
                icon: root.cmdIcon2
                command: root.cmdRun2
            }
        }
    }
}
