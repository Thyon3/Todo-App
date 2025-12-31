import 'package:flutter/material.dart';

class AnimatedFab extends StatefulWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final String? label;

  const AnimatedFab({
    Key? key,
    required this.onPressed,
    required this.icon,
    this.label,
  }) : super(key: key);

  @override
  State<AnimatedFab> createState() => _AnimatedFabState();
}

class _AnimatedFabState extends State<AnimatedFab>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: widget.label != null
          ? FloatingActionButton.extended(
              onPressed: () {
                _controller.forward().then((_) => _controller.reverse());
                widget.onPressed();
              },
              icon: Icon(widget.icon),
              label: Text(widget.label!),
            )
          : FloatingActionButton(
              onPressed: () {
                _controller.forward().then((_) => _controller.reverse());
                widget.onPressed();
              },
              child: Icon(widget.icon),
            ),
    );
  }
}
