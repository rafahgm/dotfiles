pragma Singleton
pragma ComponentBehavior: Bound

import qs.common.utils
import Qt.labs.platform
import QtQuick
import Quickshell

Singleton {
  readonly property string home: StandardPaths.standardLocations(StandardPaths.HomeLocation)[0]
  readonly property string config: StandardPaths.standardLocations(StandardPaths.ConfigLocation)[0]

  property string shellConfig: FileUtils.trimFileProtocol(`${Directories.config}/quickshell`)
  property string shellConfigName: "config.json"
  property string shellConfigPath: `${Directories.shellConfig}/${Directories.shellConfigName}`

  // Cleanup on init
  Component.onCompleted: {
    Quickshell.execDetached(['mkdir', '-p', `${shellConfig}`])
  }
}