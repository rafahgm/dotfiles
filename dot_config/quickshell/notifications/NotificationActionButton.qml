import qs.common
import qs.common.widgets
import qs.services
import QtQuick
import Quickshell.Services.Notifications

RippleButton {
    id: button
    property string buttonText
    property string urgency

    implicitHeight: 30
    leftPadding: 15
    rightPadding: 15
    buttonRadius: Appearance.rounding.small
    colBackground: (urgency == NotificationUrgency.Critical) ? Appearance.colors.notifications.actionUrgent : Appearance.colors.notifications.action
    colBackgroundHover: (urgency == NotificationUrgency.Critical) ? Appearance.colors.notifications.actionHoverUrgent : Appearance.colors.notifications.actionHover
    colRipple: (urgency == NotificationUrgency.Critical) ? Appearance.colors.notifications.actionRippleUrgent : Appearance.colors.notifications.actionRipple

    contentItem: StyledText {
        horizontalAlignment: Text.AlignHCenter
        text: buttonText
        color: (urgency == NotificationUrgency.Critical) ? Appearance.m3colors.m3onSurfaceVariant : Appearance.m3colors.m3onSurface
    }
}