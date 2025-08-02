import QtQml 2.15
import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.0
import "../components" as Components
import "components/Default" as LayoutComponents 

ColumnLayout {
    id: wrapper

    anchors.fill: parent
    anchors.margins: 1
    spacing: 1

    RowLayout {
        id: header
        spacing: 1
        Layout.fillWidth: true
        Layout.preferredHeight: root.sectionHeight/3.3
        anchors.margins: 1
        visible: header.children.length > 0
        
        Components.UserAvatar{}
        Components.Battery {
            id: mainBatteryWidget
            Layout.preferredWidth: header.Layout.preferredHeight * 1.7
            Layout.maximumWidth: Layout.preferredWidth
        }
        Components.SystemActions{
            Layout.preferredWidth: header.Layout.preferredHeight
            Layout.maximumWidth: Layout.preferredWidth
        }
    }

    RowLayout {
        id: sectionA

        spacing: 1
        anchors.margins: 1

        Layout.preferredHeight: root.sectionHeight
        Layout.maximumHeight: root.sectionHeight
        
        // Network, Bluetooth and Settings Button
        LayoutComponents.SectionQuickToggleButtons{}

        // Screen controls section
        LayoutComponents.SectionScreenControls{}
    }

    Components.Volume{
        Layout.preferredHeight: root.sectionHeight / (root.volume_widget_title ? 2 : 2.8)
    }
    Components.MediaPlayer{
        Layout.preferredHeight: root.sectionHeight/2
    }
}