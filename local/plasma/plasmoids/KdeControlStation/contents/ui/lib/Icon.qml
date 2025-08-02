import QtQuick 2.15
import QtQuick.Layouts 1.15
//import QtGraphicalEffects 1.15
import org.kde.plasma.core as PlasmaCore
import org.kde.kirigami as Kirigami
import Qt5Compat.GraphicalEffects


Item
{
    property color sourceColor
    property alias source: icon.source
    property alias selected: icon.selected
    property bool fullSizeIcon : false
    property bool customIcon: false

    property color highlightColor: root.useSystemColorsOnToggles ? root.themeHighlightColor : root.toggleButtonsColor

    Rectangle {
        id: rect
        radius: width/2
        color: icon.selected ? highlightColor : sourceColor.valid ? sourceColor : root.disabledBgColor
        anchors.fill: parent
        

        Kirigami.Icon {
            id: icon
            visible: true
            anchors.fill: parent
            anchors.margins: fullSizeIcon ? root.largeSpacing : root.smallSpacing
            anchors.centerIn: parent
            selected: false
            isMask: customIcon
            color: selected ? Kirigami.Theme.highlightedTextColor : Kirigami.Theme.textColor
        }
    }
}
