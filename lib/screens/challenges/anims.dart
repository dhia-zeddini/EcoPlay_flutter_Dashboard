import 'package:flutter/material.dart';

class WinningAnimation extends StatefulWidget {
  WinningAnimation({Key? key}) : super(key: key); // Constructor accepts a key

  @override
  _WinningAnimationState createState() => _WinningAnimationState();
}

class _WinningAnimationState extends State<WinningAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void startAnimation() {
    _controller.forward(from: 0); // Start the animation from the beginning
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: Center(
        child: Icon(Icons.star, size: 100, color: Colors.amber),
      ),
    );
  }
}
