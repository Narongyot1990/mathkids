import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_sizes.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_typography.dart';

class KidButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final double? width;
  final IconData? icon;

  const KidButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.width,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = AppSizes.isSmallScreen(context);
    final buttonWidth = width ?? screenWidth * 0.7;
    final maxWidth = screenWidth - (AppSpacing.md * 2); // 16px padding on each side

    return SizedBox(
      width: buttonWidth > maxWidth ? maxWidth : buttonWidth,
      height: isSmallScreen ? 60 : 70,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? Theme.of(context).colorScheme.primary,
          foregroundColor: AppColors.textLight,
          elevation: AppSizes.elevationButton,
          shadowColor: AppColors.shadow,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(isSmallScreen ? 30 : 35),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: isSmallScreen ? AppSpacing.md : AppSpacing.lg,
            vertical: isSmallScreen ? AppSpacing.xs : AppSpacing.sm,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: isSmallScreen ? 24 : 28),
              SizedBox(width: isSmallScreen ? AppSpacing.xs : AppSpacing.sm),
            ],
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: isSmallScreen ? 20 : 24,
                    fontWeight: AppTypography.weightBold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
