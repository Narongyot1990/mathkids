import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../core/theme/app_colors.dart';

/// Playful Background Widget
/// พื้นหลังน่ารักสำหรับเด็ก พร้อมลวดลายเล่นสนุก
class PlayfulBackground extends StatelessWidget {
  final Widget child;
  final Gradient? gradient;
  final bool showFloatingEmojis;
  final bool showStars;
  final bool showClouds;

  const PlayfulBackground({
    super.key,
    required this.child,
    this.gradient,
    this.showFloatingEmojis = false,
    this.showStars = true,
    this.showClouds = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: gradient ?? AppColors.backgroundGradient,
      ),
      child: Stack(
        children: [
          // Decorative patterns
          if (showStars)
            Positioned.fill(
              child: CustomPaint(
                painter: StarsPainter(),
              ),
            ),
          if (showClouds)
            Positioned.fill(
              child: CustomPaint(
                painter: CloudsPainter(),
              ),
            ),
          if (showFloatingEmojis)
            Positioned.fill(
              child: CustomPaint(
                painter: FloatingEmojisPainter(),
              ),
            ),

          // Main content
          child,
        ],
      ),
    );
  }
}

/// Stars Painter - วาดดาวเล็กๆ กระจายทั่ว
class StarsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill;

    final random = math.Random(42); // Fixed seed for consistent pattern

    // วาดดาว 30 ดวง
    for (int i = 0; i < 30; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final starSize = 3.0 + random.nextDouble() * 4; // 3-7px
      final opacity = 0.1 + random.nextDouble() * 0.2; // 10-30% opacity

      paint.color = Colors.white.withValues(alpha: opacity);
      _drawStar(canvas, Offset(x, y), starSize, paint);
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

  @override
  bool shouldRepaint(StarsPainter oldDelegate) => false;
}

/// Clouds Painter - วาดเมขสีขาวน่ารัก
class CloudsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.15)
      ..style = PaintingStyle.fill;

    // วาดเมฆ 5 ก้อน
    _drawCloud(canvas, Offset(size.width * 0.15, size.height * 0.1), 60, paint);
    _drawCloud(canvas, Offset(size.width * 0.75, size.height * 0.15), 50, paint);
    _drawCloud(canvas, Offset(size.width * 0.3, size.height * 0.85), 55, paint);
    _drawCloud(canvas, Offset(size.width * 0.85, size.height * 0.8), 45, paint);
    _drawCloud(canvas, Offset(size.width * 0.5, size.height * 0.5), 40, paint);
  }

  void _drawCloud(Canvas canvas, Offset center, double size, Paint paint) {
    // เมฆประกอบด้วยวงกลม 5 วง
    canvas.drawCircle(center, size * 0.5, paint);
    canvas.drawCircle(center.translate(-size * 0.4, size * 0.1), size * 0.4, paint);
    canvas.drawCircle(center.translate(size * 0.4, size * 0.1), size * 0.4, paint);
    canvas.drawCircle(center.translate(-size * 0.2, -size * 0.2), size * 0.35, paint);
    canvas.drawCircle(center.translate(size * 0.2, -size * 0.2), size * 0.35, paint);
  }

  @override
  bool shouldRepaint(CloudsPainter oldDelegate) => false;
}

/// Floating Emojis Painter - วาด emoji ลอยอยู่ในพื้นหลัง
class FloatingEmojisPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final emojis = ['⭐', '🌟', '✨', '💫', '🎈', '🎨', '🎯'];
    final random = math.Random(42);

    final textStyle = const TextStyle(
      fontSize: 24,
    );

    // วาด emoji 15 ตัว
    for (int i = 0; i < 15; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final emoji = emojis[random.nextInt(emojis.length)];
      final opacity = 0.1 + random.nextDouble() * 0.15; // 10-25% opacity

      final textPainter = TextPainter(
        text: TextSpan(
          text: emoji,
          style: textStyle.copyWith(
            color: Colors.white.withValues(alpha: opacity),
          ),
        ),
        textDirection: TextDirection.ltr,
      );

      textPainter.layout();
      textPainter.paint(canvas, Offset(x, y));
    }
  }

  @override
  bool shouldRepaint(FloatingEmojisPainter oldDelegate) => false;
}

