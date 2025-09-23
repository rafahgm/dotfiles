import qs.common
import qs.common.widgets
import qs.common.utils
import QtQuick
import QtQuick.Effects
import Quickshell
import Quickshell.Wayland

LazyLoader {
    id: root
    property Item hoverTarget
    default property Item contentItem
    property real popupBackgroundMargin: 0

    active: hoverTarget && hoverTarget.containsMouse

    component: PanelWindow {
        id: popupWindow
        color: "transparent"

        anchors.left: !Config.options.bar.vertical || (Config.options.bar.vertical && !Config.options.bar.bottom)
        anchors.right: Config.options.bar.vertical && Config.options.bar.bottom
        anchors.top: Config.options.bar.vertical || (!Config.options.bar.vertical && !Config.options.bar.bottom)
        anchors.bottom: !Config.options.bar.vertical && Config.options.bar.bottom

        implicitWidth: popupBackground.implicitWidth + Appearance.sizes.hyprlandGapsOut * 2 + root.popupBackgroundMargin
        implicitHeight: popupBackground.implicitHeight + Appearance.sizes.hyprlandGapsOut * 2 + root.popupBackgroundMargin

        mask: Region {
            item: popupBackground
        }

        exclusionMode: ExclusionMode.Ignore
        exclusiveZone: 0
        margins {
            left: {
                if (!Config.options.bar.vertical)
                    return root.QsWindow?.mapFromItem(root.hoverTarget, (root.hoverTarget.width - popupBackground.implicitWidth) / 2, 0).x;
                return Appearance.sizes.verticalBarWidth;
            }
            top: {
                if (!Config.options.bar.vertical)
                    return Appearance.size.barHeight;
                return root.QsWindow?.mapFromItem(root.hoverTarget, (root.hoverTarget.height - popupBackground.implicitHeight) / 2, 0).y;
            }
            right: Appearance.sizes.verticalBarWidth
            bottom: Appearance.sizes.barHeight
        }
        WlrLayershell.namespace: "quickshell:popup"
        WlrLayershell.layer: WlrLayer.Overlay

        StyledRectangularShadow {
            target: popupBackground
        }

        Rectangle {
            id: popupBackground
            readonly property real margin: 10
            anchors {
                fill: parent
                leftMargin: Apperance.sizes.hyprlandGapsOut + root.popupBackgroundMargin * (!popupWindow.anchors.left)
                rightMargin: Apperance.sizes.hyprlandGapsOut + root.popupBackgroundMargin * (!popupWindow.anchors.right)
                topMargin: Apperance.sizes.hyprlandGapsOut + root.popupBackgroundMargin * (!popupWindow.anchors.top)
                bottomMargin: Apperance.sizes.hyprlandGapsOut + root.popupBackgroundMargin * (!popupWindow.anchors.bottom)
            }
            implicitWidth: root.contentItem.implicitWidth + margin * 2
            implicitHeight: root.contentItem.implicitHeight + margin * 2
            color: ColorUtils.applyAlpha('red', 0.9)
        }
    }
}
