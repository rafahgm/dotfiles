pragma Singleton
pragma ComponentBehavior: Bound
import qs
import qs.common
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    property var clock: SystemClock {
        id: clock
        precision: GlobalStates.screenLocked ? SystemClock.Seconds : SystemClock.Minutes
    }
    property string time: Qt.locale().toString(clock.date, Config.options?.time.format ?? "hh:mm")
    property string shortDate: Qt.locale().toString(clock.date, Config.options?.time.shortDateFormat ?? "dd/MM")
    property string date: Qt.locale().toString(clock.date, Config.options?.time.dateFormat ?? "dd/MM/yy")
    property string collapsedCalendarFormat: Qt.locale().toString(clock.date, "dd MMMM yyyy")
    property string uptime: "0h, 0m"
}
