import 'package:flutter/material.dart';
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
    
    // Get responsive sizes
    final gameSize = ResponsiveHelper.gameWidgetSize(context, aspectRatio: 16 / 9);
    final fontSize = ResponsiveHelper.fontSize(context, 12);
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    // Calculate mascot position based on screen size
    final mascotX = isMobile 
        ? gameSize.width - 50 
        : isTablet 
            ? gameSize.width - 70 
            : gameSize.width - 90;
    final mascotY = isMobile ? 5.0 : 10.0;

    // Enhanced gradient for counting - blue tones
    final gradientColors = isCorrect == true
        ? [Colors.green.shade100, Colors.teal.shade100]
        : isCorrect == false
            ? [Colors.red.shade50, Colors.orange.shade50]
            : [Colors.blue.shade50, Colors.cyan.shade50];

    return Game3DWidget(
      autoRotate: isMobile ? false : true,
      enableRotation: !isMobile,
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
        child: Stack(
          children: [
            // Main objects display
            Objects3DPainter(
              count: count,
              selectedAnswer: isCorrect != null ? question.correctAnswer : null,
              correctAnswer: question.correctAnswer,
              showFeedback: isCorrect != null,
            ),
            
            // Animated mascot with better positioning
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutBack,
              right: isMobile ? 8 : 15,
              top: mascotY,
              child: Mascot3D(
                mascot: '🦊',
                x: mascotX,
                y: mascotY,
                size: isMobile ? 35.0 : isTablet ? 40.0 : 50.0,
              ),
            ),
            
            // Hint text - hidden on mobile to save space
            if (!isMobile)
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
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
              
            // Result feedback animation
            if (isCorrect != null)
              Positioned.fill(
                child: _buildFeedbackOverlay(isCorrect!),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeedbackOverlay(bool isCorrect) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 600),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Container(
          color: isCorrect 
              ? Colors.green.withValues(alpha: 0.1 * value)
              : Colors.red.withValues(alpha: 0.1 * value),
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
