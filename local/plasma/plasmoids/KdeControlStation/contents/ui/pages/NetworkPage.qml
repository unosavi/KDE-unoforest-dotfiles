import QtQuick 2.2
import QtQuick.Controls 2.15 as QQC2
import org.kde.plasma.plasmoid 2.0
import org.kde.kirigami 2.20 as Kirigami
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.networkmanagement as PlasmaNM
import org.kde.plasma.components 3.0 as PlasmaComponents3
import org.kde.networkmanager as NMQt
import QtQuick.Layouts 1.1
import org.kde.kcmutils as KCMUtils
import org.kde.config as KConfig
import "../lib" as Lib
import "components/network" as NetworkComponents
import "../components" as Components

PageTemplate {
    id: networkPage

    sectionTitle: i18n("Networks")

    readonly property string kcm: "kcm_networkmanagement"
    readonly property bool kcmAuthorized: KConfig.KAuthorized.authorizeControlModule("kcm_networkmanagement")

    property alias handler: network.handler
    property alias nmStatus: network.networkStatus
    property alias availableDevices: network.availableDevices
    property alias appletProxyModel: appletProxyModel

    Components.Network {
        id: network
    }

    Component {
        id: networkModelComponent
        PlasmaNM.NetworkModel {}
    }

    property PlasmaNM.NetworkModel connectionModel: null

    PlasmaNM.AppletProxyModel {
        id: appletProxyModel

        sourceModel: networkPage.connectionModel
    }

   RowLayout {
        id: header
        anchors.left: parent.left
        anchors.right: parent.right

        NetworkComponents.Toolbar {
            id: toolbar
            Layout.fillWidth: true
            hasConnections: connectionListPage.count > 0
            visible: stack.depth === 1
        }

        PlasmaComponents3.Button {
            Layout.fillWidth: true
            icon.name: mirrored ? "go-next" : "go-previous"
            text: i18nc("@action:button", "Return to Network Connections")
            visible: stack.depth > 1
            onClicked: {
                stack.pop()
            }
        }

        Loader {
            sourceComponent: stack.currentItem?.headerItems
            visible: !!item
        }
    }

    Connections {
        target: networkPage.handler
        function onWifiCodeReceived(data, ssid) {
            if (data.length === 0) {
                console.error("Cannot create QR code component: Unsupported connection");
                return;
            }

            const showQRComponent = Qt.createComponent("components/network/ShareNetworkQrCodePage.qml");
            if (showQRComponent.status === Component.Error) {
                console.warn("Cannot create QR code component:", showQRComponent.errorString());
                return;
            }

            stack.push(showQRComponent, {
                content: data,
                ssid
            });
        }
    }

    QQC2.StackView {
        id: stack
        anchors.top: header.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        initialItem: NetworkComponents.ConnectionListPage {
            id: connectionListPage
            model: appletProxyModel
            nmStatus: networkPage.nmStatus
        }
    }

    Component.onCompleted: {
        networkPage.connectionModel = networkModelComponent.createObject(networkPage);
    }
}
