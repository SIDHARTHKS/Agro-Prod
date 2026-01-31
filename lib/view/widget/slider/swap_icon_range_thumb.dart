import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class SwapIconRangeThumb extends RangeSliderThumbShape {
  final double radius;
  final ui.Image image;

  const SwapIconRangeThumb({
    required this.image,
    this.radius = 14,
  });

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(radius);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    bool? isDiscrete,
    bool? isEnabled,
    bool? isOnTop,
    bool? isPressed,
    required SliderThemeData sliderTheme,
    TextDirection? textDirection,
    Thumb? thumb,
  }) {
    final canvas = context.canvas;

    /// Thumb background
    final paint = Paint()
      ..color = sliderTheme.thumbColor ?? Colors.green
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius, paint);

    /// Draw preloaded image
    final size = radius * 1.2;
    final rect = Rect.fromCenter(
      center: center,
      width: size,
      height: size,
    );

    paintImage(
      canvas: canvas,
      rect: rect,
      image: image,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.high,
    );
  }
}
