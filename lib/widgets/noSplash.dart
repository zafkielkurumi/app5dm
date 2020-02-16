import 'package:flutter/material.dart';

class NoSplashFactory extends InteractiveInkFeatureFactory {
  NoSplashFactory();

  @override
  InteractiveInkFeature create({
    @required MaterialInkController controller,
    @required RenderBox referenceBox,
    @required Offset position,
    @required Color color,
    @required TextDirection textDirection,
    bool containedInkWell = false,
    RectCallback rectCallback,
    BorderRadius borderRadius,
    ShapeBorder customBorder,
    double radius,
    VoidCallback onRemoved,
  }) {
    return NoSplash(controller: controller, referenceBox: referenceBox);
  }
}

class NoSplash extends InteractiveInkFeature {
  NoSplash(
      {@required MaterialInkController controller,
      @required RenderBox referenceBox})
      : assert(controller != null),
        assert(referenceBox != null),
        super(controller: controller, referenceBox: referenceBox);

  @override
  paintFeature(Canvas canvas, Matrix4 transform) {}
}
