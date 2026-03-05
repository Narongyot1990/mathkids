import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/assets/game_emojis.dart';

class MathOperation3DPainter extends StatelessWidget {
  final int operand1;
  final int operand2;
  final String operation;
  final int? correctAnswer;
  final bool showResult;
  final double rotationX;
  final double rotationY;

  const MathOperation3DPainter({
    super.key,
    required this.operation,
    required this.operand1,
    required this.operand2,
    this.correctAnswer,
    this.showResult = false,
    this.rotationX = 0,
    this.rotationY = 0,
  });

  @override
  Widget build(BuildContext context) {
    if (operation == '+') {
      return _buildAddition(context);
    } else {
      return _buildSubtraction(context);
    }
  }

  Widget _buildAddition(BuildContext context) {
    final random = Random(operand1 + operand2);
    final emojiIndex = (operand1 + operand2) % GameEmojis.mathOperation.all.length;
    final emoji = GameEmojis.mathOperation.getByIndex(emojiIndex);
    
    final group1Items = <_EmojiData>[];
    final group2Items = <_EmojiData>[];
    
    for (int i = 0; i < operand1; i++) {
      group1Items.add(_EmojiData(
        emoji: emoji,
        x: 30 + random.nextDouble() * 80,
        y: 40 + random.nextDouble() * 120,
        size: 40 + random.nextDouble() * 15,
        layerDepth: random.nextDouble(),
      ));
    }
    
    for (int i = 0; i < operand2; i++) {
      group2Items.add(_EmojiData(
        emoji: emoji,
        x: 180 + random.nextDouble() * 80,
        y: 40 + random.nextDouble() * 120,
        size: 40 + random.nextDouble() * 15,
        layerDepth: random.nextDouble(),
      ));
    }

    return Stack(
      children: [
        for (final item in group1Items)
          _buildEmojiLayer(item),
        for (final item in group2Items)
          _buildEmojiLayer(item),
        _buildOperator('+', 145, 100),
        _buildEquals(250, 100),
        if (showResult && correctAnswer != null)
          _buildAnswerBox('$correctAnswer', 300, 100),
      ],
    );
  }

  Widget _buildSubtraction(BuildContext context) {
    final random = Random(operand1 - operand2);
    final emojiIndex = (operand1 + operand2) % GameEmojis.mathOperation.all.length;
    final emoji = GameEmojis.mathOperation.getByIndex(emojiIndex);
    
    final items = <_EmojiData>[];
    
    for (int i = 0; i < operand1; i++) {
      final isCrossed = i >= operand1 - operand2;
      items.add(_EmojiData(
        emoji: emoji,
        x: 40 + (i % 4) * 60,
        y: 40 + (i ~/ 4) * 60,
        size: 40,
        layerDepth: random.nextDouble(),
        isCrossed: isCrossed && showResult,
      ));
    }

    return Stack(
      children: [
        for (final item in items)
          _buildEmojiLayer(item),
        _buildOperator('-', 180, 100),
        _buildAnswerBox(showResult && correctAnswer != null ? '$correctAnswer' : '?', 250, 100),
      ],
    );
  }

  Widget _buildEmojiLayer(_EmojiData data) {
    final offsetX = rotationY * data.layerDepth * 50;
    final offsetY = rotationX * data.layerDepth * 50;
    final scale = 0.5 + (data.layerDepth * 0.5);
    final opacity = 0.3 + (data.layerDepth * 0.7);

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 300 + (data.layerDepth * 300).toInt()),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Positioned(
          left: data.x + offsetX,
          top: data.y + offsetY,
          child: Transform.scale(
            scale: scale * value,
            child: Opacity(
              opacity: opacity,
              child: data.isCrossed
                  ? Stack(
                      children: [
                        Text(
                          data.emoji,
                          style: TextStyle(
                            fontSize: data.size,
                            color: Colors.grey,
                          ),
                        ),
                        Positioned(
                          left: data.size * 0.1,
                          top: data.size * 0.1,
                          child: Icon(
                            Icons.close,
                            color: AppColors.error,
                            size: data.size * 0.8,
                          ),
                        ),
                      ],
                    )
                  : Text(
                      data.emoji,
                      style: TextStyle(fontSize: data.size),
                    ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildOperator(String op, double x, double y) {
    final offsetX = rotationY * 30;
    final offsetY = rotationX * 30;

    return Positioned(
      left: x + offsetX,
      top: y + offsetY,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: op == '+' ? AppColors.primaryGreen : AppColors.primaryOrange,
          boxShadow: [
            BoxShadow(
              color: (op == '+' ? AppColors.primaryGreen : AppColors.primaryOrange)
                  .withValues(alpha: 0.4),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Text(
            op,
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEquals(double x, double y) {
    final offsetX = rotationY * 20;
    final offsetY = rotationX * 20;

    return Positioned(
      left: x + offsetX,
      top: y + offsetY - 15,
      child: Row(
        children: List.generate(2, (i) => Container(
          width: 20,
          height: 4,
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            color: AppColors.primaryBlue,
            borderRadius: BorderRadius.circular(2),
          ),
        )),
      ),
    );
  }

  Widget _buildAnswerBox(String answer, double x, double y) {
    final offsetX = rotationY * 25;
    final offsetY = rotationX * 25;

    return Positioned(
      left: x + offsetX,
      top: y + offsetY,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: 1),
        duration: const Duration(milliseconds: 500),
        curve: Curves.elasticOut,
        builder: (context, value, child) {
          return Transform.scale(
            scale: value,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryYellow,
                border: Border.all(color: AppColors.primaryOrange, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryYellow.withValues(alpha: 0.4),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  answer,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryOrange,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _EmojiData {
  final String emoji;
  final double x;
  final double y;
  final double size;
  final double layerDepth;
  final bool isCrossed;

  _EmojiData({
    required this.emoji,
    required this.x,
    required this.y,
    required this.size,
    required this.layerDepth,
    this.isCrossed = false,
  });
}

class Mascot3DOperator extends StatefulWidget {
  final String mascot;
  final double x;
  final double y;
  final double rotationY;

  const Mascot3DOperator({
    super.key,
    required this.mascot,
    required this.x,
    required this.y,
    this.rotationY = 0,
  });

  @override
  State<Mascot3DOperator> createState() => _Mascot3DOperatorState();
}

class _Mascot3DOperatorState extends State<Mascot3DOperator>
    with SingleTickerProviderStateMixin {
  late AnimationController _bounceController;

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _bounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final offsetX = widget.rotationY * 20;

    return AnimatedBuilder(
      animation: _bounceController,
      builder: (context, child) {
        final bounceY = sin(_bounceController.value * pi) * 4;
        
        return Positioned(
          left: widget.x + offsetX,
          top: widget.y + bounceY,
          child: Text(
            widget.mascot,
            style: const TextStyle(fontSize: 45),
          ),
        );
      },
    );
  }
}
