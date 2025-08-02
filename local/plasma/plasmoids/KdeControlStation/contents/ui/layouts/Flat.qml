import QtQml 2.15
import QtQuick 2.15
import QtQuick.Layouts
import QtQuick.Controls 2.0
import "../components" as Components
import "components/ControlCenter" as LayoutComponents 
ColumnLayout {
    id: wrapper

    anchors.fill: parent
    anchors.margins: 1
    spacing: 1

    Components.MediaPlayer{
        Layout.preferredHeight: root.sectionHeight/1.5
    }

    GridLayout {
        id: buttonsColumn
        //anchors.fill: parent
        property int visibleWidgets: kdeConnect.visible + nightLight.visible + colorSwitcher.visible +  screenshot.visible + cmd1.visible + cmd2.visible
        anchors.margins: 1
        Layout.preferredHeight: visibleWidgets > 5 ? (root.sectionHeight * 1.5) :  root.sectionHeight
        Layout.maximumHeight: root.sectionHeight * 1.5
        rows: 3
        columns: 4
        flow: GridLayout.LeftToRight
        columnSpacing: 1
        rowSpacing: 1

        Components.NetworkBtn{
            Layout.maximumHeight: parent.height / 2
            Layout.alignment: Qt.AlignTop
            flat: true
            smallLeftMargins: true
            smallRightMargins: true
        }
        Components.BluetoothBtn{
            Layout.maximumHeight: parent.height / 2
            Layout.alignment: Qt.AlignTop
            flat: true
            smallLeftMargins: true
            smallRightMargins: true
        }
        Components.DndButton{
            Layout.maximumHeight: parent.height / 2
            Layout.alignment: Qt.AlignTop
            flat: true
            smallLeftMargins: true
            smallRightMargins: true
        }
        Components.KDEConnect{
            id: kdeConnect
            Layout.maximumHeight: parent.height / 2
            Layout.alignment: Qt.AlignTop
            flat: true
            smallLeftMargins: true
            smallRightMargins: true
        }
        Components.NightLight{
            id: nightLight
            Layout.maximumHeight: parent.height / 2
            Layout.alignment: Qt.AlignTop
            flat: true
            smallLeftMargins: true
            smallRightMargins: true
        }
        Components.ColorSchemeSwitcher{
            id: colorSwitcher
            Layout.maximumHeight: parent.height / 2
            Layout.alignment: Qt.AlignTop
            flat: true
            smallLeftMargins: true
            smallRightMargins: true
        }
        Components.ScreenshotBtn {
            id: screenshot
            Layout.maximumHeight: parent.height / 2
            Layout.alignment: Qt.AlignTop
            flat: true
            smallLeftMargins: true
            smallRightMargins: true
        }
        Components.CommandRun{
            id: cmd1
            visible: root.showCmd1
            title: root.cmdTitle1
            icon: root.cmdIcon1
            command: root.cmdRun1
            Layout.maximumHeight: parent.height / 2
            Layout.alignment: Qt.AlignTop
            flat: true
            smallLeftMargins: true
            smallRightMargins: true
        }
        Components.CommandRun{
            id: cmd2
            visible: root.showCmd2
            title: root.cmdTitle2
            icon: root.cmdIcon2
            command: root.cmdRun2
            Layout.maximumHeight: parent.height / 2
            Layout.alignment: Qt.AlignTop
            flat: true
            smallLeftMargins: true
            smallRightMargins: true
        }
    }
    Components.BrightnessSlider{
        id: brightnessSlider
        Layout.preferredHeight: root.sectionHeight / (root.brightness_widget_title ? 2 : 2.8)
        canTogglePage: true
    }
    Components.Volume{
        Layout.preferredHeight: root.sectionHeight / (root.volume_widget_title ? 2 : 2.8)
    }


    RowLayout {
        id: header
        spacing: 1
        Layout.fillWidth: true
        Layout.preferredHeight: root.sectionHeight/3.3
        anchors.margins: 1
        visible: header.children.length > 0

        Components.UserAvatar{
            flat: true
            singleLineWidget: true
        }
        Components.Battery {
            flat: true
            Layout.preferredWidth: header.Layout.preferredHeight * 1.7
            Layout.maximumWidth: Layout.preferredWidth
        }
        Components.SystemActions{
            flat: true
            Layout.preferredWidth: header.Layout.preferredHeight
            Layout.maximumWidth: Layout.preferredWidth
        }
    }
}