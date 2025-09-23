import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import Quickshell.Widgets
import Qt5Compat.GraphicalEffects
import qs
import qs.common
import qs.common.utils
import qs.common.widgets
import qs.services

Item {
    id: root

    property bool vertical: false
    property bool borderless: Config.options.bar.borderless
    readonly property HyprlandMonitor monitor: Hyprland.monitorFor(root.QsWindow.window?.screen)
    readonly property Toplevel activeWindow: ToplevelManager.activeToplevel

    readonly property int workspaceGroup: Math.floor((monitor?.activeWorkspace?.id - 1) / Config.options.bar.workspaces.shown)
    property list<bool> workspaceOccupied: []
    property int widgetPadding: 4
    property int workspaceButtonWidth: Appearance.sizes.baseBarHeight - (2 * Appearance.sizes.baseBarYPadding)
    property real activeWorkspaceMargin: 2
    property real workspaceIconSize: workspaceButtonWidth * 0.53
    property real workspaceIconSizeShrinked: workspaceButtonWidth * 0.55
    property real workspaceIconOpacityShrinked: 1
    property real workspaceIconMarginShrinked: -4
    property int workspaceIndexInGroup: (monitor?.activeWorkspace?.id - 1) % Config.options.bar.workspaces.shown

    property bool showNumbers: false

    Timer {
        id: showNumbersTimer
        interval: (Config?.options.bar.autoHide.showWhenPressingSuper.delay ?? 100)
        repeat: false
        onTriggered: {
            root.showNumbers = true;
        }
    }

    Connections {
        target: GlobalStates
        function onSuperDownChanged() {
            if (!Config?.options.bar.autoHide.showWhenPressingSuper.enable)
                return;
            if (GlobalStates.superDown)
                showNumbersTimer.restart();
            else {
                showNumbersTimer.stop();
                root.showNumbers = false;
            }
        }
        function onSuperReleaseMightTriggerChanged() {
            showNumbersTimer.stop();
        }
    }

    function updateWorkspaceOccupied() {
        workspaceOccupied = Array.from({
            length: Config.options.bar.workspaces.shown
        }, (_, i) => {
            return Hyprland.workspaces.values.some(ws => ws.id === workspaceGroup * Config.options.bar.workspaces.shown + i + 1);
        });
    }

    Component.onCompleted: updateWorkspaceOccupied()
    Connections {
        target: Hyprland.workspaces
        function onValuesChanged() {
            updateWorkspaceOccupied();
        }
    }
    Connections {
        target: Hyprland
        function onFocusedWorkspaceChanged() {
            updateWorkspaceOccupied();
        }
    }
    onWorkspaceGroupChanged: {
        updateWorkspaceOccupied();
    }

    // Workspaces - background
    GridLayout {
        id: backgroundLayout
        z: 1
        anchors.fill: parent
        implicitHeight: root.vertical ? root.workspaceButtonWidth : Appearance.sizes.barHeight
        implicitWidth: root.vertical ? Appearance.sizes.verticalBarWidth : root.workspaceButtonWidth

        rowSpacing: 0
        columnSpacing: 0
        columns: root.vertical ? 1 : -1

        Repeater {
            model: Config.options.bar.workspaces.shown
            Rectangle {
                required property int index
                required property int modelData
                readonly property var monitorWorkspaces: Config.options.bar.workspaces.workspacesPerMonitor[monitor?.name]
                property real position: modelData * workspaceButtonWidth + root.activeWorkspaceMargin
                property int leftRadius: monitorWorkspaces && monitorWorkspaces[0] === index + 1 ? width / 2 : 0
                property int rightRadius: monitorWorkspaces && monitorWorkspaces[monitorWorkspaces.length - 1] === index + 1 ? width / 2 : 0

                z: 1
                Layout.alignment: root.vertical ? Qt.AlignHCenter : Qt.AlignVCenter
                implicitWidth: workspaceButtonWidth
                implicitHeight: workspaceButtonWidth
                color: ColorUtils.transparentize(Appearance.colors.workspacesBackground, 0.3)
                opacity: monitorWorkspaces && monitorWorkspaces.includes(index + 1) ? 1 : 0

                topLeftRadius: leftRadius
                bottomLeftRadius: leftRadius
                topRightRadius: rightRadius
                bottomRightRadius: rightRadius
            }
        }
    }

    // Active workspace
    Rectangle {
        property real idx1: workspaceIndexInGroup
        property real idx2: workspaceIndexInGroup
        property real indicatorPosition: Math.min(idx1, idx2) * workspaceButtonWidth + root.activeWorkspaceMargin
        property real indicatorLength: Math.abs(idx1 - idx2) * workspaceButtonWidth + workspaceButtonWidth - root.activeWorkspaceMargin * 2
        property real indicatorThickness: workspaceButtonWidth - root.activeWorkspaceMargin * 2

        z: 2
        radius: Appearance.rounding.full
        color: Appearance.colors.activeWorkspaceBackground
        anchors {
            verticalCenter: vertical ? undefined : parent.verticalCenter
            horizontalCenter: vertical ? parent.horizontalCenter : undefined
        }
        x: root.vertical ? null : indicatorPosition
        y: root.vertical ? indicatorPosition : null
        implicitWidth: root.vertical ? indicatorThickness : indicatorLength
        implicitHeight: root.vertical ? indicatorLength : indicatorThickness

        Behavior on idx1 {
            NumberAnimation {
                duration: 100
                easing.type: Easing.OutSine
            }
        }

        Behavior on idx2 {
            NumberAnimation {
                duration: 300
                easing.type: Easing.OutSine
            }
        }
    }

    // Workspace numbers
    GridLayout {
        id: rowLayoutNumbers
        z: 3
        columns: vertical ? 1 : -1
        columnSpacing: 0
        rowSpacing: 0

        anchors.fill: parent
        implicitHeight: vertical ? Appearance.sizes.verticalBarWidth : Appearance.sizes.barHeight
        implicitWidth: vertical ? Appearance.sizes.verticalBarWidth : Appearance.sizes.verticalBarWidth

        Repeater {
            model: Config.options.bar.workspaces.shown
            
            // Workspace button
            Button {
                id: button
                property int workspaceValue: workspaceGroup * Config.options.bar.workspaces.shown + index + 1
                Layout.fillHeight: !root.vertical
                Layout.fillWidth: root.vertical
                onPressed: Hyprland.dispatch(`workspace ${workspaceValue}`)
                width: vertical ? undefined : workspaceButtonWidth
                height: vertical ? workspaceButtonWidth : undefined

                background: Item {
                    id: workspaceButtonBackground
                    implicitWidth: workspaceButtonWidth
                    implicitHeight: workspaceButtonWidth
                    property var biggestWindow: HyprlandData.biggestWindowFromWorkspace(button.workspaceValue)
                    property var mainAppIconSource: Quickshell.iconPath(AppSearch.guessIcon(biggestWindow?.class), "image-missing")

                    // Workspace number
                    StyledText {
                        opacity: root.showNumbers || ((Config.options?.bar.workspaces.alwaysShowNumbers && (!Config.options?.bar.workspaces.showAppIcons ||  !workspaceButtonBackground.biggestWindow || root.showNumbers))
                        || (root.showNumbers && !Config.options?.bar.workspaces.showAppIcons))
                        ? 1 : 0
                        z: 3
                        anchors.centerIn: parent
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        font {
                            pixelSize: Appearance.font.pixelSize.sm - ((text.length - 1) * (text !== "10") * 2)
                            family: Config.options?.bar.workspaces.useNerdFont ? Appearance.font.family.iconNerd: Appearance.font.family.main
                        }
                        text: Config.options?.bar.workspaces.numberMap[button.workspaceValue - 1] || button.workspaceValue
                        elide: Text.ElideRight
                        color: (monitor?.activeWorkspace?.id == button.workspaceValue) ? "red" : (workspaceOccupied[index] ? "green" : "yellow")
                        Behavior on opacity {
                            animation: Appearance.animation.elementMoveFast.numberAnimation.createObject(this)
                        }
                    }
                    // Workspace dot
                    Rectangle {
                        id: wsDot
                        opacity: (Config.options?.bar.workspaces.alwaysShowNumbers || root.showNumbers || (Config.options?.bar.workspaces.showAppIcons && workspaceButtonBackground.biggesWindow)) ? 0 : 1
                        visible: opacity > 0
                        anchors.centerIn: parent
                        width: workspaceButtonWidth * 0.18
                        height: width
                        radius: width / 2
                        color: (monitor?.activeWorkspace?.id == button.workspaceValue || workspaceOccupied[index]) ? Appearance.colors.activeWorkspaceBackground : Appearance.colors.workspacesBackground
                    }
                    // App Icon
                    Item {
                        anchors.centerIn: parent
                        width: workspaceButtonWidth
                        height: workspaceButtonWidth
                        opacity: !Config.options?.bar.workspaces.showAppIcons ? 0 : (workspaceButtonBackground.biggestWindow && !root.showNumbers && Config.options.bar.workspaces.showAppIcons) ? 1 : workspaceButtonBackground.biggestWindow ? workspaceIconOpacityShrinked : 0
                        visible: opacity > 0
                        IconImage {
                            id: mainAppIcon
                            anchors.bottom: parent.bottom
                            anchors.right: parent.right
                            anchors.bottomMargin: (!root.showNumbers && Config.options?.bar.workspaces.showAppIcons) ? (workspaceButtonWidth - workspaceIconSize) / 2 : workspaceMarginShrinked
                            anchors.rightMargin: (!root.showNumbers && Config.options?.bar.workspaces.showAppIcons) ? (workspaceButtonWidth - workspaceIconSize) / 2 : workspaceMarginShrinked
                            source: workspaceButtonBackground.mainAppIconSource
                            implicitSize: (!root.showNumbers && Config.options?.bar.workspaces.showAppIcons) ? workspaceIconSize : workspaceIconSizeShrinked

                            Behavior on opacity {
                                animation: Appearance.animation.elementMoveFast.numberAnimation.createObject(this)
                            }
                            Behavior on anchors.bottomMargin {
                                animation: Appearance.animation.elementMoveFast.numberAnimation.createObject(this)
                            }
                            Behavior on anchors.rightMargin {
                                animation: Appearance.animation.elementMoveFast.numberAnimation.createObject(this)
                            }
                            Behavior on implicitSize {
                                animation: Appearance.animation.elementMoveFast.numberAnimation.createObject(this)
                            }
                        }

                        Loader {
                            active: Config.options.bar.workspaces.monochromeIcons
                            anchors.fill: mainAppIcon
                            sourceComponent: Item {
                                Desaturate {
                                    id: destauratedIcon
                                    visible: false
                                    anchors.fill: parent
                                    source: mainAppIcon
                                    desaturation: 0.8
                                }
                                ColorOverlay {
                                    anchors.fill: destauratedIcon
                                    source: destauratedIcon
                                    color: ColorUtils.transparentize(wsDot.color, 0.9)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
