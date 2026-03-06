import 'package:flutter/material.dart';
import '../../../core/utils/responsive_helper.dart';
import '../../../ui/painters/math_operation_3d_painter.dart';
import '../../../widgets/modern_answer_button.dart';
import '../../../widgets/game_3d_widget.dart';
import 'base_game_widget.dart';

class AdditionGameWidget extends BaseGameWidget {
  const AdditionGameWidget({
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
    final operand1 = question.operand1 ?? 0;
    final operand2 = question.operand2 ?? 0;
    
    // Get responsive size
    final gameSize = ResponsiveHelper.gameWidgetSize(context, aspectRatio: 16 / 9);
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
              Colors.teal.shade50,
            ],
          ),
        ),
        child: Stack(
          children: [
            MathOperation3DPainter(
              operation: '+',
              operand1: operand1,
              operand2: operand2,
              correctAnswer: question.correctAnswer,
              showResult: isCorrect != null,
            ),
            Mascot3DOperator(
              mascot: '🐼',
              x: gameSize.width - 60,
              y: gameSize.height - 80,
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
