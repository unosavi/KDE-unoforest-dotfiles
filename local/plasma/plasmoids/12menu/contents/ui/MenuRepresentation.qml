/***************************************************************************
 *   Copyright (C) 2014 by Weng Xuetian <wengxt@gmail.com>
 *   Copyright (C) 2013-2017 by Eike Hein <hein@kde.org>                   *
 *   Modified to add terminal execution on Enter                            *
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 2 of the License, or     *
 *   (at your option) any later version.                                   *
 *                                                                         *
 *   This program is distributed in the hope that it will be useful,       *
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of        *
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         *
 *   GNU General Public License for more details.                          *
 *                                                                         *
 *   You should have received a copy of the GNU General Public License     *
 *   along with this program; if not, write to the                         *
 *   Free Software Foundation, Inc.,                                       *
 *   51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA .        *
 ***************************************************************************/
import QtQuick 2.4
import QtQuick.Layouts 1.1
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 3.0 as PlasmaComponents3
import org.kde.plasma.extras 2.0 as PlasmaExtras
import org.kde.plasma.private.kicker 0.1 as Kicker
import org.kde.coreaddons 1.0 as KCoreAddons // kuser
import org.kde.plasma.private.shell 2.0
import org.kde.kwindowsystem 1.0
import org.kde.kquickcontrolsaddons 2.0
import org.kde.plasma.private.quicklaunch 1.0
import QtQuick.Controls 2.12
import org.kde.kirigami as Kirigami
import org.kde.ksvg 1.0 as KSvg
import org.kde.plasma.plasma5support 2.0 as P5Support
import org.kde.plasma.plasmoid 2.0

