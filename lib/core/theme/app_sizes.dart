import 'package:flutter/material.dart';

/// App Sizes System - Design Token System
///
/// ระบบขนาดต่างๆ (Border Radius, Elevation, Icon Size, etc.)
/// ใช้ทั่วทั้งแอพเพื่อความสม่ำเสมอ
class AppSizes {
  AppSizes._(); // Private constructor

  // ========================================
  // Border Radius (มุมโค้ง)
  // ========================================
  static const double radiusNone = 0.0;
  static const double radiusXs = 4.0;
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusXl = 20.0;
  static const double radiusXxl = 24.0;
  static const double radiusRound = 999.0; // Fully rounded

  // Semantic Radius
  static const double radiusButton = radiusXl; // 20px - ปุ่ม
  static const double radiusCard = radiusXl; // 20px - การ์ด
  static const double radiusDialog = radiusLg; // 16px - dialog
  static const double radiusInput = radiusMd; // 12px - input field

  // BorderRadius Helpers
  static const BorderRadius borderRadiusXs = BorderRadius.all(Radius.circular(radiusXs));
  static const BorderRadius borderRadiusSm = BorderRadius.all(Radius.circular(radiusSm));
  static const BorderRadius borderRadiusMd = BorderRadius.all(Radius.circular(radiusMd));
  static const BorderRadius borderRadiusLg = BorderRadius.all(Radius.circular(radiusLg));
  static const BorderRadius borderRadiusXl = BorderRadius.all(Radius.circular(radiusXl));
  static const BorderRadius borderRadiusXxl = BorderRadius.all(Radius.circular(radiusXxl));
  static const BorderRadius borderRadiusRound = BorderRadius.all(Radius.circular(radiusRound));

  static const BorderRadius borderRadiusButton = borderRadiusXl;
  static const BorderRadius borderRadiusCard = borderRadiusXl;

  // ========================================
  // Elevation (ความสูง - shadow)
  // ========================================
  static const double elevationNone = 0.0;
  static const double elevationXs = 2.0;
  static const double elevationSm = 4.0;
  static const double elevationMd = 8.0;
  static const double elevationLg = 12.0;
  static const double elevationXl = 16.0;

  // Semantic Elevation
  static const double elevationButton = elevationMd; // 8px
  static const double elevationCard = elevationMd; // 8px
  static const double elevationCardFocused = elevationXl; // 16px
  static const double elevationDialog = elevationLg; // 12px

  // ========================================
  // Icon Sizes
  // ========================================
  static const double iconXs = 16.0;
  static const double iconSm = 20.0;
  static const double iconMd = 24.0;
  static const double iconLg = 32.0;
  static const double iconXl = 48.0;
  static const double iconXxl = 64.0;

  // Semantic Icon Sizes
  static const double iconButton = iconMd; // 24px
  static const double iconEmoji = 80.0; // 80px - emoji ใหญ่

  // ========================================
  // Button Sizes
  // ========================================
  static const double buttonHeightSmall = 40.0;
  static const double buttonHeightMedium = 48.0;
  static const double buttonHeightLarge = 56.0;
  static const double buttonHeightXLarge = 64.0;

  static const double buttonWidthSmall = 80.0;
  static const double buttonWidthMedium = 120.0;
  static const double buttonWidthLarge = 160.0;

  // Game Answer Button (จตุรัส)
  static const double answerButtonSize = 95.0; // 95x95px
  static const double answerButtonSizeSmall = 80.0; // Small screen

  // ========================================
  // Card Sizes
  // ========================================
  static const double cardWidthSmall = 200.0;
  static const double cardWidthMedium = 240.0;
  static const double cardWidthLarge = 280.0;

  static const double cardHeightSmall = 200.0;
  static const double cardHeightMedium = 240.0;
  static const double cardHeightLarge = 280.0;

  // ========================================
  // Avatar/Image Sizes
  // ========================================
  static const double avatarSizeSmall = 32.0;
  static const double avatarSizeMedium = 48.0;
  static const double avatarSizeLarge = 64.0;
  static const double avatarSizeXLarge = 96.0;

