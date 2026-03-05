import 'package:flutter/material.dart';

/// App Spacing System - Design Token System
///
/// ระบบ spacing แบบ 8pt grid system
/// ใช้ทั่วทั้งแอพเพื่อความสม่ำเสมอ
class AppSpacing {
  AppSpacing._(); // Private constructor

  // ========================================
  // Base Spacing Scale (8pt grid)
  // ========================================
  static const double xs = 4.0; // Extra small
  static const double sm = 8.0; // Small
  static const double md = 16.0; // Medium (base)
  static const double lg = 24.0; // Large
  static const double xl = 32.0; // Extra large
  static const double xxl = 48.0; // 2X large
  static const double xxxl = 64.0; // 3X large

  // ========================================
  // Semantic Spacing (ตามความหมาย)
  // ========================================
  static const double spaceTiny = xs; // 4px - icon padding
  static const double spaceSmall = sm; // 8px - tight spacing
  static const double spaceNormal = md; // 16px - default
  static const double spaceMedium = lg; // 24px - section spacing
  static const double spaceLarge = xl; // 32px - major sections
  static const double spaceHuge = xxl; // 48px - screen sections

  // ========================================
  // Component Spacing (สำหรับคอมโพเนนต์เฉพาะ)
  // ========================================
  static const double buttonPaddingVertical = md; // 16px
  static const double buttonPaddingHorizontal = xl; // 32px
  static const double cardPadding = md; // 16px
  static const double screenPadding = md; // 16px (mobile)
  static const double screenPaddingLarge = lg; // 24px (tablet)

  // ========================================
  // Gap Spacing (ระยะห่างระหว่าง elements)
  // ========================================
  static const double gapTiny = xs; // 4px
  static const double gapSmall = sm; // 8px
  static const double gapMedium = 12.0; // 12px - wrap spacing
  static const double gapNormal = md; // 16px
  static const double gapLarge = lg; // 24px

  // ========================================
  // SizedBox Helpers (ใช้บ่อย)
  // ========================================
  static const SizedBox verticalSpaceTiny = SizedBox(height: xs);
  static const SizedBox verticalSpaceSmall = SizedBox(height: sm);
  static const SizedBox verticalSpaceNormal = SizedBox(height: md);
  static const SizedBox verticalSpaceMedium = SizedBox(height: lg);
  static const SizedBox verticalSpaceLarge = SizedBox(height: xl);
  static const SizedBox verticalSpaceHuge = SizedBox(height: xxl);

  static const SizedBox horizontalSpaceTiny = SizedBox(width: xs);
  static const SizedBox horizontalSpaceSmall = SizedBox(width: sm);
  static const SizedBox horizontalSpaceNormal = SizedBox(width: md);
  static const SizedBox horizontalSpaceMedium = SizedBox(width: lg);
  static const SizedBox horizontalSpaceLarge = SizedBox(width: xl);

  // ========================================
  // EdgeInsets Helpers (ใช้บ่อย)
  // ========================================
  static const EdgeInsets paddingAllTiny = EdgeInsets.all(xs);
  static const EdgeInsets paddingAllSmall = EdgeInsets.all(sm);
  static const EdgeInsets paddingAllNormal = EdgeInsets.all(md);
  static const EdgeInsets paddingAllMedium = EdgeInsets.all(lg);
  static const EdgeInsets paddingAllLarge = EdgeInsets.all(xl);

  static const EdgeInsets paddingHorizontalSmall = EdgeInsets.symmetric(horizontal: sm);
  static const EdgeInsets paddingHorizontalNormal = EdgeInsets.symmetric(horizontal: md);
  static const EdgeInsets paddingHorizontalMedium = EdgeInsets.symmetric(horizontal: lg);
  static const EdgeInsets paddingHorizontalLarge = EdgeInsets.symmetric(horizontal: xl);

  static const EdgeInsets paddingVerticalSmall = EdgeInsets.symmetric(vertical: sm);
  static const EdgeInsets paddingVerticalNormal = EdgeInsets.symmetric(vertical: md);
  static const EdgeInsets paddingVerticalMedium = EdgeInsets.symmetric(vertical: lg);
  static const EdgeInsets paddingVerticalLarge = EdgeInsets.symmetric(vertical: xl);

  // ========================================
  // Responsive Spacing (ปรับตามขนาดหน้าจอ)
  // ========================================
  static double responsive(BuildContext context, {
    required double mobile,
    double? tablet,
    double? desktop,
  }) {
    final width = MediaQuery.of(context).size.width;
    if (width >= 1024 && desktop != null) return desktop;
    if (width >= 600 && tablet != null) return tablet;
    return mobile;
  }

  // ========================================
  // Screen Padding (ตามขนาดหน้าจอ)
  // ========================================
  static EdgeInsets screenPaddingResponsive(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= 1024) return paddingAllLarge; // Desktop
    if (width >= 600) return paddingAllMedium; // Tablet
    return paddingAllNormal; // Mobile
  }
}
