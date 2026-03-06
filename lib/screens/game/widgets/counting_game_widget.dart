import 'package:flutter/material.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/utils/responsive_helper.dart';
import '../../../ui/painters/objects_3d_painter.dart';
import '../../../widgets/modern_answer_button.dart';
import '../../../widgets/game_3d_widget.dart';
import 'base_game_widget.dart';

class CountingGameWidget extends BaseGameWidget {
  const CountingGameWidget({
    super.key,
    required super.question,
    required super.gameType,
    required super.difficulty,
    required super.isCorrect,
    super.isProcessingAnswer,
    required super.onAnswer,
  });

  @override
  Widget buildQuestionDisplay(BuildContext context) {
    final count = question.imageCount ?? 0;
    
    // Get responsive size
    final gameSize = ResponsiveHelper.gameWidgetSize(context, aspectRatio: 16 / 9);
    final iconSize = ResponsiveHelper.iconSize(context);
    final fontSize = ResponsiveHelper.fontSize(context, 12);

    return Game3DWidget(
      autoRotate: true,
      enableRotation: true,
      child: Container(
        width: gameSize.width,
        height: gameSize.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.green.shade50,
              Colors.blue.shade50,
            ],
          ),
        ),
        child: Stack(
          children: [
            Objects3DPainter(
              count: count,
              selectedAnswer: isCorrect != null ? question.correctAnswer : null,
              correctAnswer: question.correctAnswer,
              showFeedback: isCorrect != null,
            ),
            // Responsive mascot position
            Mascot3D(
              mascot: '🦊',
              x: gameSize.width - 70, // 10% from right
              y: 10,
            ),
            Positioned(
              bottom: 8,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: fontSize * 1.2,
                    vertical: fontSize * 0.4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(fontSize),
                  ),
                  child: Text(
                    'ลากเพื่อหมุน 🔄',
                    style: TextStyle(
                      fontSize: fontSize,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget buildAnswerOptions(BuildContext context) {
    return ModernAnswerButtonGrid(
      options: question.options,
      correctAnswer: question.correctAnswer,
      isCorrect: isCorrect,
      isProcessing: isProcessingAnswer,
      onAnswer: onAnswer,
      gameType: gameType,
    );
  }
}
