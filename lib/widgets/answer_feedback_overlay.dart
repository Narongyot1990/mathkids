import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';

/// Answer Feedback Overlay
/// แสดง animation เมื่อตอบคำถามถูกหรือผิด
/// เหมาะสำหรับเด็ก 3-6 ขวบ ด้วยสีสันและ animation ที่น่าสนใจ
class AnswerFeedbackOverlay extends StatefulWidget {
  final bool isCorrect;
  final VoidCallback onComplete;

  const AnswerFeedbackOverlay({
    super.key,
    required this.isCorrect,
    required this.onComplete,
  });

  @override
  State<AnswerFeedbackOverlay> createState() => _AnswerFeedbackOverlayState();
}

class _AnswerFeedbackOverlayState extends State<AnswerFeedbackOverlay>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _bounceController;
  late AnimationController _particleController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();

    // Scale animation (ขยายใหญ่)
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _scaleAnimation = CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    );

    // Bounce animation (กระดอน)
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _bounceAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.bounceOut),
    );

    // Particle animation (ดาว/ฟองสบู่ กระจาย)
    _particleController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    // เริ่ม animation
    _scaleController.forward();
    _bounceController.forward();
    _particleController.forward();

    // ปิด overlay หลังจาก animation เสร็จ
    Future.delayed(const Duration(milliseconds: 1400), () {
      if (mounted) {
        widget.onComplete();
      }
    });
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _bounceController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          // Background overlay (โปร่งใส)
          Container(
            color: widget.isCorrect
                ? AppColors.success.withValues(alpha: 0.1)
                : AppColors.error.withValues(alpha: 0.1),
          ),

          // Particles (ถ้าตอบถูก)
          if (widget.isCorrect)
            AnimatedBuilder(
              animation: _particleController,
              builder: (context, child) {
                return CustomPaint(
                  painter: ParticlePainter(
                    progress: _particleController.value,
                    isCorrect: widget.isCorrect,
                  ),
                  size: Size.infinite,
                );
              },
            ),

          // Center feedback
          Center(
            child: AnimatedBuilder(
              animation: Listenable.merge([_scaleAnimation, _bounceAnimation]),
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Transform.translate(
                    offset: Offset(
                      0,
                      -50 * (1 - _bounceAnimation.value),
                    ),
                    child: child,
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 48,
                  vertical: 32,
                ),
                decoration: BoxDecoration(
                  gradient: widget.isCorrect
                      ? AppColors.successGradient
                      : AppColors.errorGradient,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    // 3D Shadow effect
                    BoxShadow(
                      color: Colors.white.withValues(alpha: 0.3),
                      offset: const Offset(-2, -2),
                      blurRadius: 6,
                    ),
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      offset: const Offset(4, 6),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Emoji
                    Text(
                      widget.isCorrect ? '🎉' : '💪',
                      style: const TextStyle(fontSize: 80),
                    ),
                    const SizedBox(height: 16),

                    // Text
                    Text(
                      widget.isCorrect ? 'เก่งมาก!' : 'ลองอีกครั้ง!',
                      style: AppTypography.displayLarge.copyWith(
                        color: AppColors.textLight,
                        fontSize: 36,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Sub text
                    Text(
                      widget.isCorrect
                          ? 'ยอดเยี่ยมเลย 🌟'
                          : 'ไม่เป็นไรนะ ลองใหม่ได้',
                      style: AppTypography.bodyLarge.copyWith(
                        color: AppColors.textLight.withValues(alpha: 0.9),
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Custom Painter สำหรับวาด particles (ดาว, ฟองสบู่)
class ParticlePainter extends CustomPainter {
  final double progress;
  final bool isCorrect;

  ParticlePainter({
    required this.progress,
    required this.isCorrect,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (!isCorrect) return;

    final centerX = size.width / 2;
    final centerY = size.height / 2;

    // วาด particles (20 ดวง)
    for (int i = 0; i < 20; i++) {
      final angle = (i / 20) * 2 * math.pi;
      final distance = progress * 200; // กระจายออกไป 200px
      final x = centerX + math.cos(angle) * distance;
      final y = centerY + math.sin(angle) * distance;

      // ขนาดและความโปร่งแสงลดลงตามเวลา
      final opacity = (1 - progress).clamp(0.0, 1.0);
      final size = 8.0 * (1 - progress * 0.5);

      final paint = Paint()
        ..color = _getParticleColor(i).withValues(alpha: opacity)
        ..style = PaintingStyle.fill;

      // วาดดาว
      _drawStar(canvas, Offset(x, y), size, paint);
    }
  }

  void _drawStar(Canvas canvas, Offset center, double size, Paint paint) {
    final path = Path();
    const points = 5;
    const angle = math.pi / points;

    for (int i = 0; i < points * 2; i++) {
      final radius = i.isEven ? size : size / 2;
      final x = center.dx + radius * math.cos(i * angle - math.pi / 2);
      final y = center.dy + radius * math.sin(i * angle - math.pi / 2);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  Color _getParticleColor(int index) {
    final colors = [
      AppColors.gameStar,
      AppColors.primaryOrange,
      AppColors.primaryYellow,
      AppColors.primaryGreen,
      AppColors.primaryBlue,
    ];
    return colors[index % colors.length];
  }

  @override
  bool shouldRepaint(ParticlePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
