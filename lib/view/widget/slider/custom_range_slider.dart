import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'swap_icon_range_thumb.dart';
import 'package:agro/gen/assets.gen.dart';

class CustomRangeSlider extends StatefulWidget {
  final RangeValues values;
  final ValueChanged<RangeValues> onChanged;
  final double min;
  final double max;
  final int? divisions;
  final Color activeColor;
  final Color inactiveColor;
  final Color thumbColor;
  final double thumbRadius;

  const CustomRangeSlider({
    super.key,
    required this.values,
    required this.onChanged,
    required this.min,
    required this.max,
    this.divisions,
    required this.activeColor,
    required this.inactiveColor,
    required this.thumbColor,
    this.thumbRadius = 14,
  });

  @override
  State<CustomRangeSlider> createState() => _CustomRangeSliderState();
}

class _CustomRangeSliderState extends State<CustomRangeSlider> {
  ui.Image? _arrowImage;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<void> _loadImage() async {
    final data = await rootBundle.load(Assets.icons.doubleEndArrow.path);
    final bytes = data.buffer.asUint8List();
    final codec = await ui.instantiateImageCodec(bytes);
    final frame = await codec.getNextFrame();

    if (mounted) {
      setState(() {
        _arrowImage = frame.image;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_arrowImage == null) {
      // Prevent slider from building before image is ready
      return const SizedBox(height: 40);
    }

    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        rangeThumbShape: SwapIconRangeThumb(
          image: _arrowImage!,
          radius: widget.thumbRadius,
        ),
        thumbColor: widget.thumbColor,
        activeTrackColor: widget.activeColor,
        inactiveTrackColor: widget.inactiveColor,
      ),
      child: RangeSlider(
        min: widget.min,
        max: widget.max,
        values: widget.values,
        onChanged: widget.onChanged,
      ),
    );
  }
}
