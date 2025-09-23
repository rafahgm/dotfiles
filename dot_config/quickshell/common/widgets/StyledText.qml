import QtQuick
import QtQuick.Layouts
import qs.common

Text {
  id: root
  property bool animateChange: false
  property real animateDistanceX: 0
  property real animateDistanceY: 0

  renderType: Text.NativeRendering
  verticalAlignment: Text.AlignVCenter
  font {
    hintingPreference: Font.PreferFullHinting
    family: Appearance?.font.family.main ?? "sans-serif"
    pixelSize: Appearance?.font.pixelSize.sm ?? 15
  }
  color: Appearance?.colors.text ?? "black"
  linkColor: Appearance?.colors.linkColor

  component Anim: NumberAnimation {
    target: root
    duration: 300 / 2
    easing.type: Easing.BezierSpline
    easing.bezierCurve: Appearance.animation.elementMoveFast.bezierCurve
  }
}