  // ========================================
  // Border Width (ความหนาของขอบ)
  // ========================================
  static const double borderWidthThin = 1.0;
  static const double borderWidthNormal = 2.0;
  static const double borderWidthThick = 3.0;
  static const double borderWidthXThick = 4.0;

  // ========================================
  // Breakpoints (ขนาดหน้าจอ) - iPhone optimized
  // ========================================
  // iPhone 13 Mini: 375 x 812 (2.17:1)
  // iPhone 13/14: 390 x 844 (2.16:1)
  // iPhone 13 Pro Max: 428 x 926 (2.16:1)
  // iPhone 15 Pro Max: 430 x 932 (2.17:1)
  // iPhone 17 Pro Max: ~440 x 956 (estimated)

  static const double breakpointSmall = 360.0; // Small phone (iPhone SE)
  static const double breakpointMedium = 390.0; // iPhone 13/14/15
  static const double breakpointLarge = 430.0; // iPhone Pro Max
  static const double breakpointXLarge = 1024.0; // Tablet/Desktop

  // Helper functions
  static bool isSmallScreen(BuildContext context) {
    return MediaQuery.of(context).size.width < breakpointSmall;
  }

  static bool isMediumScreen(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= breakpointMedium && width < breakpointLarge;
  }

  static bool isLargeScreen(BuildContext context) {
    return MediaQuery.of(context).size.width >= breakpointLarge;
  }

  // ========================================
  // Responsive Scaling System - iPhone optimized
  // ========================================

  /// Get scale factor based on screen size (iPhone 13 = 1.0)
  static double getScaleFactor(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    // Base: iPhone 13 (390px)
    if (width <= 375) {
      // iPhone 13 Mini, SE
      return 0.92;
    } else if (width <= 390) {
      // iPhone 13, 14
      return 1.0;
    } else if (width <= 430) {
      // iPhone 13/14/15 Pro Max
      return 1.08;
    } else {
      // iPhone 17 Pro Max and larger
      return 1.12;
    }
  }

  /// Scale size responsively based on device
  static double scale(BuildContext context, double baseSize) {
    return baseSize * getScaleFactor(context);
  }

  /// Scale font size responsively
  static double scaledFontSize(BuildContext context, double baseSize) {
    final scaleFactor = getScaleFactor(context);
    // Font scales slightly less than other elements
    return baseSize * (0.9 + (scaleFactor - 0.9) * 0.5);
  }

  /// Get responsive padding
  static EdgeInsets scaledPadding(BuildContext context, EdgeInsets basePadding) {
    final scale = getScaleFactor(context);
    return EdgeInsets.fromLTRB(
      basePadding.left * scale,
      basePadding.top * scale,
      basePadding.right * scale,
      basePadding.bottom * scale,
    );
  }

  /// Get screen height percentage
  static double screenHeight(BuildContext context, double percentage) {
    return MediaQuery.of(context).size.height * percentage;
  }

  /// Get screen width percentage
  static double screenWidth(BuildContext context, double percentage) {
    return MediaQuery.of(context).size.width * percentage;
  }

  // ========================================
  // Grid Spacing
  // ========================================
  static const double gridSpacingSmall = 12.0;
  static const double gridSpacingNormal = 16.0;
  static const double gridSpacingLarge = 20.0;

  // ========================================
  // Common Shadows
  // ========================================
  static List<BoxShadow> shadowSm = [
    BoxShadow(
      color: const Color(0x14000000), // 8% black
      blurRadius: 4,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> shadowMd = [
    BoxShadow(
      color: const Color(0x1A000000), // 10% black
      blurRadius: 8,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> shadowLg = [
    BoxShadow(
      color: const Color(0x1F000000), // 12% black
      blurRadius: 12,
      offset: const Offset(0, 6),
    ),
  ];

  static List<BoxShadow> shadowXl = [
    BoxShadow(
      color: const Color(0x24000000), // 14% black
      blurRadius: 16,
      offset: const Offset(0, 8),
    ),
  ];
}