/// Animated Playful Background - มี animation เคลื่อนไหว + Particle Emitter
class AnimatedPlayfulBackground extends StatefulWidget {
  final Widget child;
  final Gradient? gradient;
  final bool showParticles;

  const AnimatedPlayfulBackground({
    super.key,
    required this.child,
    this.gradient,
    this.showParticles = true,
  });

  @override
  State<AnimatedPlayfulBackground> createState() => _AnimatedPlayfulBackgroundState();
}

class _AnimatedPlayfulBackgroundState extends State<AnimatedPlayfulBackground>
    with TickerProviderStateMixin {
  late AnimationController _starController;
  late AnimationController _cloudController;
  late AnimationController _particleController;

  @override
  void initState() {
    super.initState();

    // Star twinkle animation
    _starController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();

    // Cloud floating animation - ช้าๆ ลอยไป-มา
    _cloudController = AnimationController(
      duration: const Duration(seconds: 30),
      vsync: this,
    )..repeat();

    // Particle emitter animation
    _particleController = AnimationController(
      duration: const Duration(seconds: 15),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _starController.dispose();
    _cloudController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: widget.gradient ?? AppColors.backgroundGradient,
      ),
      child: Stack(
        children: [
          // Animated stars
          AnimatedBuilder(
            animation: _starController,
            builder: (context, child) {
              return CustomPaint(
                painter: AnimatedStarsPainter(progress: _starController.value),
                size: Size.infinite,
              );
            },
          ),

          // Floating clouds with animation
          AnimatedBuilder(
            animation: _cloudController,
            builder: (context, child) {
              return CustomPaint(
                painter: FloatingCloudsPainter(progress: _cloudController.value),
                size: Size.infinite,
              );
            },
          ),

          // Particle emitter (ดาว, หัวใจ, ดอกไม้ลอย)
          if (widget.showParticles)
            AnimatedBuilder(
              animation: _particleController,
              builder: (context, child) {
                return CustomPaint(
                  painter: ParticleEmitterPainter(progress: _particleController.value),
                  size: Size.infinite,
                );
              },
            ),

          // Main content
          widget.child,
        ],
      ),
    );
  }
}

/// Animated Stars Painter - ดาวที่กระพริบ
class AnimatedStarsPainter extends CustomPainter {
  final double progress;

  AnimatedStarsPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill;

    final random = math.Random(42);

