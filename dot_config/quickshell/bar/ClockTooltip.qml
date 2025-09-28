import qs
import qs.common
import qs.common.widgets
import qs.services
import QtQuick
import QtQuick.Layouts

StyledPopup {
    id: root
    property string formattedDate: Qt.locale().toString(DateTime.clock.date, "dddd, MMMM dd, yyyy")
    property string formattedTime: DateTime.time
    property string formattedUptime: DateTime.uptime

    ColumnLayout {
        id: columnLayout
        anchors.centerIn: parent
        spacing: 4

        // Date + Time row
        RowLayout {
            spacing: 5

            MaterialSymbol {
                fill: 0
                font.weight: Font.Medium
                text: "calendar_month"
                iconSize: Appearance.font.pixelSize.large
                color: Appearance.colors.clock.tooltip
            }
            StyledText {
                horizontalAlignment: Text.AlignLeft
                color: Appearance.colors.clock.tooltip
                text: `${root.formattedDate}`
                font.weight: Font.Medium
            }
        }

        // Uptime row
        RowLayout {
            spacing: 5
            Layout.fillWidth: true
            MaterialSymbol {
                text: "timelapse"
                color: Appearance.colors.clock.tooltip
                font.pixelSize: Appearance.font.pixelSize.large
            }
            StyledText {
                text: "Uptime:"
                color: Appearance.colors.clock.tooltip
            }
            StyledText {
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignRight
                color: Appearance.colors.clock.tooltip
                text: root.formattedUptime
            }
        }
    }
}