Item {
    id: main
    property int sizeImage: Kirigami.Units.iconSizes.large * 2.5
    onVisibleChanged: {
        root.visible = !root.visible
    }

    PlasmaExtras.Menu {
        id: contextMenu
        PlasmaExtras.MenuItem {
            action: Plasmoid.internalAction("configure")
        }
    }

    PlasmaCore.Dialog {
        id: root
        objectName: "popupWindow"
        flags: Qt.Dialog | Qt.FramelessWindowHint
        location:{
            if (Plasmoid.configuration.displayPosition === 1)
                return PlasmaCore.Types.Floating
                else if (Plasmoid.configuration.displayPosition === 2)
                    return PlasmaCore.Types.BottomEdge
                    else
                        return Plasmoid.location
        }
        hideOnWindowDeactivate: true
        property int iconSize:{ switch(Plasmoid.configuration.appsIconSize){
            case 0: return Kirigami.Units.iconSizes.smallMedium;
            case 1: return Kirigami.Units.iconSizes.medium;
            case 2: return Kirigami.Units.iconSizes.large;
            case 3: return Kirigami.Units.iconSizes.huge;
            default: return 64
        }
        }
        property int cellSizeHeight: iconSize
        + Kirigami.Units.gridUnit * 2
        + (2 * Math.max(highlightItemSvg.margins.top + highlightItemSvg.margins.bottom,
                        highlightItemSvg.margins.left + highlightItemSvg.margins.right))
        property int cellSizeWidth: cellSizeHeight + Kirigami.Units.gridUnit
        property bool searching: (searchField.text != "")
        property bool showFavorites
        onVisibleChanged: {
            if (visible) {
                root.showFavorites = Plasmoid.configuration.showFavoritesFirst
                var pos = popupPosition(width, height);
                x = pos.x;
                y = pos.y;
                reset();
            }else{
                //rootItem.opacity = 0
            }
        }
        onHeightChanged: {
            var pos = popupPosition(width, height);
            x = pos.x;
            y = pos.y;
        }
        onWidthChanged: {
            var pos = popupPosition(width, height);
            x = pos.x;
            y = pos.y;
        }
        function toggle(){
            main.visible =  !main.visible
        }
        function reset() {
            searchField.text = "";
            if(showFavorites)
                globalFavoritesGrid.tryActivate(0,0)
                else
                    mainColumn.visibleGrid.tryActivate(0,0)
        }
        function popupPosition(width, height) {
            var screenAvail = kicker.availableScreenRect;
            var screenGeom = kicker.screenGeometry;
            var screen = Qt.rect(screenAvail.x + screenGeom.x,
                                 screenAvail.y + screenGeom.y,
                                 screenAvail.width,
                                 screenAvail.height);
            var offset = Kirigami.Units.smallSpacing;
            // Fall back to bottom-left of screen area when the applet is on the desktop or floating.
            var x = offset;
            var y = screen.height - height - offset;
            var appletTopLeft;
            var horizMidPoint;
            var vertMidPoint;
            if (Plasmoid.configuration.displayPosition === 1) {
                horizMidPoint = screen.x + (screen.width / 2);
                vertMidPoint = screen.y + (screen.height / 2);
                x = horizMidPoint - width / 2;
                y = vertMidPoint - height / 2;
            } else if (Plasmoid.configuration.displayPosition === 2) {
                horizMidPoint = screen.x + (screen.width / 2);
                vertMidPoint = screen.y + (screen.height / 2);
                x = horizMidPoint - width / 2;
                y = screen.y + screen.height - height - offset - panelSvg.margins.top;
            } else if (Plasmoid.location === PlasmaCore.Types.BottomEdge) {
                horizMidPoint = screen.x + (screen.width / 2);
                appletTopLeft = parent.mapToGlobal(0, 0);
                x = (appletTopLeft.x < horizMidPoint) ? screen.x + offset : (screen.x + screen.width) - width - offset;
                y = screen.y + screen.height - height - offset - panelSvg.margins.top;
            } else if (Plasmoid.location === PlasmaCore.Types.TopEdge) {
                horizMidPoint = screen.x + (screen.width / 2);
                var appletBottomLeft = parent.mapToGlobal(0, parent.height);
                x = (appletBottomLeft.x < horizMidPoint) ? screen.x + offset : (screen.x + screen.width) - width - offset;
                y = screen.y + panelSvg.margins.bottom + offset;
            } else if (Plasmoid.location === PlasmaCore.Types.LeftEdge) {
                vertMidPoint = screen.y + (screen.height / 2);
                appletTopLeft = parent.mapToGlobal(0, 0);
                x = appletTopLeft.x*2 + parent.width + panelSvg.margins.right + offset;
                y = screen.y + (appletTopLeft.y < vertMidPoint) ? screen.y + offset : (screen.y + screen.height) - height - offset;
            } else if (Plasmoid.location === PlasmaCore.Types.RightEdge) {
                vertMidPoint = screen.y + (screen.height / 2);
                appletTopLeft = parent.mapToGlobal(0, 0);
                x = appletTopLeft.x - panelSvg.margins.left - offset - width;
                y = screen.y + (appletTopLeft.y < vertMidPoint) ? screen.y + offset : (screen.y + screen.height) - height - offset;
            }
            return Qt.point(x, y);
        }

        FocusScope {
            id: rootItem
            Layout.minimumWidth:  (root.cellSizeWidth *  Plasmoid.configuration.numberColumns)+ Kirigami.Units.gridUnit*1.5
            Layout.maximumWidth:  (root.cellSizeWidth *  Plasmoid.configuration.numberColumns)+ Kirigami.Units.gridUnit*1.5
            Layout.minimumHeight: (root.cellSizeHeight *  Plasmoid.configuration.numberRows) + searchField.implicitHeight + (Plasmoid.configuration.showInfoUser ? main.sizeImage*0.5 : Kirigami.Units.gridUnit * 1.5 ) +  Kirigami.Units.gridUnit * 5
            Layout.maximumHeight: (root.cellSizeHeight *  Plasmoid.configuration.numberRows) + searchField.implicitHeight + (Plasmoid.configuration.showInfoUser ? main.sizeImage*0.5 : Kirigami.Units.gridUnit * 1.5 ) +  Kirigami.Units.gridUnit * 5
            focus: true

            KCoreAddons.KUser {   id: kuser  }
            Logic { id: logic }

            OpacityAnimator { id: animation1; target: rootItem; from: 0; to: 1; easing.type: Easing.InOutQuad;  }

            P5Support.DataSource {
                id: pmEngine
                engine: "powermanagement"
                connectedSources: ["PowerDevil", "Sleep States"]
            }

            P5Support.DataSource {
                id: executable
                engine: "executable"
                connectedSources: []
                onNewData: {
                    var exitCode = data["exit code"]
                    var exitStatus = data["exit status"]
                    var stdout = data["stdout"]
                    var stderr = data["stderr"]
                    exited(sourceName, exitCode, exitStatus, stdout, stderr)
                    disconnectSource(sourceName)
                }
                function exec(cmd) {
                    if (cmd) {
                        connectSource(cmd)
                    }
                }
                signal exited(string cmd, int exitCode, int exitStatus, string stdout, string stderr)
            }

            PlasmaExtras.Highlight  {
                id: delegateHighlight
                visible: false
                z: -1 // otherwise it shows ontop of the icon/label and tints them slightly
            }

            Kirigami.Heading {
                id: dummyHeading
                visible: false
                width: 0
                level: 5
            }

            TextMetrics {
                id: headingMetrics
                font: dummyHeading.font
            }

            RowLayout{
                id: rowTop
                anchors {
                    left: parent.left
                    right: parent.right
                    top: parent.top
                    margins: Kirigami.Units.smallSpacing
                    topMargin: Kirigami.Units.largeSpacing
                }
                Item {
                    Layout.fillWidth: true
                }
                PlasmaComponents3.ToolButton {
                    icon.name:  "user-home"
                    onClicked: logic.openUrl("file:///usr/share/applications/org.kde.dolphin.desktop")
                    ToolTip.delay: 200
                    ToolTip.timeout: 1000
                    ToolTip.visible: hovered
                    ToolTip.text: i18n("User Home")
                }
                PlasmaComponents3.ToolButton {
                    icon.name: "system-lock-screen"
                    onClicked: {
                        const home = String(Qt.resolvedUrl(".")).match(/file:\/\/(.*?)\/.local/)[1];
                        logic.openUrl("file://" + home + "/.local/share/plasma/plasmoids/12menu/contents/ui/logout.desktop");
                    }
                    ToolTip.delay: 1000
                    ToolTip.timeout: 1000
                    ToolTip.visible: hovered
                    ToolTip.text: i18n("Lock Screen")
                    visible: pmEngine.data["Sleep States"]["LockScreen"]
                }
                PlasmaComponents3.ToolButton {
                    icon.name: "system-shutdown"
                    onClicked: {
                        const home = String(Qt.resolvedUrl(".")).match(/file:\/\/(.*?)\/.local/)[1];
                        logic.openUrl("file://" + home + "/.local/share/plasma/plasmoids/12menu/contents/ui/poweroptions.desktop");
                    }
                    ToolTip.delay: 1000
                    ToolTip.timeout: 1000
                    ToolTip.visible: hovered
                    ToolTip.text: i18n("Leave ...")
                }
                PlasmaComponents3.ToolButton {
                    icon.name:  "configure"
                    onClicked: logic.openUrl("file:///usr/share/applications/systemsettings.desktop")
                    ToolTip.delay: 200
                    ToolTip.timeout: 1000
                    ToolTip.visible: hovered
                    ToolTip.text: i18n("System Preferences")
                }
            }

            Kirigami.Heading {
                anchors {
                    top: rowTop.bottom
                    topMargin: Kirigami.Units.gridUnit
                    horizontalCenter: parent.horizontalCenter
                }
                level: 1
                color: Kirigami.Theme.textColor
                text: i18n("Hi, ")+ kuser.fullName
                font.weight: Font.Bold
                visible: Plasmoid.configuration.showInfoUser
            }

            RowLayout {
                id: rowSearchField
                anchors{
                    top: Plasmoid.configuration.showInfoUser ? parent.top : rowTop.bottom
                    topMargin: Plasmoid.configuration.showInfoUser ? Kirigami.Units.gridUnit*3  + sizeImage/2 : Kirigami.Units.gridUnit/2
                    left: parent.left
                    right: parent.right
                    margins: Kirigami.Units.smallSpacing
                }
                Item{
                    Layout.fillWidth: true
                }
                PlasmaComponents3.TextField {
                    id: searchField
                    Layout.fillWidth: true
                    placeholderText: i18n("Type here to search ...")
                    topPadding: 10
                    bottomPadding: 10
                    leftPadding: Kirigami.Units.gridUnit + Kirigami.Units.iconSizes.small
                    text: ""
                    font.pointSize: Kirigami.Theme.defaultFont.pointSize + 2
                    onTextChanged: {
                        runnerModel.query = text;
                    }
                    Keys.onPressed: (event)=> {
                        if (event.key === Qt.Key_Escape) {
                            event.accepted = true;
                            if(root.searching){
                                searchField.clear()
                            } else {
                                root.toggle()
                            }
                        }
                        if (event.key === Qt.Key_Down || event.key === Qt.Key_Tab || event.key === Qt.Key_Backtab) {
                            event.accepted = true;
                            if(root.searching){
                                runnerGrid.tryActivate(0,0)
                            }
                            else{
                                if(root.showFavorites)
                                    globalFavoritesGrid.tryActivate(0,0)
                                    else
                                        mainColumn.visibleGrid.tryActivate(0,0)
                            }
                        }
                        // NEW: Only this block was added for terminal execution
                        if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                            event.accepted = true;
                            if (searchField.text.trim() !== "") {
                                executable.exec("konsole --hold -e /bin/bash -c '" +
                                searchField.text.replace(/'/g, "'\\''") + "'");
                                root.visible = false;
                            }
                        }
                    }
                    function backspace() {
                        if (!root.visible) {
                            return;
                        }
                        focus = true;
                        text = text.slice(0, -1);
                    }
                    function appendText(newText) {
                        if (!root.visible) {
                            return;
                        }
                        focus = true;
                        text = text + newText;
                    }
                    Kirigami.Icon {
                        source: 'search'
                        anchors {
                            left: searchField.left
                            verticalCenter: searchField.verticalCenter
                            leftMargin: Kirigami.Units.smallSpacing * 2
                        }
                        height: Kirigami.Units.iconSizes.small
                        width: height
                    }
                }
                Item{
                    Layout.fillWidth: true
                }
                PlasmaComponents3.ToolButton {
                    id: btnFavorites
                    icon.name: 'favorites'
                    flat: !root.showFavorites
                    onClicked: {
                        searchField.text = ""
                        root.showFavorites = true
                    }
                    ToolTip.delay: 200
                    ToolTip.timeout: 1000
                    ToolTip.visible: hovered
                    ToolTip.text: i18n("Favorites")
                }
                PlasmaComponents3.ToolButton {
                    icon.name: "view-list-icons"
                    flat: root.showFavorites
                    onClicked: {
                        searchField.text = ""
                        root.showFavorites = false
                    }
                    ToolTip.delay: 200
                    ToolTip.timeout: 1000
                    ToolTip.visible: hovered
                    ToolTip.text: i18n("All apps")
                }
            }

            ItemGridView {
                id: globalFavoritesGrid
                visible: (Plasmoid.configuration.showFavoritesFirst || root.showFavorites ) && !root.searching && root.showFavorites
                anchors {
                    top: rowSearchField.bottom
                    topMargin: Kirigami.Units.gridUnit
                }
                dragEnabled: true
                dropEnabled: true
                width: rootItem.width
                height: root.cellSizeHeight * Plasmoid.configuration.numberRows
                focus: true
                cellWidth:   root.cellSizeWidth
                cellHeight:  root.cellSizeHeight
                iconSize:    root.iconSize
                onKeyNavUp: searchField.focus = true
                Keys.onPressed:(event)=> {
                    if(event.modifiers & Qt.ControlModifier ||event.modifiers & Qt.ShiftModifier){
                        searchField.focus = true;
                        return
                    }
                    if (event.key === Qt.Key_Tab) {
                        event.accepted = true;
                        searchField.focus = true
                    }
                }
            }

            Item{
                id: mainGrids
                visible: (!Plasmoid.configuration.showFavoritesFirst && !root.showFavorites ) || root.searching || !root.showFavorites
                anchors {
                    top: rowSearchField.bottom
                    topMargin: Kirigami.Units.gridUnit
                }
                width: rootItem.width
                height: root.cellSizeHeight *  Plasmoid.configuration.numberRows
                Item {
                    id: mainColumn
                    width: rootItem.width
                    height: root.cellSizeHeight * Plasmoid.configuration.numberRows
                    property Item visibleGrid: allAppsGrid
                    function tryActivate(row, col) {
                        if (visibleGrid) {
                            visibleGrid.tryActivate(row, col);
                        }
                    }
                    ItemGridView {
                        id: allAppsGrid
                        width: rootItem.width
                        height: root.cellSizeHeight * Plasmoid.configuration.numberRows
                        cellWidth:   root.cellSizeWidth
                        cellHeight:  root.cellSizeHeight
                        iconSize:    root.iconSize
                        enabled: (opacity == 1) ? 1 : 0
                        z:  enabled ? 5 : -1
                        dropEnabled: false
                        dragEnabled: false
                        opacity: root.searching ? 0 : 1
                        onOpacityChanged: {
                            if (opacity == 1) {
                                mainColumn.visibleGrid = allAppsGrid;
                            }
                        }
                        onKeyNavUp: searchField.focus = true
                    }
                    ItemMultiGridView {
                        id: runnerGrid
                        width: rootItem.width
                        height: root.cellSizeHeight * Plasmoid.configuration.numberRows
                        cellWidth:   root.cellSizeWidth
                        cellHeight:  root.cellSizeHeight
                        enabled: (opacity == 1.0) ? 1 : 0
                        z:  enabled ? 5 : -1
                        model: runnerModel
                        grabFocus: true
                        opacity: root.searching ? 1.0 : 0.0
                        onOpacityChanged: {
                            if (opacity == 1.0) {
                                mainColumn.visibleGrid = runnerGrid;
                            }
                        }
                        onKeyNavUp: searchField.focus = true
                    }
                    Keys.onPressed: (event)=> {
                        if(event.modifiers & Qt.ControlModifier ||event.modifiers & Qt.ShiftModifier){
                            searchField.focus = true;
                            return
                        }
                        if (event.key === Qt.Key_Tab) {
                            event.accepted = true;
                            searchField.focus = true
                        } else if (event.key === Qt.Key_Backspace) {
                            event.accepted = true;
                            if(root.searching)
                                searchField.backspace();
                            else
                                searchField.focus = true
                        } else if (event.key === Qt.Key_Escape) {
                            event.accepted = true;
                            if(root.searching){
                                searchField.clear()
                            } else {
                                root.toggle()
                            }
                        } else if (event.text !== "") {
                            event.accepted = true;
                            searchField.appendText(event.text);
                        }
                    }
                }
            }
            Keys.onPressed: (event)=> {
                if(event.modifiers & Qt.ControlModifier ||event.modifiers & Qt.ShiftModifier){
                    searchField.focus = true;
                    return
                }
                if (event.key === Qt.Key_Escape) {
                    event.accepted = true;
                    if (root.searching) {
                        reset();
                    } else {
                        root.visible = false;
                    }
                    return;
                }
                if (searchField.focus) {
                    return;
                }
                if (event.key === Qt.Key_Backspace) {
                    event.accepted = true;
                    searchField.backspace();
                }  else if (event.text !== "") {
                    event.accepted = true;
                    searchField.appendText(event.text);
                }
            }
        }
        function setModels(){
            globalFavoritesGrid.model = globalFavorites
            allAppsGrid.model = rootModel.modelForRow(0);
        }
        Component.onCompleted: {
            rootModel.refreshed.connect(setModels)
            reset();
            rootModel.refresh();
        }
    }

    PlasmaCore.Dialog {
        id: dialog
        width:  main.sizeImage
        height: width
        visible: root.visible
        y: root.y - sizeImage/2
        x: root.x + root.width/2 - sizeImage/2
        objectName: "popupWindowIcon"
        type: "Notification"
        location: PlasmaCore.Types.Floating
        hideOnWindowDeactivate: false
        backgroundHints: PlasmaCore.Dialog.NoBackground
        mainItem:  Rectangle{
            width: main.sizeImage
            height: width
            color: 'transparent'
            Image {
                id: iconUser
                source: kuser.faceIconUrl
                cache: false
                visible: source !== "" && Plasmoid.configuration.showInfoUser
                sourceSize.width: main.sizeImage
                sourceSize.height: main.sizeImage
                fillMode: Image.PreserveAspectFit
                layer.enabled:true
                state: "hide"
                states: [
                    State {
                        name: "show"
                        when: dialog.visible
                        PropertyChanges { target: iconUser; opacity: 1; }
                    },
                    State {
                        name: "hide"
                        when: !dialog.visible
                        PropertyChanges { target: iconUser; opacity: 0; }
                    }
                ]
                transitions: Transition {
                    PropertyAnimation { properties: "opacity"; easing.type: Easing.InOutQuad; }
                }
                MouseArea {
                    anchors.fill: parent
                    acceptedButtons: Qt.LeftButton
                    onClicked: KCM.KCMLauncher.openSystemSettings("kcm_users")
                }
            }
        }
    }
}
