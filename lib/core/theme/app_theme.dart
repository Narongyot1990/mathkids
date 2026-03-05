import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';
import 'app_sizes.dart';
import 'app_spacing.dart';

/// App Theme - ใช้ Design Token System
///
/// Theme หลักของแอพที่รวม:
/// - Colors (AppColors)
/// - Typography (AppTypography)
/// - Sizes (AppSizes)
/// - Spacing (AppSpacing)
class AppTheme {
  AppTheme._(); // Private constructor

  // ========================================
  // Export constants for backward compatibility
  // (จะค่อยๆ ลบออกเมื่อ refactor เสร็จ)
  // ========================================
  static const primaryBlue = AppColors.primaryBlue;
  static const primaryPink = AppColors.primaryPink;
  static const primaryYellow = AppColors.primaryYellow;
  static const primaryGreen = AppColors.primaryGreen;
  static const primaryOrange = AppColors.primaryOrange;
  static const primaryPurple = AppColors.primaryPurple;

  static const backgroundLight = AppColors.backgroundLight;
  static const backgroundSky = AppColors.backgroundSky;

  static const textPrimary = AppColors.textPrimary;
  static const textSecondary = AppColors.textSecondary;

  static const successGreen = AppColors.success;
  static const errorRed = AppColors.error;

  // ========================================
  // Light Theme
  // ========================================
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,

    // Color Scheme
    colorScheme: ColorScheme.light(
      primary: AppColors.primaryBlue,
      secondary: AppColors.primaryPink,
      tertiary: AppColors.primaryYellow,
      surface: AppColors.surface,
      surfaceContainerHighest: AppColors.surfaceVariant,
      onPrimary: AppColors.textLight,
      onSecondary: AppColors.textLight,
      onSurface: AppColors.textPrimary,
      error: AppColors.error,
      onError: AppColors.textLight,
      outline: AppColors.outline,
      shadow: AppColors.shadow,
    ),

    // Typography
    textTheme: TextTheme(
      // Display
      displayLarge: AppTypography.displayLarge,
      displayMedium: AppTypography.displayMedium,
      displaySmall: AppTypography.displaySmall,

      // Headline
      headlineLarge: AppTypography.heading1,
      headlineMedium: AppTypography.heading2,
      headlineSmall: AppTypography.heading3,

      // Title
      titleLarge: AppTypography.heading3,
      titleMedium: AppTypography.heading4,
      titleSmall: AppTypography.labelLarge,

      // Body
      bodyLarge: AppTypography.bodyLarge,
      bodyMedium: AppTypography.bodyMedium,
      bodySmall: AppTypography.bodySmall,

      // Label
      labelLarge: AppTypography.labelLarge,
      labelMedium: AppTypography.labelMedium,
      labelSmall: AppTypography.labelSmall,
    ),

    // Button Theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: AppSizes.elevationButton,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.buttonPaddingHorizontal,
          vertical: AppSpacing.buttonPaddingVertical,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: AppSizes.borderRadiusButton,
        ),
        textStyle: AppTypography.buttonLarge,
      ),
    ),

    // Card Theme
    cardTheme: CardThemeData(
      elevation: AppSizes.elevationCard,
      shape: RoundedRectangleBorder(
        borderRadius: AppSizes.borderRadiusCard,
      ),
      color: AppColors.surface,
    ),

    // AppBar Theme
    appBarTheme: AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: AppColors.primaryBlue,
      foregroundColor: AppColors.textLight,
      titleTextStyle: AppTypography.heading3.copyWith(
        color: AppColors.textLight,
      ),
    ),

    // Input Decoration Theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surfaceVariant,
      border: OutlineInputBorder(
        borderRadius: AppSizes.borderRadiusLg,
        borderSide: BorderSide(
          color: AppColors.outline,
          width: AppSizes.borderWidthNormal,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: AppSizes.borderRadiusLg,
        borderSide: BorderSide(
          color: AppColors.outline,
          width: AppSizes.borderWidthNormal,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: AppSizes.borderRadiusLg,
        borderSide: BorderSide(
          color: AppColors.primaryBlue,
          width: AppSizes.borderWidthThick,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: AppSizes.borderRadiusLg,
        borderSide: BorderSide(
          color: AppColors.error,
          width: AppSizes.borderWidthNormal,
        ),
      ),
      contentPadding: AppSpacing.paddingAllNormal,
    ),

    // Scaffold
    scaffoldBackgroundColor: AppColors.backgroundLight,

    // Divider
    dividerTheme: DividerThemeData(
      color: AppColors.outline,
      thickness: AppSizes.borderWidthThin,
      space: AppSpacing.spaceNormal,
    ),

    // Icon
    iconTheme: IconThemeData(
      color: AppColors.textPrimary,
      size: AppSizes.iconMd,
    ),

    // Floating Action Button
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.primaryBlue,
      foregroundColor: AppColors.textLight,
      elevation: AppSizes.elevationButton,
      shape: RoundedRectangleBorder(
        borderRadius: AppSizes.borderRadiusRound,
      ),
    ),

    // Bottom Navigation Bar
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColors.surface,
      selectedItemColor: AppColors.primaryBlue,
      unselectedItemColor: AppColors.grey600,
      elevation: AppSizes.elevationMd,
      type: BottomNavigationBarType.fixed,
    ),

    // Chip
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.surfaceVariant,
      deleteIconColor: AppColors.textSecondary,
      disabledColor: AppColors.grey300,
      selectedColor: AppColors.primaryBlue,
      secondarySelectedColor: AppColors.primaryPink,
      padding: AppSpacing.paddingAllSmall,
      labelStyle: AppTypography.labelMedium,
      shape: RoundedRectangleBorder(
        borderRadius: AppSizes.borderRadiusLg,
      ),
    ),

    // Dialog
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.surface,
      elevation: AppSizes.elevationDialog,
      shape: RoundedRectangleBorder(
        borderRadius: AppSizes.borderRadiusXl,
      ),
      titleTextStyle: AppTypography.heading3,
      contentTextStyle: AppTypography.bodyMedium,
    ),
  );

  // ========================================
  // Helper Functions
  // ========================================

  /// Get gradient background (ใช้ทั่วแอพ)
  static Decoration get backgroundGradient => const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.backgroundSky, AppColors.backgroundLight],
        ),
      );

  /// Get card shadow
  static List<BoxShadow> get cardShadow => AppSizes.shadowMd;

  /// Get elevated card shadow (focused)
  static List<BoxShadow> get cardShadowElevated => AppSizes.shadowLg;
}
