import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../core/theme/app_colors.dart';

/// Confetti Animation
/// Animation ดอกไม้ไฟสำหรับเวลาผ่านด่าน
/// เหมาะสำหรับเด็ก 3-6 ขวบ
class ConfettiAnimation extends StatefulWidget {
  final Widget child;
  final bool isPlaying;

  const ConfettiAnimation({
    super.key,
    required this.child,
    this.isPlaying = false,
  });

  @override
  State<ConfettiAnimation> createState() => _ConfettiAnimationState();
}

class _ConfettiAnimationState extends State<ConfettiAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<ConfettiParticle> _particles = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    if (widget.isPlaying) {
      _startConfetti();
    }
  }

  @override
  void didUpdateWidget(ConfettiAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPlaying && !oldWidget.isPlaying) {
      _startConfetti();
    }
  }

  void _startConfetti() {
    _particles.clear();
    final random = math.Random();

    // สร้าง particles 50 ชิ้น
    for (int i = 0; i < 50; i++) {
      _particles.add(ConfettiParticle(
        x: random.nextDouble(),
        y: -0.1,
        vx: (random.nextDouble() - 0.5) * 0.5,
        vy: random.nextDouble() * 0.3 + 0.2,
        rotation: random.nextDouble() * 2 * math.pi,
        rotationSpeed: (random.nextDouble() - 0.5) * 0.2,
        color: _getRandomColor(random),
        shape: random.nextInt(3), // 0: square, 1: circle, 2: triangle
      ));
    }

    _controller.forward(from: 0);
  }

  Color _getRandomColor(math.Random random) {
    final colors = [
      AppColors.gameStar,
      AppColors.primaryPink,
      AppColors.primaryBlue,
      AppColors.primaryGreen,
      AppColors.primaryYellow,
      AppColors.primaryOrange,
      AppColors.primaryPurple,
    ];
    return colors[random.nextInt(colors.length)];
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (widget.isPlaying)
          Positioned.fill(
            child: IgnorePointer(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return CustomPaint(
                    painter: ConfettiPainter(
                      particles: _particles,
                      progress: _controller.value,
                    ),
                  );
                },
              ),
            ),
          ),
      ],
    );
  }
}

class ConfettiParticle {
  double x; // 0-1 (ตำแหน่ง x เป็น ratio)
  double y; // 0-1 (ตำแหน่ง y เป็น ratio)
  final double vx; // ความเร็ว x
  final double vy; // ความเร็ว y
  double rotation;
  final double rotationSpeed;
  final Color color;
  final int shape;

  ConfettiParticle({
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    required this.rotation,
    required this.rotationSpeed,
    required this.color,
    required this.shape,
  });
}

class ConfettiPainter extends CustomPainter {
  final List<ConfettiParticle> particles;
  final double progress;

  ConfettiPainter({
    required this.particles,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particles) {
      // คำนวณตำแหน่งใหม่
      final x = (particle.x + particle.vx * progress) * size.width;
      final y = (particle.y + particle.vy * progress) * size.height;
      final rotation = particle.rotation + particle.rotationSpeed * progress * 10;

      // ความโปร่งแสงลดลงเมื่อใกล้จบ animation
      final opacity = (1 - progress * 0.7).clamp(0.0, 1.0);
      final paint = Paint()
        ..color = particle.color.withValues(alpha: opacity)
        ..style = PaintingStyle.fill;

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(rotation);

      // วาดรูปร่างตามประเภท
      switch (particle.shape) {
        case 0: // Square
          canvas.drawRect(
            const Rect.fromLTWH(-4, -4, 8, 8),
            paint,
          );
          break;
        case 1: // Circle
          canvas.drawCircle(Offset.zero, 4, paint);
          break;
        case 2: // Triangle
          final path = Path()
            ..moveTo(0, -6)
            ..lineTo(5, 4)
            ..lineTo(-5, 4)
            ..close();
          canvas.drawPath(path, paint);
          break;
      }

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(ConfettiPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
