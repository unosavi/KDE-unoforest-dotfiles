import QtQml 2.15
import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.0
import "../../../components" as Components
import "../../../lib" as Lib

Lib.Card {
    id: sectionQuickToggleButtons
    Layout.fillWidth: true
    Layout.fillHeight: true
    
    // All Buttons
    ColumnLayout {
        id: buttonsColumn
        anchors.fill: parent
        anchors.margins: 1
        spacing: 1

        Components.NetworkBtn{
            flat: true
            noMargins: true
            isLongButton: true
        }
        Components.BluetoothBtn{
            flat: true
            noMargins: true
            isLongButton: true
            heading: i18n("Bluetooth")
        }
        Components.ColorSchemeSwitcher{
            flat: true
            noMargins: true
            isLongButton: true
            heading: i18n("Appearance")
        }
    }
}