    for (int i = 0; i < 30; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final starSize = 3.0 + random.nextDouble() * 4;

      // Twinkle effect - แต่ละดาวกระพริบในจังหวะที่ต่างกัน
      final twinkle = math.sin(progress * 2 * math.pi + i * 0.5);
      final opacity = (0.1 + (twinkle + 1) * 0.1).clamp(0.0, 0.3);

      paint.color = Colors.white.withValues(alpha: opacity);
      _drawStar(canvas, Offset(x, y), starSize, paint);
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

  @override
  bool shouldRepaint(AnimatedStarsPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

/// Floating Clouds Painter - เมฆที่ลอยขึ้น-ลง
class FloatingCloudsPainter extends CustomPainter {
  final double progress;

  FloatingCloudsPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.15)
      ..style = PaintingStyle.fill;

    // เมฆ 5 ก้อน ลอยขึ้น-ลง และซ้าย-ขวา
    final clouds = [
      {'x': 0.15, 'y': 0.1, 'size': 60.0, 'speed': 1.0},
      {'x': 0.75, 'y': 0.15, 'size': 50.0, 'speed': 1.3},
      {'x': 0.3, 'y': 0.85, 'size': 55.0, 'speed': 0.8},
      {'x': 0.85, 'y': 0.8, 'size': 45.0, 'speed': 1.1},
      {'x': 0.5, 'y': 0.5, 'size': 40.0, 'speed': 0.9},
    ];

    for (var cloud in clouds) {
      final baseX = size.width * (cloud['x'] as double);
      final baseY = size.height * (cloud['y'] as double);
      final cloudSize = cloud['size'] as double;
      final speed = cloud['speed'] as double;

      // Floating animation - ขึ้น-ลง
      final floatY = math.sin(progress * 2 * math.pi * speed) * 15;
      // Horizontal drift - ซ้าย-ขวา
      final driftX = math.cos(progress * 2 * math.pi * speed * 0.5) * 10;

      final center = Offset(baseX + driftX, baseY + floatY);
      _drawCloud(canvas, center, cloudSize, paint);
    }
  }

  void _drawCloud(Canvas canvas, Offset center, double size, Paint paint) {
    // เมฆประกอบด้วยวงกลม 5 วง
    canvas.drawCircle(center, size * 0.5, paint);
    canvas.drawCircle(center.translate(-size * 0.4, size * 0.1), size * 0.4, paint);
    canvas.drawCircle(center.translate(size * 0.4, size * 0.1), size * 0.4, paint);
    canvas.drawCircle(center.translate(-size * 0.2, -size * 0.2), size * 0.35, paint);
    canvas.drawCircle(center.translate(size * 0.2, -size * 0.2), size * 0.35, paint);
  }

  @override
  bool shouldRepaint(FloatingCloudsPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

/// Particle Emitter Painter - ปล่อยอนุภาคน่ารักๆ
class ParticleEmitterPainter extends CustomPainter {
  final double progress;

  ParticleEmitterPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final particles = [
      {'emoji': '⭐', 'color': const Color(0xFFFFD700)},
      {'emoji': '💫', 'color': const Color(0xFF87CEEB)},
      {'emoji': '✨', 'color': const Color(0xFFFFE5B4)},
      {'emoji': '🌟', 'color': const Color(0xFFFFDAB9)},
      {'emoji': '💖', 'color': const Color(0xFFFFB6C1)},
      {'emoji': '🎈', 'color': const Color(0xFFFF69B4)},
      {'emoji': '🌸', 'color': const Color(0xFFFFDADA)},
      {'emoji': '🦋', 'color': const Color(0xFFE0BBE4)},
    ];

    final random = math.Random(123);

    // สร้าง 20 particles
    for (int i = 0; i < 20; i++) {
      final particle = particles[i % particles.length];
      final particleProgress = (progress + i * 0.05) % 1.0;

      // ตำแหน่ง x แบบสุ่ม (คงที่สำหรับแต่ละ particle)
      final seedX = random.nextDouble();
      final x = size.width * seedX;

      // ลอยขึ้นจากล่างไปบน
      final y = size.height * (1.0 - particleProgress);

      // Wave motion - โยกซ้าย-ขวา
      final wave = math.sin(particleProgress * math.pi * 4 + i) * 20;
      final finalX = x + wave;

      // ค่อยๆ จางหาย
      final opacity = particleProgress < 0.8 ? 0.3 : (1.0 - particleProgress) * 1.5;

      if (opacity > 0 && y >= 0 && y <= size.height) {
        final textStyle = TextStyle(
          fontSize: 16 + random.nextDouble() * 8, // 16-24px
          color: (particle['color'] as Color).withValues(alpha: opacity.clamp(0.0, 0.3)),
        );

        final textPainter = TextPainter(
          text: TextSpan(
            text: particle['emoji'] as String,
            style: textStyle,
          ),
          textDirection: TextDirection.ltr,
        );

        textPainter.layout();
        textPainter.paint(canvas, Offset(finalX, y));
      }
    }
  }

  @override
  bool shouldRepaint(ParticleEmitterPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
