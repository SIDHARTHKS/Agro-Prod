import 'package:flutter/material.dart';

class ProgressLoader extends StatefulWidget {
  final Color color;
  final double height;

  const ProgressLoader({
    super.key,
    this.color = const Color.fromARGB(255, 0, 0, 0),
    this.height = 3,
  });

  @override
  State<ProgressLoader> createState() => _TopProgressLoaderState();
}

class _TopProgressLoaderState extends State<ProgressLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(); // infinite loop
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return Align(
            alignment: Alignment.centerLeft,
            child: FractionallySizedBox(
              widthFactor: (_controller.value * 0.9),
              child: Container(
                height: widget.height,
                decoration: BoxDecoration(
                  // gradient: LinearGradient(
                  //   colors: [
                  //     widget.color.withOpacity(0.2),
                  //     widget.color,
                  //     widget.color.withOpacity(0.2),
                  //   ],
                  // ),
                  color: widget.color,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
