import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../core/theme/app_colors.dart';

/// Rotating Icon Widget with Gradient Border
/// ไอคอนหมุน 360 องศา พร้อม border gradient สวยงาม
class RotatingIconWidget extends StatefulWidget {
  final String emoji;
  final double size;
  final Gradient? borderGradient;
  final double borderWidth;
  final Duration rotationDuration;
  final bool continuousRotation;

  const RotatingIconWidget({
    super.key,
    required this.emoji,
    this.size = 80.0,
    this.borderGradient,
    this.borderWidth = 4.0,
    this.rotationDuration = const Duration(seconds: 3),
    this.continuousRotation = true,
  });

  @override
  State<RotatingIconWidget> createState() => _RotatingIconWidgetState();
}

class _RotatingIconWidgetState extends State<RotatingIconWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.rotationDuration,
      vsync: this,
    );

    if (widget.continuousRotation) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.rotate(
          angle: _controller.value * 2 * math.pi,
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: widget.borderGradient ?? AppColors.rainbowGradient,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Container(
              margin: EdgeInsets.all(widget.borderWidth),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: Center(
                child: Transform.rotate(
                  angle: -_controller.value * 2 * math.pi, // Counter-rotate emoji
                  child: Text(
                    widget.emoji,
                    style: TextStyle(fontSize: widget.size * 0.5),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Pulsing Icon Widget - ไอคอนเต้นแบบ pulse
class PulsingIconWidget extends StatefulWidget {
  final String emoji;
  final double size;
  final Gradient? gradient;

  const PulsingIconWidget({
    super.key,
    required this.emoji,
    this.size = 100.0,
    this.gradient,
  });

  @override
  State<PulsingIconWidget> createState() => _PulsingIconWidgetState();
}

class _PulsingIconWidgetState extends State<PulsingIconWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(
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
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: widget.gradient ?? AppColors.rainbowGradient,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 15,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Center(
              child: Text(
                widget.emoji,
                style: TextStyle(fontSize: widget.size * 0.6),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Floating Icon Widget - ไอคอนลอยขึ้นลง
class FloatingIconWidget extends StatefulWidget {
  final String emoji;
  final double size;
  final Color? backgroundColor;
  final Gradient? gradient;

  const FloatingIconWidget({
    super.key,
    required this.emoji,
    this.size = 80.0,
    this.backgroundColor,
    this.gradient,
  });

  @override
  State<FloatingIconWidget> createState() => _FloatingIconWidgetState();
}

class _FloatingIconWidgetState extends State<FloatingIconWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _offsetAnimation = Tween<double>(begin: -10.0, end: 10.0).animate(
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
    return AnimatedBuilder(
      animation: _offsetAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _offsetAnimation.value),
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: widget.gradient,
              color: widget.backgroundColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Center(
              child: Text(
                widget.emoji,
                style: TextStyle(fontSize: widget.size * 0.6),
              ),
            ),
          ),
        );
      },
    );
  }
}
