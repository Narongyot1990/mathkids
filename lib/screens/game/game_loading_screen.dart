import 'package:flutter/material.dart';
import 'dart:async';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';

/// Game Loading Screen
/// แสดงภาพ loading ก่อนเข้าเกม
class GameLoadingScreen extends StatefulWidget {
  final VoidCallback onLoadingComplete;

  const GameLoadingScreen({
    super.key,
    required this.onLoadingComplete,
  });

  @override
  State<GameLoadingScreen> createState() => _GameLoadingScreenState();
}

class _GameLoadingScreenState extends State<GameLoadingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();

    // Animation controller
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _rotationAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    );

    // Simulate loading (1.5 seconds)
    Timer(const Duration(milliseconds: 1500), () {
      if (mounted) {
        _controller.stop();
        widget.onLoadingComplete();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.loadingGradient,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated emoji
            AnimatedBuilder(
              animation: _scaleAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: child,
                );
              },
              child: const Text(
                '🎮',
                style: TextStyle(fontSize: 100),
              ),
            ),
            AppSpacing.verticalSpaceLarge,

            // Loading text
            Text(
              'กำลังโหลดเกม...',
              style: AppTypography.heading2.copyWith(
                color: AppColors.textLight,
              ),
            ),
            AppSpacing.verticalSpaceNormal,

            // Animated loading indicator
            AnimatedBuilder(
              animation: _rotationAnimation,
              builder: (context, child) {
                return RotationTransition(
                  turns: _rotationAnimation,
                  child: child,
                );
              },
              child: const SizedBox(
                width: 50,
                height: 50,
                child: CircularProgressIndicator(
                  strokeWidth: 4,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.textLight),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
