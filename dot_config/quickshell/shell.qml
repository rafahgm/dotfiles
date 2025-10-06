//@ pragma UseQApplication
//@ pragma Env QS_NO_RELOAD_POPUP=1
//@ pragma Env QT_QUICK_CONTROLS_STYLE=Basic
//@ pragma Env QT_QUICK_FLICKABLE_WHEEL_DECELERATION=10000
//@ pragma Env QT_SCALE_FACTOR=1

import Quickshell
import "./bar"
import "./osd"
import "./notifications"
//import "./media"
import qs.common

ShellRoot {
  property bool enableBar: true
  property bool enableVolumeOSD: true
  property bool enableNotificationPopup: true
  property bool enableMediaControls: false

  LazyLoader {active: enableBar && Config.ready && !Config.options.bar.vertical; component: Bar{}}
  LazyLoader {active: enableVolumeOSD; component: VolumeOSD{}}
  LazyLoader {active: enableNotificationPopup; component: NotificationPopup{}}
  // LazyLoader {active: enableMediaControls; component: MediaControls{}}
}