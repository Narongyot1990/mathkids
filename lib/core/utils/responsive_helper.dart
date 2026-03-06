import 'package:flutter/material.dart';
import '../theme/app_sizes.dart';

/// Responsive Helper - Utility for responsive layouts
/// 
/// ใช้สำหรับสร้าง responsive layouts ที่ปรับขนาดตาม device type
class ResponsiveHelper {
  ResponsiveHelper._();

  // ========================================
  // Quick Device Type Check
  // ========================================

  /// Check if current device is mobile
  static bool isMobile(BuildContext context) => 
      AppSizes.isMobile(context);

  /// Check if current device is tablet
  static bool isTablet(BuildContext context) => 
      AppSizes.isTablet(context);

  /// Check if current device is desktop
  static bool isDesktop(BuildContext context) => 
      AppSizes.isDesktop(context);

  // ========================================
  // Responsive Builders
  // ========================================

  /// Build different widgets for different device types
  static Widget buildForDevice({
    required BuildContext context,
    Widget? mobile,
    Widget? tablet,
    Widget? desktop,
  }) {
    final deviceType = AppSizes.getDeviceType(context);
    
    switch (deviceType) {
      case DeviceType.mobile:
        return mobile ?? tablet ?? desktop ?? const SizedBox();
      case DeviceType.tablet:
        return tablet ?? mobile ?? desktop ?? const SizedBox();
      case DeviceType.desktop:
        return desktop ?? tablet ?? mobile ?? const SizedBox();
    }
  }

  /// Get responsive value based on device type
  static T valueForDevice<T>({
    required BuildContext context,
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    final deviceType = AppSizes.getDeviceType(context);
    
    switch (deviceType) {
      case DeviceType.mobile:
        return mobile;
      case DeviceType.tablet:
        return tablet ?? mobile;
      case DeviceType.desktop:
        return desktop ?? tablet ?? mobile;
    }
  }

  // ========================================
  // Responsive Sizing
  // ========================================

  /// Get responsive font size
  static double fontSize(BuildContext context, double baseSize) =>
      AppSizes.scaleFont(context, baseSize);

  /// Get responsive button height
  static double buttonHeight(BuildContext context) =>
      AppSizes.getButtonHeight(context);

  /// Get responsive button width  
  static double buttonWidth(BuildContext context) =>
      AppSizes.getButtonWidth(context);

  /// Get responsive icon size
  static double iconSize(BuildContext context) =>
      AppSizes.getIconSize(context);

  /// Get responsive game widget size
  static Size gameWidgetSize(BuildContext context, {double aspectRatio = 16 / 9}) =>
      AppSizes.getGameWidgetSize(context, aspectRatio: aspectRatio);

  /// Get responsive padding
  static EdgeInsets padding(BuildContext context, {
    double mobile = 16,
    double tablet = 24,
    double desktop = 32,
  }) {
    return valueForDevice(
      context: context,
      mobile: EdgeInsets.all(mobile),
      tablet: EdgeInsets.all(tablet),
      desktop: EdgeInsets.all(desktop),
    );
  }

  /// Get responsive margin
  static EdgeInsets margin(BuildContext context, {
    double mobile = 16,
    double tablet = 24,
    double desktop = 32,
  }) {
    return padding(context, mobile: mobile, tablet: tablet, desktop: desktop);
  }

  // ========================================
  // Responsive Grid
  // ========================================

  /// Get responsive column count for grid
  static int gridCrossAxisCount(BuildContext context) {
    return valueForDevice(
      context: context,
      mobile: 2,
      tablet: 3,
      desktop: 4,
    );
  }

  /// Get responsive grid spacing
  static double gridSpacing(BuildContext context) {
    return valueForDevice(
      context: context,
      mobile: 12,
      tablet: 16,
      desktop: 24,
    );
  }

  // ========================================
  // Aspect Ratio Helpers
  // ========================================

  /// Get responsive aspect ratio for game displays
  static double gameAspectRatio(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    final deviceType = AppSizes.getDeviceType(context);

    // Portrait on mobile: use taller ratio
    if (orientation == Orientation.portrait) {
      return deviceType == DeviceType.mobile ? 4 / 3 : 3 / 2;
    }
    
    // Landscape or tablet: use wider ratio
    return 16 / 9;
  }

  /// Get responsive card aspect ratio
  static double cardAspectRatio(BuildContext context) {
    return valueForDevice(
      context: context,
      mobile: 16 / 9,
      tablet: 4 / 3,
      desktop: 3 / 2,
    );
  }

  // ========================================
  // Animation Duration (slower on tablet for better UX)
  // ========================================

  /// Get responsive animation duration
  static Duration animationDuration(BuildContext context) {
    return valueForDevice(
      context: context,
      mobile: const Duration(milliseconds: 300),
      tablet: const Duration(milliseconds: 400),
      desktop: const Duration(milliseconds: 500),
    );
  }

  /// Get responsive animation curve
  static Curve animationCurve(BuildContext context) {
    return Curves.easeInOut;
  }
}
