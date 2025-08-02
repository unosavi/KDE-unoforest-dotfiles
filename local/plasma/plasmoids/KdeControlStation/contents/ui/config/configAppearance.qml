import QtQml 2.15
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Dialogs

import org.kde.kirigami as Kirigami
import org.kde.iconthemes as KIconThemes
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.extras 2.0 as PlasmaExtras
import org.kde.kcmutils as KCM

import org.kde.draganddrop 2.0 as DragDrop
import org.kde.ksvg 1.0 as KSvg


KCM.SimpleKCM {
    id: configAppearance

    property alias cfg_scale: scale.value
    property alias cfg_layout: layout.currentIndex
    property alias cfg_transparency: transparency.checked
    property alias cfg_showKDEConnect: showKDEConnect.checked
    property alias cfg_showNightLight: showNightLight.checked
    property alias cfg_showColorSwitcher: showColorSwitcher.checked
    property alias cfg_showVolume: showVolume.checked
    property alias cfg_showBrightness: showBrightness.checked
    property alias cfg_showMediaPlayer: showMediaPlayer.checked
    property alias cfg_showAvatar: showAvatar.checked
    property alias cfg_showBattery: showBattery.checked
    property alias cfg_showSessionActions: showSessionActions.checked
    property alias cfg_showScreenshot: showScreenshot.checked
    property alias cfg_showCmd1: showCmd1.checked
    property alias cfg_showCmd2: showCmd2.checked
    property alias cfg_showPercentage: showPercentage.checked
    property string cfg_icon: Plasmoid.configuration.icon
    property bool cfg_useCustomButtonImage: Plasmoid.configuration.useCustomButtonImage
    property string cfg_customButtonImage: Plasmoid.configuration.customButtonImage
    property alias cfg_cmdIcon1: cmdIcon1.icon.name
    property alias cfg_cmdRun1: cmdRun1.text
    property alias cfg_cmdTitle1: cmdTitle1.text
    property alias cfg_cmdIcon2: cmdIcon2.icon.name
    property alias cfg_cmdRun2: cmdRun2.text
    property alias cfg_cmdTitle2: cmdTitle2.text

    property alias cfg_transparencyLevel: transparencyLevel.value
    property alias cfg_showBorders: showBorders.checked

    property alias cfg_volume_widget_flat: volume_widget_flat.checked
    property alias cfg_volume_widget_title: volume_widget_title.checked
    property alias cfg_volume_widget_thin: volume_widget_thin.checked

    property alias cfg_brightness_widget_flat: brightness_widget_flat.checked
    property alias cfg_brightness_widget_title: brightness_widget_title.checked
    property alias cfg_brightness_widget_thin: brightness_widget_thin.checked

    property alias cfg_animations: animations.checked

    property alias cfg_useSystemColorsOnToggles: useSystemColorsOnToggles.checked
    property alias cfg_useSystemColorsOnSliders: useSystemColorsOnSliders.checked
    property color cfg_toggleButtonsColor: Plasmoid.configuration.toggleButtonsColor
    property color cfg_slidersColor: Plasmoid.configuration.slidersColor

    property int numChecked: (layout.currentIndex == 1 ? showKDEConnect.checked : showColorSwitcher.checked) + showNightLight.checked + showCmd1.checked + showCmd2.checked + showScreenshot.checked
    property int maxNum: layout.currentIndex == 0 && !showBrightness.checked ? 4 :  (layout.currentIndex == 2 || layout.currentIndex == 3 )? 6 : 2 


    function toggleLayoutDefaults(index) {                    
        showNightLight.checked = true;
        showColorSwitcher.checked = true;
        showBrightness.checked = true;
        showKDEConnect.checked = true;

        showScreenshot.checked = false;
        showCmd1.checked = false;
        showCmd2.checked = false;

        volume_widget_flat.checked = false;
        volume_widget_title.checked = true;
        volume_widget_thin.checked = false;

        brightness_widget_flat.checked = false;
        brightness_widget_title.checked = true;
        brightness_widget_thin.checked = false;

        switch (index) {
            case 0:
                showColorSwitcher.enabled = true;
                showKDEConnect.enabled = false;
                break;
            case 1:
                showColorSwitcher.enabled = false;
                showKDEConnect.enabled = true;
                maxNum = 2;
                break;
            case 2:
                volume_widget_flat.checked = true;
                volume_widget_title.checked = false;
                volume_widget_thin.checked = true;

                brightness_widget_flat.checked = true;
                brightness_widget_title.checked = false;
                brightness_widget_thin.checked = true;
                break;
            case 3:
                showScreenshot.checked = true;
                maxNum = 6;
                break;

        }
    }

    Kirigami.FormLayout {
        Button {
            id: iconButton

            Kirigami.FormData.label: i18n("Icon:")

            implicitWidth: previewFrame.width + Kirigami.Units.smallSpacing * 2
            implicitHeight: previewFrame.height + Kirigami.Units.smallSpacing * 2

            // Just to provide some visual feedback when dragging;
            // cannot have checked without checkable enabled
            checkable: true
            checked: dropArea.containsAcceptableDrag

            onPressed: iconMenu.opened ? iconMenu.close() : iconMenu.open()

            DragDrop.DropArea {
                id: dropArea

                property bool containsAcceptableDrag: false

                anchors.fill: parent

                onDragEnter: {
                    // Cannot use string operations (e.g. indexOf()) on "url" basic type.
                    var urlString = event.mimeData.url.toString();

                    // This list is also hardcoded in KIconDialog.
                    var extensions = [".png", ".xpm", ".svg", ".svgz"];
                    containsAcceptableDrag = urlString.indexOf("file:///") === 0 && extensions.some(function (extension) {
                        return urlString.indexOf(extension) === urlString.length - extension.length; // "endsWith"
                    });

                    if (!containsAcceptableDrag) {
                        event.ignore();
                    }
                }
                onDragLeave: containsAcceptableDrag = false

                onDrop: {
                    if (containsAcceptableDrag) {
                        // Strip file:// prefix, we already verified in onDragEnter that we have only local URLs.
                        iconDialog.setCustomButtonImage(event.mimeData.url.toString().substr("file://".length));
                    }
                    containsAcceptableDrag = false;
                }
            }

            KIconThemes.IconDialog {
                id: iconDialog
                
                // This property is used to change icon of a specific target such as command buttons icons
                property var target: null

                function setCustomButtonImage(image) {
                    if (target) {
                        target.icon.name = image;
                        target = null;
                    } else {
                        configAppearance.cfg_customButtonImage = image || configAppearance.cfg_icon || "start-here-kde-symbolic"
                        configAppearance.cfg_useCustomButtonImage = true;
                    }
                }

                onIconNameChanged: iconName => setCustomButtonImage(iconName);
            }

            KSvg.FrameSvgItem {
                id: previewFrame
                anchors.centerIn: parent
                imagePath: Plasmoid.location === PlasmaCore.Types.Vertical || Plasmoid.location === PlasmaCore.Types.Horizontal
                        ? "widgets/panel-background" : "widgets/background"
                width: Kirigami.Units.iconSizes.medium + fixedMargins.left + fixedMargins.right
                height: Kirigami.Units.iconSizes.medium + fixedMargins.top + fixedMargins.bottom

                Kirigami.Icon {
                    anchors.centerIn: parent
                    width: Kirigami.Units.iconSizes.medium
                    height: width
                    source: configAppearance.cfg_useCustomButtonImage ? configAppearance.cfg_customButtonImage : configAppearance.cfg_icon
                }
            }

            Menu {
                id: iconMenu

                // Appear below the button
                y: +parent.height

                onClosed: iconButton.checked = false;

                MenuItem {
                    text: i18nc("@item:inmenu Open icon chooser dialog", "Choose…")
                    icon.name: "document-open-folder"
                    onClicked: iconDialog.open()
                }
                MenuItem {
                    text: i18nc("@item:inmenu Reset icon to default", "Clear Icon")
                    icon.name: "edit-clear"
                    onClicked: {
                        configAppearance.cfg_icon = "configure"
                        configAppearance.cfg_useCustomButtonImage = false
                    }
                }
            }
        }

        SpinBox {
            id: scale
            Kirigami.FormData.label: i18n("Scale:")
            from: 0; to: 1000
        }
        Item {
            Kirigami.FormData.isSection: true
        }
        ComboBox {
            id: layout
            Kirigami.FormData.label: i18n("Layout:")
            model: [
                i18n("KDE Control Station (Default)"),
                i18n("Control Center"),
                i18n("Flat"),
                i18n("Tahoe")
            ]
            onActivated: toggleLayoutDefaults(index)
        }

        Item {
            Kirigami.FormData.isSection: true
        }

        CheckBox {
            id: showPercentage
            Kirigami.FormData.label: i18n("General:")
            text: i18n("Show volume/brightness percentage")
        }
        CheckBox {
            id: animations
            text: i18n("Enable animations (Experimental)")
        }
        CheckBox {
            id: transparency
            text: i18n("Enable transparency")
        }
        Slider {
            id: transparencyLevel
            visible: transparency.checked
            Kirigami.FormData.label: i18n("Transparency level of widgets (%1%):", 100-value)
            from: 100
            value: 40
            to: 0
            stepSize: 1
            Layout.fillWidth: true
        }

        CheckBox {
            id: showBorders
            text: i18n("Show borders aroud components")
        }

        Kirigami.Separator {
            Kirigami.FormData.isSection: true
            Kirigami.FormData.label: i18n("Toggle buttons and sliders")
        }

        CheckBox {
            id: useSystemColorsOnToggles
            Kirigami.FormData.label: i18n("Highlight color")
            text: i18n('Use System highlight color on toggle buttons')
           // enabled: !checked && numChecked < maxNum || checked
        }

        Button {
            id: toggleButtonColorButton
            visible: !useSystemColorsOnToggles.checked
            width: Kirigami.Units.iconSizes.small
            height: width
            Kirigami.FormData.label: i18n("Toggle buttons color")
            Rectangle {
                anchors.centerIn: parent
                anchors.fill: parent
                radius: 10
                color: cfg_toggleButtonsColor
            }
            onPressed: toggleButtonsColorDialog.visible ? toggleButtonsColorDialog.close() : toggleButtonsColorDialog.open()
            ColorDialog {
                id: toggleButtonsColorDialog
                title: i18n("Please choose a color")
                onAccepted: {
                    cfg_toggleButtonsColor = toggleButtonsColorDialog.selectedColor;
                }
            }
        }

        CheckBox {
            id: useSystemColorsOnSliders
            text: i18n('Use System highlight color on sliders')
           // enabled: !checked && numChecked < maxNum || checked
        }

        Button {
            id: slidersColorButton
            visible: !useSystemColorsOnSliders.checked
            width: Kirigami.Units.iconSizes.small
            height: width
            Kirigami.FormData.label: i18n("Sliders color")
            Rectangle {
                anchors.centerIn: parent
                anchors.fill: parent
                radius: 10
                color: cfg_slidersColor
            }
            onPressed: slidersColorDialog.visible ? slidersColorDialog.close() : slidersColorDialog.open()
            ColorDialog {
                id: slidersColorDialog
                title: i18n("Please choose a color")
                onAccepted: {
                    cfg_slidersColor = slidersColorDialog.selectedColor;
                }
            }
        }

        Item {
            Kirigami.FormData.isSection: true
        }

        CheckBox {
            id: showKDEConnect
            Kirigami.FormData.label: i18n("Show quick toggle buttons:")
            text: i18n('KDE Connect')
           // enabled: !checked && numChecked < maxNum || checked
        }
        CheckBox {
            id: showNightLight
            text: i18n('Night Light')
            enabled: !checked && numChecked < maxNum || checked
        }
        CheckBox {
            id: showColorSwitcher
            text: i18n('Color Scheme Switcher')
            enabled: !checked && numChecked < maxNum || checked
        }
        CheckBox {
            id: showScreenshot
            text: i18n('Screenshot Button')
            enabled: !checked && numChecked < maxNum || checked
        }
        CheckBox {
            id: showCmd1
            text: i18n('Custom Command Block 1')
            enabled: !checked && numChecked < maxNum || checked
        }
        Kirigami.FormLayout {
            visible: showCmd1.checked
            TextField {
                id: cmdTitle1
                Kirigami.FormData.label: i18n("Name:")
            }
            TextField {
                id: cmdRun1
                Kirigami.FormData.label: i18n("Command:")
            }
            Button {
                id: cmdIcon1
                Kirigami.FormData.label: i18n("Icon:")
                icon.width: Kirigami.Units.iconSizes.medium
                icon.height: icon.width
                onClicked: {
                    iconDialog.open()
                    iconDialog.target= cmdIcon1
                }
            }
        }
        CheckBox {
            id: showCmd2
            text: i18n('Custom Command Block 2')
            enabled: !checked && numChecked < maxNum || checked
        }
        Kirigami.FormLayout {
            visible: showCmd2.checked
            TextField {
                id: cmdTitle2
                Kirigami.FormData.label: i18n("Name:")
            }
            TextField {
                id: cmdRun2
                Kirigami.FormData.label: i18n("Command:")
            }
            Button {
                id: cmdIcon2
                Kirigami.FormData.label: i18n("Icon:")
                icon.width: Kirigami.Units.iconSizes.medium
                icon.height: icon.width
                onClicked: {
                    iconDialog.open()
                    iconDialog.target= cmdIcon2
                }
            }
        }
        Label {
            text: i18n(`You can enable only ${maxNum} toggle buttons at a time.`)
            font: Kirigami.Theme.smallestFont
            color: Kirigami.Theme.neutralTextColor
            Layout.fillWidth: true
            wrapMode: Text.Wrap
        }

        Item {
            Kirigami.FormData.isSection: true
        }

        CheckBox {
            id: showVolume
            Kirigami.FormData.label: i18n("Show other components:")
            text: i18n('Volume Control')
        }
        Kirigami.FormLayout {
            visible: showVolume.checked
            RowLayout {
                CheckBox {
                    id: volume_widget_flat
                    text: i18n('Flat component')
                }
                CheckBox {
                    id: volume_widget_title
                    text: i18n('Show volume title')
                }
                CheckBox {
                    id: volume_widget_thin
                    text: i18n('Thin slider')
                }
            }
        }
        CheckBox {
            id: showBrightness
            text: i18n('Brightness Control')
        }
        Kirigami.FormLayout {
            visible: showBrightness.checked
            RowLayout {
                CheckBox {
                    id: brightness_widget_flat
                    text: i18n('Flat component')
                }
                CheckBox {
                    id: brightness_widget_title
                    text: i18n('Show brightness title')
                }
                CheckBox {
                    id: brightness_widget_thin
                    text: i18n('Thin slider')
                }
            }
        }
        CheckBox {
            id: showMediaPlayer
            text: i18n('Media Player')
        }
         CheckBox {
            id: showAvatar
            text: i18n('User Avatar')
        }
        CheckBox {
            id: showBattery
            text: i18n('Battery')
        }
        CheckBox {
            id: showSessionActions
            text: i18n('Session Actions')
        }
    }

    Item {
        Layout.fillHeight: true
    }
}
