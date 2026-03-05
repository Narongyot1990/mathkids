import 'package:flutter/material.dart';
import '../data/models/game_type.dart';
import '../screens/stage_select/stage_select_screen.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_sizes.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_typography.dart';

/// Game Card Widget
/// แสดงการ์ดเกมพร้อม emoji และชื่อ
/// ใช้ใน Carousel หรือ Grid
class GameCard extends StatelessWidget {
  final GameType gameType;
  final double? width;
  final double? height;
  final bool isCenter; // การ์ดตรงกลางใน carousel

  const GameCard({
    super.key,
    required this.gameType,
    this.width,
    this.height,
    this.isCenter = false,
  });

  /// Get gradient for specific game type
  Gradient _getGradientForGameType() {
    switch (gameType) {
      case GameType.counting:
        return AppColors.countingCardGradient;
      case GameType.addition:
        return AppColors.additionCardGradient;
      case GameType.subtraction:
        return AppColors.subtractionCardGradient;
      case GameType.comparison:
        return AppColors.comparisonCardGradient;
      case GameType.sequence:
        return AppColors.sequenceCardGradient;
      case GameType.mathGrid:
        return AppColors.mathGridCardGradient;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Responsive sizes - mobile first
    final isSmallScreen = AppSizes.isSmallScreen(context);

    // ขนาดการ์ด (ตรงกลางใหญ่กว่า) - scaled for small screens
    final baseWidth = isSmallScreen ? 200.0 : 240.0;
    final baseCenterWidth = isSmallScreen ? 240.0 : 280.0;
    final baseHeight = isSmallScreen ? 240.0 : 280.0;
    final baseCenterHeight = isSmallScreen ? 280.0 : 320.0;

    final cardWidth = width ?? (isCenter ? baseCenterWidth : baseWidth);
    final cardHeight = height ?? (isCenter ? baseCenterHeight : baseHeight);
    final emojiSize = isCenter
        ? (isSmallScreen ? 64.0 : 80.0)
        : (isSmallScreen ? 48.0 : 60.0);
    final fontSize = isCenter
        ? (isSmallScreen ? 22.0 : 26.0)
        : (isSmallScreen ? 18.0 : 22.0);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      width: cardWidth,
      height: cardHeight,
      child: Card(
        elevation: 0, // Remove default shadow, we'll use custom 3D shadow
        shape: RoundedRectangleBorder(
          borderRadius: AppSizes.borderRadiusXl,
        ),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => StageSelectScreen(gameType: gameType),
              ),
            );
          },
          borderRadius: AppSizes.borderRadiusXl,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: AppSizes.borderRadiusXl,
              gradient: _getGradientForGameType(),
              // Modern 3D Shadow Effect
              boxShadow: [
                // Top-left light shadow (3D highlight)
                BoxShadow(
                  color: Colors.white.withValues(alpha: isCenter ? 0.4 : 0.3),
                  offset: const Offset(-3, -3),
                  blurRadius: isCenter ? 8 : 6,
                ),
                // Bottom-right dark shadow (3D depth)
                BoxShadow(
                  color: Colors.black.withValues(alpha: isCenter ? 0.25 : 0.2),
                  offset: Offset(isCenter ? 6 : 4, isCenter ? 8 : 6),
                  blurRadius: isCenter ? 16 : 12,
                  spreadRadius: isCenter ? 2 : 1,
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Emoji with subtle shadow
                Container(
                  padding: EdgeInsets.all(isCenter ? 12 : 8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.15),
                  ),
                  child: Text(
                    gameType.emoji,
                    style: TextStyle(
                      fontSize: emojiSize,
                      shadows: [
                        Shadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          offset: const Offset(0, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                ),
                AppSpacing.verticalSpaceSmall,

                // Game Name with text shadow
                Padding(
                  padding: AppSpacing.paddingHorizontalSmall,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      gameType.displayName,
                      style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: AppTypography.weightBold,
                        color: AppColors.textLight,
                        shadows: [
                          Shadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            offset: const Offset(0, 2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
