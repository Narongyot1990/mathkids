import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/assets/game_emojis.dart';

/// Custom painter for drawing comparison game
/// Shows two groups of objects side-by-side for comparing quantities
class ComparisonPainter extends CustomPainter {
  final int leftCount;
  final int rightCount;

  ComparisonPainter({
    required this.leftCount,
    required this.rightCount,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const emojiSize = 40.0;
    const spacing = 50.0;

    // เลือก emoji จาก GameEmojis
    final random = Random(leftCount + rightCount);
    final leftEmojiIndex = random.nextInt(GameEmojis.comparison.all.length);
    final rightEmojiIndex = (leftEmojiIndex + 1) % GameEmojis.comparison.all.length;
    final leftEmoji = GameEmojis.comparison.getByIndex(leftEmojiIndex);
    final rightEmoji = GameEmojis.comparison.getByIndex(rightEmojiIndex);

    final centerX = size.width / 2;
    final centerY = size.height / 2;

    // วาดกลุ่มซ้าย
    final leftStartX = centerX * 0.3;
    final leftCols = (leftCount <= 4) ? 2 : 3;
    for (int i = 0; i < leftCount; i++) {
      final row = i ~/ leftCols;
      final col = i % leftCols;
      final x = leftStartX + (col * spacing);
      final y = centerY - (leftCols * spacing / 4) + (row * spacing);
      _drawEmoji(canvas, leftEmoji, Offset(x, y), emojiSize);
    }

    // วาดเส้นแบ่งกลาง
    final paint = Paint()
      ..color = AppColors.grey400
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    canvas.drawLine(
      Offset(centerX, centerY - 100),
      Offset(centerX, centerY + 100),
      paint,
    );

    // วาดกลุ่มขวา
    final rightStartX = centerX + (centerX * 0.4);
    final rightCols = (rightCount <= 4) ? 2 : 3;
    for (int i = 0; i < rightCount; i++) {
      final row = i ~/ rightCols;
      final col = i % rightCols;
      final x = rightStartX + (col * spacing);
      final y = centerY - (rightCols * spacing / 4) + (row * spacing);
      _drawEmoji(canvas, rightEmoji, Offset(x, y), emojiSize);
    }
  }

  void _drawEmoji(Canvas canvas, String emoji, Offset position, double size) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: emoji,
        style: TextStyle(fontSize: size),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        position.dx - textPainter.width / 2,
        position.dy - textPainter.height / 2,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant ComparisonPainter oldDelegate) {
    return oldDelegate.leftCount != leftCount ||
        oldDelegate.rightCount != rightCount;
  }
}
