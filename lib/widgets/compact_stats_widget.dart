import 'package:flutter/material.dart';
import '../data/models/kid_stats.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_sizes.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_typography.dart';

/// Compact Stats Widget - Redesigned (Beautiful & Clean)
/// แสดงสถิติหลักๆ 4 ตัวแบบสวยงาม มีพื้นที่หายใจ
class CompactStatsWidget extends StatelessWidget {
  final KidStats stats;

  const CompactStatsWidget({
    super.key,
    required this.stats,
  });

  @override
  Widget build(BuildContext context) {
    // Mobile-first responsive design
    final isSmallScreen = AppSizes.isSmallScreen(context);

    return Container(
      margin: EdgeInsets.fromLTRB(
        isSmallScreen ? AppSpacing.sm : AppSpacing.md,
        0,
        isSmallScreen ? AppSpacing.sm : AppSpacing.md,
        isSmallScreen ? AppSpacing.sm : AppSpacing.md
      ),
      padding: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? AppSpacing.md : AppSpacing.lg,
        vertical: isSmallScreen ? AppSpacing.md : AppSpacing.lg,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppSizes.borderRadiusMd,
        boxShadow: AppSizes.shadowMd,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // 4 main stats with equal spacing
          Expanded(
            child: _buildSimpleStat(
              context,
              '🎮',
              '${stats.totalGamesPlayed}',
              'เกม',
              AppColors.statsGames,
            ),
          ),
          Expanded(
            child: _buildSimpleStat(
              context,
              '🎯',
              '${stats.accuracyRate.toStringAsFixed(0)}%',
              'ถูก',
              _getAccuracyColor(stats.accuracyRate),
            ),
          ),
          Expanded(
            child: _buildSimpleStat(
              context,
              '⭐',
              '${stats.totalStars}',
              'ดาว',
              AppColors.statsScore,
            ),
          ),
          Expanded(
            child: _buildSimpleStat(
              context,
              '🔥',
              '${stats.playStreak}',
              'ติดต่อ',
              AppColors.statsTime,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSimpleStat(
    BuildContext context,
    String emoji,
    String value,
    String label,
    Color color,
  ) {
    final isSmallScreen = AppSizes.isSmallScreen(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(emoji, style: TextStyle(fontSize: isSmallScreen ? 24 : 32)),
        SizedBox(height: isSmallScreen ? 4 : 6),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            value,
            style: TextStyle(
              fontSize: isSmallScreen ? 18 : 22,
              fontWeight: AppTypography.weightBold,
              color: color,
            ),
            maxLines: 1,
          ),
        ),
        SizedBox(height: isSmallScreen ? 2 : 4),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            label,
            style: TextStyle(
              fontSize: isSmallScreen ? 11 : 13,
              color: AppColors.grey600,
              fontWeight: AppTypography.weightMedium,
            ),
            maxLines: 1,
          ),
        ),
      ],
    );
  }

  Color _getAccuracyColor(double accuracy) {
    if (accuracy >= 90) return AppColors.statsAccuracy;
    if (accuracy >= 70) return AppColors.statsTime;
    if (accuracy >= 50) return AppColors.statsScore;
    return AppColors.error;
  }
}
