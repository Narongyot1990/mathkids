import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// App Typography System - Design Token System
///
/// ระบบ typography ทั้งหมด (font size, weight, line height)
/// ใช้ทั่วทั้งแอพเพื่อความสม่ำเสมอ
class AppTypography {
  AppTypography._(); // Private constructor

  // ========================================
  // Font Family
  // ========================================
  static final String _fontFamily = GoogleFonts.fredoka().fontFamily ?? 'Fredoka';
  static String get fontFamily => _fontFamily;

  // ========================================
  // Font Sizes
  // ========================================
  static const double fontSizeXs = 11.0;
  static const double fontSizeSm = 13.0;
  static const double fontSizeMd = 14.0;
  static const double fontSizeLg = 16.0;
  static const double fontSizeXl = 18.0;
  static const double fontSize2Xl = 20.0;
  static const double fontSize3Xl = 24.0;
  static const double fontSize4Xl = 32.0;
  static const double fontSize5Xl = 36.0;
  static const double fontSize6Xl = 48.0;
  static const double fontSize7Xl = 64.0;
  static const double fontSize8Xl = 80.0;
  static const double fontSize9Xl = 100.0;

  // ========================================
  // Font Weights
  // ========================================
  static const FontWeight weightLight = FontWeight.w300;
  static const FontWeight weightRegular = FontWeight.w400;
  static const FontWeight weightMedium = FontWeight.w500;
  static const FontWeight weightSemiBold = FontWeight.w600;
  static const FontWeight weightBold = FontWeight.w700;
  static const FontWeight weightExtraBold = FontWeight.w800;

  // ========================================
  // Line Heights (as multipliers)
  // ========================================
  static const double lineHeightTight = 1.2;
  static const double lineHeightNormal = 1.5;
  static const double lineHeightRelaxed = 1.75;

  // ========================================
  // Display Styles (ใหญ่มาก - หน้าจอหลัก)
  // ========================================
  static TextStyle displayLarge = GoogleFonts.fredoka(
    fontSize: fontSize8Xl, // 80px
    fontWeight: weightBold,
    color: AppColors.textPrimary,
    height: lineHeightTight,
  );

  static TextStyle displayMedium = GoogleFonts.fredoka(
    fontSize: fontSize6Xl, // 48px
    fontWeight: weightBold,
    color: AppColors.textPrimary,
    height: lineHeightTight,
  );

  static TextStyle displaySmall = GoogleFonts.fredoka(
    fontSize: fontSize5Xl, // 36px
    fontWeight: weightBold,
    color: AppColors.textPrimary,
    height: lineHeightTight,
  );

  // ========================================
  // Heading Styles (หัวข้อ)
  // ========================================
  static TextStyle heading1 = GoogleFonts.fredoka(
    fontSize: fontSize4Xl, // 32px
    fontWeight: weightBold,
    color: AppColors.textPrimary,
    height: lineHeightNormal,
  );

  static TextStyle heading2 = GoogleFonts.fredoka(
    fontSize: fontSize3Xl, // 24px
    fontWeight: weightBold,
    color: AppColors.textPrimary,
    height: lineHeightNormal,
  );

  static TextStyle heading3 = GoogleFonts.fredoka(
    fontSize: fontSize2Xl, // 20px
    fontWeight: weightSemiBold,
    color: AppColors.textPrimary,
    height: lineHeightNormal,
  );

  static TextStyle heading4 = GoogleFonts.fredoka(
    fontSize: fontSizeXl, // 18px
    fontWeight: weightSemiBold,
    color: AppColors.textPrimary,
    height: lineHeightNormal,
  );

  // ========================================
  // Body Styles (เนื้อหา)
  // ========================================
  static TextStyle bodyLarge = GoogleFonts.fredoka(
    fontSize: fontSizeLg, // 16px
    fontWeight: weightRegular,
    color: AppColors.textPrimary,
    height: lineHeightNormal,
  );

  static TextStyle bodyMedium = GoogleFonts.fredoka(
    fontSize: fontSizeMd, // 14px
    fontWeight: weightRegular,
    color: AppColors.textPrimary,
    height: lineHeightNormal,
  );

  static TextStyle bodySmall = GoogleFonts.fredoka(
    fontSize: fontSizeSm, // 13px
    fontWeight: weightRegular,
    color: AppColors.textSecondary,
    height: lineHeightNormal,
  );

