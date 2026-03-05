import 'package:flutter/material.dart';
import '../../../ui/painters/comparison_painter.dart';
import '../../../widgets/modern_answer_button.dart';
import '../../../widgets/game_3d_widget.dart';
import 'base_game_widget.dart';

class ComparisonGameWidget extends BaseGameWidget {
  const ComparisonGameWidget({
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
    final leftCount = question.leftCount ?? 0;
    final rightCount = question.rightCount ?? 0;

    return Game3DWidget(
      autoRotate: true,
      enableRotation: true,
      child: Container(
        width: 400,
        height: 280,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.purple.shade50,
              Colors.pink.shade50,
            ],
          ),
        ),
        child: Stack(
          children: [
            CustomPaint(
              size: const Size(400, 280),
              painter: ComparisonPainter(
                leftCount: leftCount,
                rightCount: rightCount,
              ),
            ),
            Positioned(
              bottom: 8,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'ลากเพื่อหมุน 🔄',
                    style: TextStyle(
                      fontSize: 12,
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
      displayTextBuilder: (option) => ['<', '=', '>'][option],
    );
  }
}
