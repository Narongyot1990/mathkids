import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/assets/game_emojis.dart';

class MathOperationPainter extends CustomPainter {
  final int operand1;
  final int operand2;
  final String operation;
  final int? selectedAnswer;
  final int? correctAnswer;
  final bool showResult;

  MathOperationPainter({
    required this.operand1,
    required this.operand2,
    required this.operation,
    this.selectedAnswer,
    this.correctAnswer,
    required this.showResult,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final emojiIndex = (operand1 + operand2 + operation.hashCode) % GameEmojis.mathOperation.all.length;
    final emoji = GameEmojis.mathOperation.getByIndex(emojiIndex);

    if (operation == '+') {
      _paintAddition(canvas, size, emoji);
    } else {
      _paintSubtraction(canvas, size, emoji);
    }
  }

  void _paintAddition(Canvas canvas, Size size, String emoji) {
    final random = Random(operand1 + operand2);
    const padding = 40.0;
    final centerY = size.height / 2;
    
    _drawBackgroundCircle(canvas, size, AppColors.additionGameBackground);
    
    final group1Positions = _generateCirclePositions(
      canvas, size, padding, centerY, operand1, random, false,
    );
    
    for (final pos in group1Positions) {
      _drawEmojiWithBounce(
        canvas, emoji, pos.x, pos.y, pos.size, pos.rotation,
        AppColors.primaryGreen.withValues(alpha: 0.1),
      );
    }
    
    _drawOperator(canvas, '+', size.width / 2, centerY, 50);
    
    final group2StartX = size.width / 2 + 50;
    final group2Positions = _generateCirclePositions(
      canvas, size, group2StartX, centerY, operand2, random, true,
    );
    
    for (final pos in group2Positions) {
      _drawEmojiWithBounce(
        canvas, emoji, pos.x, pos.y, pos.size, pos.rotation,
        AppColors.primaryOrange.withValues(alpha: 0.1),
      );
    }
    
    _drawEquals(canvas, size.width - 60, centerY);
    
    if (showResult && correctAnswer != null) {
      _drawAnswerCircle(canvas, size.width - 35, centerY, '$correctAnswer');
    }
    
    _drawMascot(canvas, size, '🐼', 50, size.height - 40);
  }

  void _paintSubtraction(Canvas canvas, Size size, String emoji) {
    final random = Random(operand1 - operand2);
    const padding = 30.0;
    final centerY = size.height / 2;
    
    _drawBackgroundCircle(canvas, size, AppColors.subtractionGameBackground);
    
    final positions = _generateCirclePositions(
      canvas, size, padding + 50, centerY, operand1, random, false,
    );
    
    for (int i = 0; i < positions.length; i++) {
      final pos = positions[i];
      final shouldCross = i >= operand1 - operand2;
      
      if (shouldCross) {
        _drawEmojiWithBounce(
          canvas, emoji, pos.x, pos.y, pos.size, pos.rotation,
          AppColors.error.withValues(alpha: 0.15),
        );
        if (showResult) {
          _drawCrossOut(canvas, pos.x, pos.y, pos.size * 0.6);
        }
      } else {
        _drawEmojiWithBounce(
          canvas, emoji, pos.x, pos.y, pos.size, pos.rotation,
          AppColors.primaryGreen.withValues(alpha: 0.15),
        );
      }
    }
    
    _drawOperator(canvas, '-', size.width / 2 - 20, centerY, 45);
    
    _drawAnswerCircle(canvas, size.width / 2 + 30, centerY, showResult && correctAnswer != null ? '$correctAnswer' : '?');
    
    _drawMascot(canvas, size, '🐨', size.width - 50, size.height - 30);
  }

  List<_CirclePos> _generateCirclePositions(
    Canvas canvas, Size size, double startX, double centerY, 
    int count, Random random, bool isRight,
  ) {
    final positions = <_CirclePos>[];
    final baseRadius = 35.0;
    final spread = count <= 3 ? 25.0 : 40.0;
    
    for (int i = 0; i < count; i++) {
      final angle = (i / max(count - 1, 1)) * pi - (pi / 2);
      final radiusAdjustment = (random.nextDouble() - 0.5) * spread;
      final radius = baseRadius + radiusAdjustment;
      
      final x = startX + (isRight ? 30 : 0) + cos(angle) * radius * (count > 1 ? 1 : 0);
      final y = centerY + sin(angle) * radius * 0.6;
      
      final sizeVariation = 0.85 + random.nextDouble() * 0.3;
      final rotation = (random.nextDouble() - 0.5) * 0.4;
      
      positions.add(_CirclePos(x, y, 45 * sizeVariation, rotation));
    }
    
    return positions;
  }

  void _drawBackgroundCircle(Canvas canvas, Size size, Gradient gradient) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final paint = Paint()..shader = LinearGradient(
      colors: [
        Colors.white.withValues(alpha: 0.9),
        Colors.white.withValues(alpha: 0.7),
      ],
    ).createShader(rect);
    
    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(10, 10, size.width - 20, size.height - 20),
      const Radius.circular(24),
    );
    canvas.drawRRect(rrect, paint);
  }

  void _drawEmojiWithBounce(Canvas canvas, String emoji, double x, double y, double size, double rotation, Color glowColor) {
    canvas.save();
    canvas.translate(x, y);
    canvas.rotate(rotation);
    
    final glowPaint = Paint()
      ..color = glowColor
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
    canvas.drawCircle(Offset.zero, size * 0.8, glowPaint);
    
    final bgPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset.zero, size * 0.6, bgPaint);
    
    final textPainter = TextPainter(
      text: TextSpan(text: emoji, style: TextStyle(fontSize: size)),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(-textPainter.width / 2, -textPainter.height / 2),
    );
    
    canvas.restore();
  }

  void _drawOperator(Canvas canvas, String op, double x, double y, double size) {
    final bgPaint = Paint()
      ..color = op == '+' ? AppColors.primaryGreen : AppColors.primaryOrange
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(Offset(x, y), size * 0.5, bgPaint);
    
    final textPainter = TextPainter(
      text: TextSpan(
        text: op,
        style: TextStyle(
          fontSize: size,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(x - textPainter.width / 2, y - textPainter.height / 2),
    );
  }

  void _drawEquals(Canvas canvas, double x, double y) {
    final paint = Paint()
      ..color = AppColors.primaryBlue
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    
    canvas.drawLine(
      Offset(x - 12, y - 8),
      Offset(x + 12, y - 8),
      paint,
    );
    canvas.drawLine(
      Offset(x - 12, y + 8),
      Offset(x + 12, y + 8),
      paint,
    );
  }

  void _drawAnswerCircle(Canvas canvas, double x, double y, String answer) {
    final bgPaint = Paint()
      ..color = AppColors.primaryYellow
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(Offset(x, y), 30, bgPaint);
    
    final borderPaint = Paint()
      ..color = AppColors.primaryOrange
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawCircle(Offset(x, y), 30, borderPaint);
    
    final textPainter = TextPainter(
      text: TextSpan(
        text: answer,
        style: const TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: AppColors.primaryOrange,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(x - textPainter.width / 2, y - textPainter.height / 2),
    );
  }

  void _drawCrossOut(Canvas canvas, double x, double y, double size) {
    final paint = Paint()
      ..color = AppColors.error
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    
    canvas.drawLine(
      Offset(x - size * 0.5, y - size * 0.5),
      Offset(x + size * 0.5, y + size * 0.5),
      paint,
    );
    canvas.drawLine(
      Offset(x + size * 0.5, y - size * 0.5),
      Offset(x - size * 0.5, y + size * 0.5),
      paint,
    );
  }

  void _drawMascot(Canvas canvas, Size size, String mascot, double x, double y) {
    final textPainter = TextPainter(
      text: TextSpan(text: mascot, style: const TextStyle(fontSize: 50)),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(x - textPainter.width / 2, y - textPainter.height / 2),
    );
  }

  @override
  bool shouldRepaint(covariant MathOperationPainter oldDelegate) {
    return oldDelegate.operand1 != operand1 ||
        oldDelegate.operand2 != operand2 ||
        oldDelegate.selectedAnswer != selectedAnswer ||
        oldDelegate.showResult != showResult;
  }
}

class _CirclePos {
  final double x;
  final double y;
  final double size;
  final double rotation;
  
  _CirclePos(this.x, this.y, this.size, this.rotation);
}
