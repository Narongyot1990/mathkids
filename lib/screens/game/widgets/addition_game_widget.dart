import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/responsive_helper.dart';
import '../../../core/assets/game_emojis.dart';
import '../../../widgets/modern_answer_button.dart';
import '../../../widgets/game_3d_widget.dart';
import 'base_game_widget.dart';

/// New Addition Game Widget - Visual addition with combining animations
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
    
    // Responsive sizing
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    final iconSize = ResponsiveHelper.iconSize(context);
    final gameSize = ResponsiveHelper.gameWidgetSize(
      context, 
      aspectRatio: isMobile ? 1.0 : (isTablet ? 1.2 : 1.5),
    );

    // Gradient based on feedback
    final gradientColors = isCorrect == true
        ? [Colors.green.shade100, Colors.teal.shade50]
        : isCorrect == false
            ? [Colors.red.shade50, Colors.orange.shade50]
            : [Colors.green.shade50, Colors.blue.shade50];

    return Game3DWidget(
      autoRotate: false, // Simplified for better UX
      enableRotation: false,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        width: gameSize.width,
        height: gameSize.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradientColors,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Question Display
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(iconSize * 0.3),
                child: _buildVisualAddition(
                  context, 
                  operand1, 
                  operand2, 
                  iconSize,
                ),
              ),
            ),
            
            // Result indicator (shown after answer)
            if (isCorrect != null)
              _buildResultIndicator(isCorrect!),
          ],
        ),
      ),
    );
  }

  Widget _buildVisualAddition(BuildContext context, int operand1, int operand2, double iconSize) {
    final emoji = GameEmojis.counting.getByIndex(operand1 + operand2);
    
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Group 1 + Group 2 = ?
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // First group
            _buildEmojiGroup(
              count: operand1,
              emoji: emoji,
              size: iconSize,
              label: '+$operand1',
              labelColor: AppColors.primaryGreen,
            ),
            
            // Plus sign
            Padding(
              padding: EdgeInsets.symmetric(horizontal: iconSize * 0.3),
              child: _buildOperatorCard('+', AppColors.primaryGreen),
            ),
            
            // Second group
            _buildEmojiGroup(
              count: operand2,
              emoji: emoji,
              size: iconSize,
              label: '+$operand2',
              labelColor: AppColors.primaryBlue,
            ),
            
            // Equals sign
            Padding(
              padding: EdgeInsets.symmetric(horizontal: iconSize * 0.3),
              child: _buildOperatorCard('=', AppColors.primaryOrange),
            ),
            
            // Answer box (or question mark)
            _buildAnswerBox(iconSize),
          ],
        ),
        
        SizedBox(height: iconSize * 0.5),
        
        // Operation text
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: iconSize * 0.8,
            vertical: iconSize * 0.2,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(iconSize * 0.4),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            '$operand1 + $operand2 = ?',
            style: AppTypography.custom(
              fontSize: iconSize * 0.5,
              fontWeight: AppTypography.weightBold,
              color: AppColors.primaryGreen,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmojiGroup({
    required int count,
    required String emoji,
    required double size,
    required String label,
    required Color labelColor,
  }) {
    return Column(
      children: [
        // Label
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: size * 0.3,
            vertical: size * 0.1,
          ),
          decoration: BoxDecoration(
            color: labelColor.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(size * 0.2),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: size * 0.25,
              fontWeight: FontWeight.bold,
              color: labelColor,
            ),
          ),
        ),
        SizedBox(height: size * 0.15),
        
        // Emojis grid
        Container(
          constraints: BoxConstraints(
            maxWidth: size * 2.5,
            maxHeight: size * 2.0,
          ),
          child: Wrap(
            alignment: WrapAlignment.center,
            spacing: size * 0.05,
            runSpacing: size * 0.05,
            children: List.generate(count, (index) {
              return TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: Duration(milliseconds: 300 + (index * 50)),
                curve: Curves.elasticOut,
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: value,
                    child: Opacity(
                      opacity: value,
                      child: Text(
                        emoji,
                        style: TextStyle(fontSize: size * 0.7),
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildOperatorCard(String operator, Color color) {
    return Container(
      width: 45,
      height: 45,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.4),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Center(
        child: Text(
          operator,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildAnswerBox(double size) {
    final showResult = isCorrect != null;
    final isAnswerCorrect = isCorrect == true;
    
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 1.0, end: showResult ? 1.1 : 1.0),
      duration: const Duration(milliseconds: 500),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Container(
            width: size * 1.2,
            height: size * 1.2,
            decoration: BoxDecoration(
              color: showResult 
                  ? (isAnswerCorrect ? AppColors.primaryGreen : AppColors.error)
                  : AppColors.primaryYellow,
              shape: BoxShape.circle,
              border: Border.all(
                color: showResult 
                    ? (isAnswerCorrect ? AppColors.primaryGreen : AppColors.error)
                    : AppColors.primaryOrange,
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: (showResult 
                      ? (isAnswerCorrect ? AppColors.primaryGreen : AppColors.error)
                      : AppColors.primaryYellow).withValues(alpha: 0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Text(
                showResult ? '${question.correctAnswer}' : '?',
                style: TextStyle(
                  fontSize: size * 0.5,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildResultIndicator(bool isCorrect) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 600),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.scale(
            scale: value,
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              decoration: BoxDecoration(
                color: isCorrect ? AppColors.primaryGreen : AppColors.error,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isCorrect ? Icons.check_circle : Icons.cancel,
                    color: Colors.white,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    isCorrect ? 'ถูกต้อง! 🎉' : 'ลองใหม่นะ 💪',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget buildAnswerOptions(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: ModernAnswerButtonGrid(
        key: ValueKey(question.questionText),
        options: question.options,
        correctAnswer: question.correctAnswer,
        isCorrect: isCorrect,
        isProcessing: isProcessingAnswer,
        onAnswer: onAnswer,
        gameType: gameType,
      ),
    );
  }
}
