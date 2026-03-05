import 'package:flutter/material.dart';
import '../../../data/models/question.dart';
import '../../../data/models/game_type.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

/// Base interface for all game widgets
/// Each game type implements this to provide its own UI/layout
abstract class BaseGameWidget extends StatelessWidget {
  final Question question;
  final GameType gameType;
  final Difficulty difficulty;
  final bool? isCorrect;
  final bool isProcessingAnswer; // ป้องกันการตอบซ้ำ
  final Function(int answer) onAnswer;

  const BaseGameWidget({
    super.key,
    required this.question,
    required this.gameType,
    required this.difficulty,
    required this.isCorrect,
    this.isProcessingAnswer = false,
    required this.onAnswer,
  });

  /// Build the game question display (numbers, images, etc.)
  Widget buildQuestionDisplay(BuildContext context);

  /// Build the answer options (buttons, drag-drop, etc.)
  Widget buildAnswerOptions(BuildContext context);

  /// Build any additional UI elements (animations, effects, etc.)
  Widget buildAdditionalUI(BuildContext context) {
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Question text - ลด padding เพื่อประหยัดพื้นที่
        Padding(
          padding: AppSpacing.paddingAllSmall,
          child: Text(
            question.questionText,
            style: AppTypography.gameQuestion,
            textAlign: TextAlign.center,
          ),
        ),

        AppSpacing.verticalSpaceSmall, // ลดจาก Normal เป็น Small

        // Game-specific question display - เพิ่ม flex เพื่อให้ยืดหยุ่น
        Expanded(
          flex: 3, // เพิ่มจาก 2 เป็น 3
          child: buildQuestionDisplay(context),
        ),

        AppSpacing.verticalSpaceSmall, // ลดจาก Normal เป็น Small

        // Game-specific answer options - ใช้ Flexible แทน widget ธรรมดาเพื่อป้องกัน overflow
        Flexible(
          fit: FlexFit.loose,
          child: buildAnswerOptions(context),
        ),

        AppSpacing.verticalSpaceTiny, // ลดจาก Normal เป็น Tiny

        // Additional UI (animations, effects)
        buildAdditionalUI(context),
      ],
    );
  }
}
