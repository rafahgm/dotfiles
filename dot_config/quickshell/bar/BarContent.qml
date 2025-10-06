import Quickshell
import QtQuick
import QtQuick.Layouts
import qs.common
import qs.common.widgets

Item {
    id: root

    property var screen: root.QsWindow.window?.screen
    property real useShortenedForm: (Appearance.sizes.barHellaShortenScreenWidthThreshold >= screen?.width) ? 2 : (Appearance.sizes.barShortenScreenWidthThreshold >= screen?.width) ? 1 : 0
    readonly property int centerSideModuleWidth: (useShortenedForm == 2) ? Appearance.sizes.barCenterSideModuleWidthHellaShortened : (useShortenedForm == 1) ? Appearance.sizes.barCenterSideModuleWidthShortened : Appearance.sizes.barCenterSideModuleWidth

    component VerticalBarSeparator: Rectangle {
        Layout.topMargin: Appearance.sizes.baseBarHeight / 3
        Layout.bottomMargin: Appearance.sizes.baseBarHeight / 3
        Layout.fillHeight: true
        implicitWidth: 1
        color: Appearance.colors.bar.separator
    }

    // Background shadow
    Loader {
        active: Config.options.bar.showBackground && Config.options.bar.cornerStyle === 1
        anchors.fill: barBackground
        sourceComponent: StyledRectangularShadow {
            anchors.fill: undefined // The loader's anchors act on this, and this should not have any anchor
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
        color: Config.options.bar.showBackground ? Appearance.colors.bar.background : "transparent"
        radius: Config.options.bar.cornerStyle === 1 ? Appearance.rounding.windowRounding : 0
        border.width: Config.options.bar.cornerStyle === 1 ? 1 : 0
        border.color: Appearance.colors.bar.border
    }

    RowLayout {
        id: leftSectionRowLayout
        anchors.fill: parent
        spacing: 10
    }

    RowLayout {
        id: middleSection
        anchors {
            top: parent.top
            bottom: parent.bottom
            horizontalCenter: parent.horizontalCenter
        }
        spacing: 4

        BarGroup {
            id: leftCenterGroup
            Layout.preferredWidth: root.centerSideModuleWidth
            Layout.fillHeight: false

            //Media {
            //    visible: root.useShortenedForm < 2
            //    Layout.fillWidth: true
            //}
        }

        BarGroup {
            id: middleCenterGroup
            padding: workspacesWidget.widgetPadding

            Workspaces {
                id: workspacesWidget
                Layout.fillHeight: true
            }
        }

        VerticalBarSeparator {
            visible: Config.options?.bar.borderless
        }

        BarGroup {
            id: rightCenterGroupContent
            Clock {
                showDate: (Config.options.bar.verbose && root.useShortenedForm < 2)
                Layout.alignment: Qt.AlignVCenter
                Layout.fillWidth: true
            }
        }

        // SysTray {
        //     visible: root.useShortenedForm === 0
        //     Layout.fillWidth: false
        //     Layout.fillHeight: true
        //     invertSide: Config?.options.bar.bottom
        // }
    }

    RowLayout {
        id: rightSectionRowLayout
        anchors.fill: parent
        spacing: 5
        layoutDirection: Qt.RightToLeft

        SysTray {
            visible: root.useShortenedForm === 0
            Layout.fillWidth: false
            Layout.fillHeight: true
            invertSide: Config?.options.bar.bottom
        }
    }
}
