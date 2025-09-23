import Quickshell
import QtQuick
import QtQuick.Layouts
import qs.common
import qs.common.widgets

Item {
    id: root

    property var screen: root.QsWindow.window?.screen

    // Background shadow
    Loader {
        active: Config.options.bar.showBackground && Config.options.bar.cornerStyle === 1
        anchors.fill: barBackground
        sourceComponent: StyledRectangularShadow {
            anchors.fill: undefined
            target: barBackground
        }
    }

    // Background
    Rectangle {
        id: barBackground
        anchors {
            fill: parent
            margins: Config.options.bar.cornerStyle === 1 ? (Appearance.sizes.hyprlandGapsOut) : 0
        }
        color: Config.options.bar.showBackground ? Appearance.colors.barBackground : "transparent"
        radius: Config.options.bar.cornerStyle === 1 ? Appearance.rounding.windowRounding : 0
        border.width: Config.options.bar.cornerStyle === 1 ? 1 : 0
        border.color: Appearance.colors.barBackground
    }

    RowLayout {
        id: leftSectionRowLayout
        anchors.fill: parent
        spacing: 10

        Workspaces {
            id: workspacesWidget
            Layout.fillHeight: true
        }

        Clock {
            showDate: (Config.options.bar.verbose && root.useShortenedForm < 2)
            Layout.alignment: Qt.AlignVCenter
            Layout.fillWidth: true
        }

        SysTray {
            visible: root.useShortenedForm === 0
            Layout.fillWidth: false
            Layout.fillHeight: true
            invertSide: Config?.options.bar.bottom
        }
    }
}
