pragma Singleton
pragma ComponentBehavior: Bound

import qs.common.utils
import Qt.labs.platform
import QtQuick
import Quickshell

Singleton {
  readonly property string home: StandardPaths.standardLocations(StandardPaths.HomeLocation)[0]
  readonly property string config: StandardPaths.standardLocations(StandardPaths.ConfigLocation)[0]
  readonly property string cache: StandardPaths.standardLocations(StandardPaths.CacheLocation)[0]

  property string shellConfig: FileUtils.trimFileProtocol(`${Directories.config}/quickshell`)
  property string shellConfigName: "config.json"
  property string shellConfigPath: `${Directories.shellConfig}/${Directories.shellConfigName}`
  property string notificationsPath: FileUtils.trimFileProtocol(`${Directories.cache}/notifications/notifications.json`)

  // Cleanup on init
  Component.onCompleted: {
    Quickshell.execDetached(['mkdir', '-p', `${shellConfig}`])
  }
}