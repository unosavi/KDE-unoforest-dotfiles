import QtQml 2.0
import QtQuick 2.0
import QtQuick.Layouts

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.kirigami as Kirigami

import "../../../components" as Components
import "../../../lib" as Lib

Lib.Card {
    id: sectionScreenControls
    Layout.fillWidth: true
    Layout.fillHeight: true
    //visible: brightnessSlider.visible || root.showBrightness || root.showColorSwitcher || root.showNightLight
    flat: true
    noMargins: true
    
    // All Buttons
    GridLayout {
        id: buttonsColumn
        anchors.fill: parent
        anchors.margins: 1
        Layout.alignment: Qt.AlignTop
        rows: 2
        columns: 2
        flow: GridLayout.LeftToRight
        columnSpacing: 1
        rowSpacing: 1
        uniformCellHeights: true
        Components.BrightnessSlider{
            id: brightnessSlider
            Layout.columnSpan: 2
            Layout.alignment: Qt.AlignTop
        }

        Components.NightLight{
            Layout.maximumHeight: parent.height / 2
             Layout.alignment: Qt.AlignTop
        }
        Components.ColorSchemeSwitcher{
            Layout.maximumHeight: parent.height / 2
            Layout.alignment: Qt.AlignTop
        }
        Components.ScreenshotBtn {
            Layout.maximumHeight: parent.height / 2
            Layout.alignment: Qt.AlignTop
        }
        Components.CommandRun{
            visible: root.showCmd1
            title: root.cmdTitle1
            icon: root.cmdIcon1
            command: root.cmdRun1
            Layout.maximumHeight: parent.height / 2
            Layout.alignment: Qt.AlignTop
        }
        Components.CommandRun{
            visible: root.showCmd2
            title: root.cmdTitle2
            icon: root.cmdIcon2
            command: root.cmdRun2
            Layout.maximumHeight: parent.height / 2
            Layout.alignment: Qt.AlignTop
        }
    }
}
