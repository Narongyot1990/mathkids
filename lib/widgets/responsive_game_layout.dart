import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_sizes.dart';
import '../core/theme/app_typography.dart';

/// Responsive Game Layout - เลย์เอาต์เกมที่ปรับขนาดตามหน้าจอ
class ResponsiveGameLayout extends StatelessWidget {
  final int score;
  final int currentQuestion;
  final int totalQuestions;
  final Widget questionWidget;
  final Widget? answerWidget; // Optional - บางเกมมี answer อยู่ใน questionWidget แล้ว
  final Gradient? gradient;
  final VoidCallback? onBackPressed;

  const ResponsiveGameLayout({
    super.key,
    required this.score,
    required this.currentQuestion,
    required this.totalQuestions,
    required this.questionWidget,
    this.answerWidget,
    this.gradient,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    final scaleFactor = AppSizes.getScaleFactor(context);

    return Container(
      decoration: BoxDecoration(
        gradient: gradient ?? AppColors.backgroundGradient,
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Score Bar พร้อมปุ่ม Back - ใช้ fixed height เพื่อป้องกัน overflow
            _buildScoreBar(context, 55.0, scaleFactor), // แก้จาก screenHeight * 0.10 เป็น fixed 55px

            // Game Content - ขยายเต็มพื้นที่ที่เหลือ
            Expanded(
              child: Padding(
                padding: AppSizes.scaledPadding(
                  context,
                  const EdgeInsets.all(16),
                ),
                child: Column(
                  children: [
                    // Question Widget (อาจรวม answers ด้วย)
                    Expanded(child: questionWidget),

                    // Answer Widget (ถ้ามี - สำหรับเกมที่แยก UI)
                    if (answerWidget != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: answerWidget!,
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreBar(BuildContext context, double height, double scale) {
    return Container(
      height: height,
      padding: AppSizes.scaledPadding(
        context,
        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back Button
          if (onBackPressed != null)
            _buildBackButton(context, scale)
          else
            const SizedBox(width: 48), // Placeholder

          // Score display
          _buildScoreItem(
            context: context,
            icon: '⭐',
            value: '$score',
            scale: scale,
          ),

          // Progress display
          _buildScoreItem(
            context: context,
            icon: '📝',
            value: '$currentQuestion/$totalQuestions',
            scale: scale,
          ),

          const SizedBox(width: 48), // Balance with back button
        ],
      ),
    );
  }

  Widget _buildBackButton(BuildContext context, double scale) {
    return GestureDetector(
      onTap: onBackPressed,
      child: Container(
        width: 40 * scale,
        height: 40 * scale,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.25),
          borderRadius: BorderRadius.circular(12 * scale),
          boxShadow: [
            BoxShadow(
              color: Colors.white.withValues(alpha: 0.3),
              offset: const Offset(-1, -1),
              blurRadius: 2,
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              offset: const Offset(1, 1),
              blurRadius: 4,
            ),
          ],
        ),
        child: Icon(
          Icons.arrow_back_ios_new,
          color: Colors.white,
          size: 20 * scale,
        ),
      ),
    );
  }

  Widget _buildScoreItem({
    required BuildContext context,
    required String icon,
    required String value,
    required double scale,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 12 * scale,
        vertical: 6 * scale,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(12 * scale),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            icon,
            style: TextStyle(fontSize: AppSizes.scaledFontSize(context, 20)),
          ),
          SizedBox(width: 6 * scale),
          Text(
            value,
            style: TextStyle(
              fontSize: AppSizes.scaledFontSize(context, 18),
              color: Colors.white,
              fontWeight: AppTypography.weightBold,
              shadows: [
                Shadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  offset: const Offset(0, 1),
                  blurRadius: 2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Responsive Question Text - ข้อความคำถามที่ปรับขนาดอัตโนมัติ
class ResponsiveQuestionText extends StatelessWidget {
  final String text;
  final double baseFontSize;

  const ResponsiveQuestionText({
    super.key,
    required this.text,
    this.baseFontSize = 48,
  });

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Text(
        text,
        style: TextStyle(
          fontSize: AppSizes.scaledFontSize(context, baseFontSize),
          fontWeight: AppTypography.weightBold,
          color: AppColors.textDark,
          shadows: [
            Shadow(
              color: Colors.white.withValues(alpha: 0.5),
              offset: const Offset(-1, -1),
              blurRadius: 2,
            ),
            Shadow(
              color: Colors.black.withValues(alpha: 0.2),
              offset: const Offset(2, 2),
              blurRadius: 4,
            ),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

/// Responsive Emoji Display - แสดง emoji ขนาดใหญ่
class ResponsiveEmojiDisplay extends StatelessWidget {
  final String emoji;
  final int count;
  final double baseSize;

  const ResponsiveEmojiDisplay({
    super.key,
    required this.emoji,
    this.count = 1,
    this.baseSize = 64,
  });

  @override
  Widget build(BuildContext context) {
    final size = AppSizes.scale(context, baseSize);

    // ถ้ามีหลาย emoji ให้แสดงแบบ wrap
    if (count > 1) {
      return Wrap(
        spacing: 8,
        runSpacing: 8,
        alignment: WrapAlignment.center,
        children: List.generate(
          count,
          (index) => Text(
            emoji,
            style: TextStyle(
              fontSize: size,
              shadows: [
                Shadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  offset: const Offset(0, 2),
                  blurRadius: 4,
                ),
              ],
            ),
          ),
        ),
      );
    }

    // ถ้ามี emoji เดียว
    return Text(
      emoji,
      style: TextStyle(
        fontSize: size,
        shadows: [
          Shadow(
            color: Colors.black.withValues(alpha: 0.1),
            offset: const Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
    );
  }
}
