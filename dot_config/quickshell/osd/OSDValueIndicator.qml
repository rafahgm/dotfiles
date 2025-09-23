import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Effects
import Quickshell
import Quickshell.Widgets
import qs.common
import qs.common.widgets

Item {
    id: root
    required property real value
    required property string icon
    required property string name
    property bool rotateIcon: false
    property bool scaleIcon: false

    property real valueIndicatorVerticalPadding: 9
    property real valueIndicatorLeftPadding: 10
    property real valueIndicatorRightPadding: 20

    Layout.margins: Appearance.sizes.elevationMargin
    implicitWidth: Appearance.sizes.osdWidth
    implicitHeight: valueIndicator.implicitHeight

    StyledRectangularShadow {
        target: valueIndicator
    }

    WrapperRectangle {
        id: valueIndicator
        anchors.fill: parent
        radius: Appearance.rounding.full
        color: Appearance.colors.osd.background
        implicitWidth: valueRow.implicitWidth

        RowLayout {
            id: valueRow
            Layout.margins: 10
            anchors.fill: parent
            spacing: 10

            Item {
                implicitWidth: 30
                implicitHeight: 30
                Layout.alignment: Qt.AlignVCenter
                Layout.leftMargin: valueIndicatorLeftPadding
                Layout.topMargin: valueIndicatorVerticalPadding
                Layout.bottomMargin: valueIndicatorVerticalPadding

                MaterialSymbol {
                    anchors {
                        centerIn: parent
                        alignWhenCentered: !root.rotateIcon
                    }

                    color: Appearance.colors.osd.icon
                    renderType: Text.QtRendering
                    text: root.icon
                    iconSize: 20 + 10 * (root.scaleIcon ? value : 1)
                    rotation: 180 * (root.rotateIcon ? value : 0)

                    Behavior on iconSize {
                        animation: Appearance.animation.elementMoveEnter.numberAnimation.createObject(this)
                    }
                    Behavior on rotation {
                        animation: Appearance.animation.elementMoveEnter.numberAnimation.createObject(this)
                    }
                }
            }

            ColumnLayout {
                Layout.alignment: Qt.AlignVCenter
                Layout.rightMargin: valueIndicatorRightPadding
                spacing: 5

                RowLayout {
                    Layout.leftMargin: valueProgressBar.height / 2
                    Layout.rightMargin: valueProgressBar.height / 2

                    StyledText {
                        color: Appearance.colors.osd.text
                        font.pixelSize: Appearance.font.pixelSize.sm
                        Layout.fillWidth: true
                        text: root.name
                    }

                    StyledText {
                        color: Appearance.colors.osd.text
                        font.pixelSize: Appearance.font.pixelSize.sm
                        Layout.fillWidth: false
                        text: Math.round(root.value * 100)
                    }
                }

                StyledProgressBar {
                    id: valueProgressBar
                    Layout.fillWidth: true
                    value: root.value
                    trackColor: Appearance.colors.osd.track
                    highlightColor: Appearance.colors.osd.highlight
                }
            }
        }
    }
}