  // ========================================
  // Label Styles (ป้ายชื่อ, caption)
  // ========================================
  static TextStyle labelLarge = GoogleFonts.fredoka(
    fontSize: fontSizeLg, // 16px
    fontWeight: weightMedium,
    color: AppColors.textPrimary,
    height: lineHeightNormal,
  );

  static TextStyle labelMedium = GoogleFonts.fredoka(
    fontSize: fontSizeMd, // 14px
    fontWeight: weightMedium,
    color: AppColors.textPrimary,
    height: lineHeightNormal,
  );

  static TextStyle labelSmall = GoogleFonts.fredoka(
    fontSize: fontSizeSm, // 13px
    fontWeight: weightMedium,
    color: AppColors.textSecondary,
    height: lineHeightNormal,
  );

  static TextStyle caption = GoogleFonts.fredoka(
    fontSize: fontSizeXs, // 11px
    fontWeight: weightRegular,
    color: AppColors.textSecondary,
    height: lineHeightNormal,
  );

  // ========================================
  // Button Styles (ปุ่ม)
  // ========================================
  static TextStyle buttonLarge = GoogleFonts.fredoka(
    fontSize: fontSize3Xl, // 24px
    fontWeight: weightBold,
    color: AppColors.textLight,
    height: lineHeightTight,
  );

  static TextStyle buttonMedium = GoogleFonts.fredoka(
    fontSize: fontSize2Xl, // 20px
    fontWeight: weightBold,
    color: AppColors.textLight,
    height: lineHeightTight,
  );

  static TextStyle buttonSmall = GoogleFonts.fredoka(
    fontSize: fontSizeLg, // 16px
    fontWeight: weightSemiBold,
    color: AppColors.textLight,
    height: lineHeightTight,
  );

  // ========================================
  // Game-Specific Styles (เกม)
  // ========================================

  // คำถามเกม
  static TextStyle gameQuestion = GoogleFonts.fredoka(
    fontSize: fontSize4Xl, // 32px
    fontWeight: weightBold,
    color: AppColors.textPrimary,
    height: lineHeightNormal,
  );

  // ตัวเลขคำตอบ (ใหญ่)
  static TextStyle gameAnswer = GoogleFonts.fredoka(
    fontSize: fontSize5Xl, // 36px
    fontWeight: weightBold,
    color: AppColors.textLight,
    height: lineHeightTight,
  );

  // คะแนน
  static TextStyle gameScore = GoogleFonts.fredoka(
    fontSize: fontSize2Xl, // 20px
    fontWeight: weightBold,
    color: AppColors.textPrimary,
    height: lineHeightNormal,
  );

  // ตัวเลขในเกม (sequence, etc)
  static TextStyle gameNumber = GoogleFonts.fredoka(
    fontSize: fontSize6Xl, // 48px
    fontWeight: weightBold,
    color: AppColors.primaryBlue,
    height: lineHeightTight,
  );

  // ========================================
  // Utility Functions
  // ========================================

  /// สร้าง TextStyle จากค่าต่างๆ
  static TextStyle custom({
    required double fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? height,
    TextDecoration? decoration,
  }) {
    return GoogleFonts.fredoka(
      fontSize: fontSize,
      fontWeight: fontWeight ?? weightRegular,
      color: color ?? AppColors.textPrimary,
      height: height,
      decoration: decoration,
    );
  }

  /// ทำให้ขาว (สำหรับพื้นหลังเข้ม)
  static TextStyle white(TextStyle style) {
    return style.copyWith(color: AppColors.textLight);
  }

  /// ทำให้เป็นสีหลัก
  static TextStyle primary(TextStyle style) {
    return style.copyWith(color: AppColors.primaryBlue);
  }

  /// ทำให้เป็นสีรอง
  static TextStyle secondary(TextStyle style) {
    return style.copyWith(color: AppColors.textSecondary);
  }

  /// ทำให้เป็นสีสำเร็จ
  static TextStyle success(TextStyle style) {
    return style.copyWith(color: AppColors.success);
  }

  /// ทำให้เป็นสีผิดพลาด
  static TextStyle error(TextStyle style) {
    return style.copyWith(color: AppColors.error);
  }
}
