import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ThinkingAnimation extends StatelessWidget {
  const ThinkingAnimation({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _dot(0),
          _dot(200),
          _dot(400),
        ],
      ),
    );
  }

  Widget _dot(int delayMs) {
    return Container(
      width: 10,
      height: 10,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: const BoxDecoration(
        color: Color(0xFF8B5CF6),
        shape: BoxShape.circle,
      ),
    ).animate(onPlay: (controller) => controller.repeat())
     .moveY(begin: 0, end: -10, duration: 600.ms, curve: Curves.easeInOut, delay: delayMs.ms)
     .then()
     .moveY(begin: -10, end: 0, duration: 600.ms, curve: Curves.easeInOut);
  }
}
