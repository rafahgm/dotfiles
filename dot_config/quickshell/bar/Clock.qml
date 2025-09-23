import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.common
import qs.common.widgets
import qs.services

Item {
  id: root
  property bool borderless: Config.options.bar.borderless
  property bool showDate: Config.options.bar.verbose
  implicitHeight: rowLayout.implicitHeight
  implicitWidth: rowLayout.implicitWidth

  RowLayout {
    id: rowLayout
    anchors.centerIn: parent
    spacing: 4

    StyledText {
      font.pixelSize: Appearance.font.pixelSize.lg
      color: Appearance.colors.clockText
      text: DateTime.time
    }

    StyledText {
      visible: root.showDate
      font.pixelSize: Appearance.font.pixelSize.sm
      color: Appearance.colors.clockText
      text: "•"
    }

    StyledText {
      visible: root.showDate
      font.pixelSize: Appearance.font.pixelSize.lg
      color: Appearance.colors.clockText
      text: DateTime.date
    }
  }

  MouseArea {
    id: mouseArea
    anchors.fill: parent
    hoverEnabled: true
    acceptedButtons: Qt.NoButton
  }
}