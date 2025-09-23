import qs
import qs.common
import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
pragma Singleton
pragma ComponentBehavior: Bound

Singleton {
  id: root
  property bool barOpen: true
  property bool screenLocked: false
  property bool superDown: false
  property bool superReleaseMightTrigger: true
  property bool osdVolumeOpen: true

  GlobalShortcut {
    name: "workspaceNumber"
    onPressed: {
      root.superDown = true
    }
    onReleased: {
      root.superDown = false
    }
  }
}