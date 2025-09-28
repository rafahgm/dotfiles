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
      font.pixelSize: Appearance.font.pixelSize.large
      color: Appearance.colors.clock.text
      text: DateTime.time
    }

    StyledText {
      visible: root.showDate
      font.pixelSize: Appearance.font.pixelSize.small
      color: Appearance.colors.clock.text
      text: "•"
    }

    StyledText {
      visible: root.showDate
      font.pixelSize: Appearance.font.pixelSize.small
      color: Appearance.colors.clock.text
      text: DateTime.date
    }
  }

  MouseArea {
    id: mouseArea
    anchors.fill: parent
    hoverEnabled: true
    acceptedButtons: Qt.NoButton

    ClockTooltip {
      hoverTarget: mouseArea
    }
  }
}