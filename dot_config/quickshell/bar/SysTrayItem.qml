import QtQuick
import Quickshell
import Quickshell.Services.SystemTray
import Quickshell.Widgets
import Qt5Compat.GraphicalEffects
import qs.common
import qs.common.utils

MouseArea {
    id: root

    required property SystemTrayItem item
    property bool targetMenuOpen: false

    signal menuOpened(qsWindow: var)
    signal menuClosed

    hoverEnabled: true
    acceptedButtons: Qt.LeftButton | Qt.RightButton
    implicitWidth: 20
    implicitHeight: 20

    onPressed: event => {
        switch (event.button) {
        case Qt.LeftButton:
            item.activate();
            break;
        case Qt.RightButton:
            if (item.hasMenu) menu.open();
            break;
        }
        event.accepted = true;
    }
    onEntered: {
        tooltip.text = items.tooltipTitle.length > 0 ? item.tooltipTitle : (item.title.length > 0 ?  item.title : item.id)
        if(items.tooltipDescription.length > 0) tooltip.text += " • " + item.tooltipDescription;
        if(Config.options.bar.tray.showItemId) tooltip.text += "\n[" + item.id + "]";
    }

    IconImage {
        id: trayIcon
        visible: !Config.options.bar.tray.monochromeIcons
        source: root.item.icon
        anchors.centerIn: parent
        width: parent.width
        height: parent.height
    }

    Loader {
        active: Config.options.bar.tray.monochromeIcons
        anchors.fill: trayIcon
        sourceComponent: Item {
            Desaturate {
                id: desaturatedIcon
                visible: false
                anchors.fill: parent
                source: trayIcon
                desaturation: 0.8
            }
            ColorOverlay {
                anchors.fill: desaturatedIcon
                source: desaturatedIcon
                color: ColorUtils.transparentize('red', 0.9)
            }
        }
    }
}
