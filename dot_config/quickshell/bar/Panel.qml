import QtQuick
import QtQuick.Layouts
import Quickshell

PanelWindow {
  id: panel

  implicitHeight: 30

  anchors {
    top: true
    left: true
    right: true
  }

  Rectangle {
    anchors.fill: parent
    RowLayout {
      anchors {
        left: parent.left
        leftMargin: 8
        verticalCenter: parent.verticalCenter
      }
      
      spacing: 8

      Clock {
        Layout.alignment: Qt.AlignVCenter
      }
    }
  }
}