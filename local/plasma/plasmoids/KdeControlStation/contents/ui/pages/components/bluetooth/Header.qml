import QtQuick 2.15
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.15
import org.kde.kcmutils as KCM// KCMLauncher
import org.kde.plasma.components as PlasmaComponents3
import org.kde.plasma.core as PlasmaCore

RowLayout {
    id: header
    anchors.fill: parent
    PlasmaComponents3.Switch {
        id: onSwitch
        text: bluetoothPage.toggleBluetoothAction.text
        icon.name: bluetoothPage.toggleBluetoothAction.icon.name
        checked: bluetoothPage.toggleBluetoothAction.checked
        enabled: bluetoothPage.toggleBluetoothAction.visible
        focus: true
        onToggled: bluetoothPage.toggleBluetoothAction.trigger()
        Layout.fillWidth: true
    }

    Item {
        Layout.fillWidth: true
    }

    PlasmaComponents3.ToolButton {
        id: addDeviceButton

        readonly property PlasmaCore.Action qAction: bluetoothPage.addDeviceAction

        visible: true
        enabled: qAction.visible

        icon.name: "list-add-symbolic"

        onClicked: qAction.trigger()

        PlasmaComponents3.ToolTip {
            text: addDeviceButton.qAction.text
        }
        Accessible.name: qAction.text
    }

    PlasmaComponents3.ToolButton {
        id: openSettingsButton

        icon.name: "configure-symbolic"
        onClicked: KCM.KCMLauncher.openSystemSettings("kcm_bluetooth")

        Accessible.name: i18n("Configure Bluetooth")
        PlasmaComponents3.ToolTip {
            text: i18n("Configure Bluetooth")
        }
    }
}
