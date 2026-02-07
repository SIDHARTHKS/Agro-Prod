import 'dart:ui';
import 'package:flutter/material.dart';

class DepotCardCarousel extends StatefulWidget {
  final List<Widget> items;
  final int currentIndex;
  final ValueChanged<int> onChanged;

  const DepotCardCarousel({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onChanged,
  });

  @override
  State<DepotCardCarousel> createState() => _DepotCardCarouselState();
}

class _DepotCardCarouselState extends State<DepotCardCarousel>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _anim;

  bool _animating = false;

  static const double _sideOffset = 65; // more horizontal reveal
  static const double _sideScale = 0.78; // smaller side cards

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );

    _anim = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic, // 🔥 smooth motion
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  int get _leftIndex =>
      (widget.currentIndex - 1 + widget.items.length) % widget.items.length;

  int get _rightIndex => (widget.currentIndex + 1) % widget.items.length;

  void _next() async {
    if (_animating) return;

    _animating = true;

    // 🔥 UPDATE DATA FIRST
    final nextIndex = _leftIndex;
    widget.onChanged(nextIndex);

    // 🔥 THEN RUN ANIMATION WITH CORRECT DATA
    await _controller.forward(from: 0);

    _animating = false;
  }

  Widget _card({
    required Widget child,
    required double dx,
    required double scale,
    required int z,
    VoidCallback? onTap,
  }) {
    return Center(
      child: Transform.translate(
        offset: Offset(dx, 0),
        child: Transform.scale(
          scale: scale,
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.82, // 🔥 KEY LINE
            child: GestureDetector(
              onTap: onTap,
              child: Material(
                elevation: z.toDouble(),
                borderRadius: BorderRadius.circular(18),
                clipBehavior: Clip.antiAlias,
                child: Stack(
                  children: [
                    child,

                    // 🔥 blur overlay for back cards
                    if (scale < 0.88) // side cards only
                      Positioned.fill(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(
                            sigmaX: 1,
                            sigmaY: 1,
                          ),
                          child: Container(
                            color: Colors.black.withOpacity(0.03), // subtle dim
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 400,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (_, __) {
              final t = _anim.value;

              return Stack(
                alignment: Alignment.center,
                children: [
                  // RIGHT → LEFT
                  _card(
                    child: widget.items[_rightIndex],
                    dx: lerpDouble(_sideOffset, -_sideOffset, t)!,
                    scale: _sideScale,
                    z: 1,
                  ),

                  // CENTER → RIGHT
                  _card(
                    child: widget.items[widget.currentIndex],
                    dx: lerpDouble(0, _sideOffset, t)!,
                    scale: lerpDouble(0.96, _sideScale, t)!,
                    z: 2,
                  ),

                  // LEFT → CENTER (tap here)
                  _card(
                    child: widget.items[_leftIndex],
                    dx: lerpDouble(-_sideOffset, 0, t)!,
                    scale: lerpDouble(_sideScale, 0.96, t)!,
                    z: 3,
                    onTap: _next,
                  ),
                ],
              );
            },
          ),
        ),
        const SizedBox(height: 14),

        _indicator(), // 🔥 dots + dash
      ],
    );
  }

  Widget _indicator() {
    final count = widget.items.length;

    return SizedBox(
      height: 20,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(count, (index) {
          final isActive = index == widget.currentIndex;

          return AnimatedContainer(
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeInOutCubic,
            margin: const EdgeInsets.symmetric(horizontal: 6),
            width: isActive ? 22 : 6, // 🔥 dash vs dot
            height: 6,
            decoration: BoxDecoration(
              color: isActive ? Colors.green : Colors.grey.withOpacity(0.4),
              borderRadius: BorderRadius.circular(10),
            ),
          );
        }),
      ),
    );
  }
}
