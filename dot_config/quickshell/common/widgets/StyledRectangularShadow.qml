import QtQuick
import QtQuick.Effects
import qs.common
import qs.common.utils

RectangularShadow {
  required property var target
  anchors.fill: target
  radius: target.radius
  blur: 0.9 * Appearance.sizes.elevationMargin
  offset: Qt.vector2d(0.0, 1.0)
  spread: 1
  color: ColorUtils.transparentize("#000000", 0.7)
  cached: true
}