import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Hyprland
import qs
import qs.services
import qs.common
import qs.common.widgets

Scope {
    id: root
    property string protectionMessage: ""
    property var focusedScreen: Quickshell.screens.find(s => s.name == Hyprland.focusedMonitor?.name)

    function triggerOsd() {
        GlobalStates.osdVolumeOpen = true;
        osdTimeout.restart();
    }

    Timer {
        id: osdTimeout
        interval: Config.options.osd.timeout
        repeat: false
        running: false
        onTriggered: {
            GlobalStates.osdVolumeOpen = false;
            root.protectionMessage = "";
        }
    }

    Connections {
        target: Audio.sink?.audio ?? null
        function onVolumeChanged() {
            if (!Audio.ready)
                return;
            root.triggerOsd();
        }

        function onMutedChanged() {
            if (!Audio.ready)
                return;
            root.triggerOsd();
        }
    }

    Connections {
        target: Audio
        function onSinkProtectionTriggered(reason) {
            root.protectionMessage = reason;
            root.triggerOsd();
        }
    }

    Loader {
        id: osdLoader
        active: GlobalStates.osdVolumeOpen

        sourceComponent: PanelWindow {
            id: osdRoot
            color: "transparent"

            WlrLayershell.namespace: "quickshell:OSD"
            WlrLayershell.layer: WlrLayer.Overlay

            anchors {
                top: !Config.options.bar.bottom
                bottom: Config.options.bar.bottom
            }

            mask: Region {
                item: osdValuesWrapper
            }

            exclusionMode: ExclusionMode.Ignore
            exclusiveZone: 0
            margins {
                top: Appearance.sizes.barHeight
                bottom: Appearance.sizes.barHeight
            }

            implicitWidth: columnLayout.implicitWidth
            implicitHeight: columnLayout.implicitHeight
            visible: osdLoader.active

            ColumnLayout {
                id: columnLayout
                anchors.horizontalCenter: parent.horizontalCenter
                Item {
                    id: osdValuesWrapper
                    implicitWidth: contentColumnLayout.implicitWidth
                    implicitHeight: contentColumnLayout.implicitHeight + Appearance.sizes.elevationMargin * 2
                    clip: true

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: GlobalStates.osdVolumeOpen = false
                    }

                    ColumnLayout {
                        id: contentColumnLayout
                        anchors {
                            top: parent.top
                            left: parent.left
                            right: parent.right
                            rightMargin: Appearance.sizes.elevationMargin
                            leftMargin: Appearance.sizes.elevationMargin
                        }

                        spacing: 0

                        OSDValueIndicator {
                            id: osdValues
                            Layout.fillWidth: true
                            value: Audio.sink?.audio.volume ?? 0
                            icon: Audio.sink?.audio.muted ? "volume_off" : "volume_up"
                            name: "Volume"
                        }

                        Item {
                            id: protectionMessageWrapper
                            implicitHeight: protectionMessageBackground.implicitHeight
                            implicitWidth: protectionMessageBackground.implicitWidth
                            Layout.alignment: Qt.AlignHCenter
                            opacity: root.protectionMessage !== "" ? 1 : 0

                            StyledRectangularShadow {
                                target: protectionMessageBackground
                            }

                            Rectangle {
                                id: protectionMessageBackground
                                anchors.centerIn: parent
                                color: "teal"
                                property real padding: 10
                                implicitHeight: protectionMessageRowLayout.implicitHeight + padding * 2
                                implicitWidth: protectionMessageRowLayout.implicitWidth + padding * 2
                                radius: Appearance.rounding.md

                                RowLayout {
                                    id: protectionMessageRowLayout
                                    anchors.centerIn: parent
                                    MaterialSymbol {
                                        id: protectionMessageIcon
                                        text: "dangerous"
                                        iconSize: Appearance.font.pixelSize.xxxl
                                        color: "yellow"
                                    }

                                    StyledText {
                                        id: protectionMessageTextWidget
                                        horizontalAlignment: Text.AlignHCenter
                                        color: "yellow"
                                        wrapMode: Text.Wrap
                                        text: root.protectionMessage
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
