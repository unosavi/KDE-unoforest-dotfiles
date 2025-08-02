import QtQuick 2.15
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.15
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.components as PlasmaComponents
import org.kde.plasma.components as PlasmaComponents3
import org.kde.plasma.networkmanagement as PlasmaNM
import "../lib" as Lib
import org.kde.plasma.private.sessions as Sessions
import org.kde.kirigami as Kirigami

PageTemplate {
    id: systemSessionActionsPage

    sectionTitle: i18n("Session Actions")

    Sessions.SessionManagement {
        id: sm
    }

    property var actionsModel: [
        {
            name:  i18n("Suspend"),
            icon: "system-suspend",
            visible: sm.canSuspend,
            action: () => sm.suspend()
        },
        {
            name:  i18n("Restart"),
            icon: "system-reboot",
            visible: sm.canReboot,
            action: () => sm.requestReboot()
        },
        {
            name:  i18n("Shutdown"),
            icon: "system-shutdown",
            visible: sm.canShutdown,
            action: () => sm.requestShutdown()
        },
        {
            name:  i18n("Hibernate"),
            icon: "system-suspend-hibernate",
            visible: sm.canSuspendThenHibernate,
            action: () => sm.suspendThenHibernate()
        },
        {
            name: i18n("Lock Screen"),
            icon: "system-lock-screen",
            visible: sm.canLock,
            action: () => sm.lock()
        },
        {
            name: i18n("Log Out"),
            icon: "system-log-out",
            visible: sm.canLogout,
            action: () => sm.requestLogout()
        },
        {
            name: i18n("Switch User"),
            icon: "system-switch-user",
            visible: sm.canSwitchUser,
            action: () => sm.switchUser()
        }
    ]

    GridLayout {
        id: buttonsColumn
        anchors.fill: parent
        anchors.margins: root.smallSpacing

        columns: 1

        property int columnImplicitWidth: children[0].width + columnSpacing
        property int implicitW: repeater.count * columnImplicitWidth

        Repeater {
            id: repeater
            model: actionsModel
            Lib.CardButton {
                property var item: model.modelData ? model.modelData : model
                visible: item.visible
                Layout.fillWidth: true
                Layout.fillHeight: true
                isLongButton: true
                title: item.name
                Kirigami.Icon {
                    anchors.fill: parent
                    source: item.icon
                    selected: false
                }

                onClicked: item.action()
            }
        }
    }
}
