import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/assets/game_emojis.dart';
import '../../core/theme/app_colors.dart';

class ObjectsPainter extends CustomPainter {
  final int count;
  final int? selectedAnswer;
  final int? correctAnswer;
  final bool showFeedback;

  ObjectsPainter({
    required this.count,
    this.selectedAnswer,
    this.correctAnswer,
    this.showFeedback = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final random = Random(count * 42);
    final emoji = GameEmojis.counting.getByIndex(count);
    
    const padding = 30.0;
    final availableWidth = size.width - (padding * 2);
    final availableHeight = size.height - (padding * 2);
    
    final emojiSize = (availableWidth / 4).clamp(45.0, 70.0);
    
    final positions = <_EmojiPosition>[];
    
    for (int i = 0; i < count; i++) {
      double x, y;
      int attempts = 0;
      
      do {
        x = padding + random.nextDouble() * (availableWidth - emojiSize);
        y = padding + random.nextDouble() * (availableHeight - emojiSize);
        attempts++;
      } while (_isOverlapping(x, y, positions, emojiSize * 0.6) && attempts < 50);
      
      final rotation = (random.nextDouble() - 0.5) * 0.3;
      final scale = 0.8 + random.nextDouble() * 0.4;
      
      positions.add(_EmojiPosition(x, y, rotation, scale));
    }
    
    for (final pos in positions) {
      _drawEmojiWithGlow(
        canvas, 
        emoji, 
        pos.x + emojiSize / 2, 
        pos.y + emojiSize / 2, 
        emojiSize * pos.scale,
        pos.rotation,
      );
    }
    
    _drawMascot(canvas, size, emojiSize);
    
    if (showFeedback && selectedAnswer != null && correctAnswer != null) {
      if (selectedAnswer! < correctAnswer!) {
        _drawMissingItems(canvas, size, correctAnswer! - count, emoji, emojiSize, positions);
      }
    }
  }

  void _drawEmojiWithGlow(Canvas canvas, String emoji, double x, double y, double size, double rotation) {
    canvas.save();
    canvas.translate(x, y);
    canvas.rotate(rotation);
    
    final glowPaint = Paint()
      ..color = AppColors.primaryYellow.withValues(alpha: 0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    canvas.drawCircle(Offset.zero, size * 0.7, glowPaint);
    
    final textPainter = TextPainter(
      text: TextSpan(
        text: emoji,
        style: TextStyle(fontSize: size * 1.2),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(-textPainter.width / 2, -textPainter.height / 2),
    );
    
    canvas.restore();
  }

  void _drawMascot(Canvas canvas, Size size, double emojiSize) {
    final mascotX = size.width - emojiSize * 0.8;
    final mascotY = emojiSize * 0.5;
    
    final textPainter = TextPainter(
      text: TextSpan(
        text: '🦊',
        style: TextStyle(fontSize: emojiSize * 1.0),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(mascotX - textPainter.width / 2, mascotY - textPainter.height / 2),
    );
    
    final speechX = mascotX - emojiSize * 0.5;
    final speechY = mascotY - emojiSize * 0.3;
    _drawSpeechBubble(canvas, speechX, speechY, '$count');
  }

  void _drawSpeechBubble(Canvas canvas, double x, double y, String text) {
    final bubblePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    
    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.2)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
    
    final bubbleRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(x, y), width: 50, height: 40),
      const Radius.circular(12),
    );
    canvas.drawRRect(bubbleRect.shift(const Offset(2, 2)), shadowPaint);
    canvas.drawRRect(bubbleRect, bubblePaint);
    
    final tailPath = Path()
      ..moveTo(x - 5, y + 15)
      ..lineTo(x + 5, y + 25)
      ..lineTo(x + 15, y + 15)
      ..close();
    canvas.drawPath(tailPath, bubblePaint);
    
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.primaryBlue,
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

  void _drawMissingItems(Canvas canvas, Size size, int missing, String emoji, double emojiSize, List<_EmojiPosition> existing) {
    final random = Random(missing * 100);
    final positions = <_EmojiPosition>[];
    
    for (int i = 0; i < missing; i++) {
      double x, y;
      int attempts = 0;
      
      do {
        x = 30 + random.nextDouble() * (size.width - 60 - emojiSize);
        y = 30 + random.nextDouble() * (size.height - 60 - emojiSize);
        attempts++;
      } while (_isOverlapping(x, y, positions, emojiSize * 0.6) || 
               _isOverlappingAny(x, y, existing, emojiSize * 0.8) &&
               attempts < 30);
      
      positions.add(_EmojiPosition(x, y, 0, 0.6));
    }
    
    for (final pos in positions) {
      final textPainter = TextPainter(
        text: TextSpan(
          text: emoji,
          style: TextStyle(fontSize: emojiSize * 0.7),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      
      final overlayPaint = Paint()
        ..color = Colors.black.withValues(alpha: 0.5);
      canvas.drawCircle(
        Offset(pos.x + emojiSize * 0.35, pos.y + emojiSize * 0.35),
        emojiSize * 0.4,
        overlayPaint,
      );
      
      textPainter.paint(canvas, Offset(pos.x, pos.y));
    }
  }

  bool _isOverlapping(double x, double y, List<_EmojiPosition> positions, double minDistance) {
    for (final pos in positions) {
      final dx = x - pos.x;
      final dy = y - pos.y;
      if (sqrt(dx * dx + dy * dy) < minDistance) {
        return true;
      }
    }
    return false;
  }

  bool _isOverlappingAny(double x, double y, List<_EmojiPosition> positions, double minDistance) {
    for (final pos in positions) {
      final dx = x - pos.x;
      final dy = y - pos.y;
      if (sqrt(dx * dx + dy * dy) < minDistance) {
        return true;
      }
    }
    return false;
  }

  @override
  bool shouldRepaint(covariant ObjectsPainter oldDelegate) {
    return oldDelegate.count != count ||
        oldDelegate.selectedAnswer != selectedAnswer ||
        oldDelegate.correctAnswer != correctAnswer ||
        oldDelegate.showFeedback != showFeedback;
  }
}

class _EmojiPosition {
  final double x;
  final double y;
  final double rotation;
  final double scale;

  _EmojiPosition(this.x, this.y, this.rotation, this.scale);
}
