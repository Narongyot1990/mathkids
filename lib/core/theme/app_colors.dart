import 'package:flutter/material.dart';

/// App Color Palette - Design Token System
///
/// ระบบสีทั้งหมดของแอพ รวมศูนย์ไว้ที่นี่เพื่อความสม่ำเสมอ
/// แบ่งเป็น:
/// - Primary Colors (สีหลักสำหรับเด็ก สดใส)
/// - Background Colors (สีพื้นหลัง)
/// - Text Colors (สีตัวอักษร)
/// - Status Colors (สีสถานะ)
/// - Neutral Colors (สีเทา/ขาว/ดำ)
/// - Game Colors (สีเฉพาะเกม)
class AppColors {
  AppColors._(); // Private constructor

  // ========================================
  // Primary Colors (สีหลัก - สดใส ทันสมัย เหมาะกับเด็ก)
  // Modern Vibrant Palette 2025
  // ========================================
  static const Color primaryBlue = Color(0xFF5B9FFF);      // Vivid Sky Blue
  static const Color primaryPink = Color(0xFFFF5FA2);      // Vibrant Pink
  static const Color primaryYellow = Color(0xFFFFCB45);    // Sunny Yellow
  static const Color primaryGreen = Color(0xFF4ECDC4);     // Turquoise Green
  static const Color primaryOrange = Color(0xFFFF8C42);    // Coral Orange
  static const Color primaryPurple = Color(0xFF9B6BFF);    // Bright Purple
  static const Color primaryMint = Color(0xFF7CFFCB);      // Mint Green
  static const Color primaryCoral = Color(0xFFFF6B9D);     // Coral Pink

  // ========================================
  // Background Colors (สีพื้นหลัง)
  // ========================================
  static const Color backgroundLight = Color(0xFFFFFBF5); // Cream/Beige
  static const Color backgroundSky = Color(0xFFE3F2FD); // Light Blue Sky
  static const Color backgroundWhite = Color(0xFFFFFFFF); // Pure White

  // ========================================
  // Text Colors (สีตัวอักษร)
  // ========================================
  static const Color textPrimary = Color(0xFF2C3E50); // Dark Blue-Gray
  static const Color textSecondary = Color(0xFF7F8C8D); // Medium Gray
  static const Color textLight = Color(0xFFFFFFFF); // White text on dark bg
  static const Color textDark = Color(0xFF000000); // Pure black (labels)

  // ========================================
  // Status Colors (สีสถานะ)
  // ========================================
  static const Color success = Color(0xFF27AE60); // Success Green
  static const Color error = Color(0xFFE74C3C); // Error Red
  static const Color warning = Color(0xFFF39C12); // Warning Orange
  static const Color info = Color(0xFF3498DB); // Info Blue

  // ========================================
  // Neutral Colors (สีเทา - ระดับต่างๆ)
  // ========================================
  static const Color grey50 = Color(0xFFFAFAFA);
  static const Color grey100 = Color(0xFFF5F5F5);
  static const Color grey200 = Color(0xFFEEEEEE);
  static const Color grey300 = Color(0xFFE0E0E0);
  static const Color grey400 = Color(0xFFBDBDBD);
  static const Color grey500 = Color(0xFF9E9E9E);
  static const Color grey600 = Color(0xFF757575);
  static const Color grey700 = Color(0xFF616161);
  static const Color grey800 = Color(0xFF424242);
  static const Color grey900 = Color(0xFF212121);

  // ========================================
  // Game-Specific Colors (สีเฉพาะเกม)
  // ========================================
  static const Color gameCorrect = Color(0xFF27AE60); // เหมือน success
  static const Color gameWrong = Color(0xFFE74C3C); // เหมือน error
  static const Color gameStar = Color(0xFFFFD700); // Gold star
  static const Color gameLocked = Color(0xFF9E9E9E); // Locked stage

  // ========================================
  // Semantic Colors (สีตามความหมาย)
  // ========================================
  static const Color surface = Color(0xFFFFFFFF); // Card/Container surface
  static const Color surfaceVariant = Color(0xFFF5F5F5); // Alternate surface
  static const Color outline = Color(0xFFE0E0E0); // Border/Outline
  static const Color shadow = Color(0x14000000); // Shadow color with alpha

  // ========================================
  // Stats Colors (สีสำหรับสถิติ)
  // ========================================
  static const Color statsAccuracy = Color(0xFF2196F3); // Blue 600
  static const Color statsGames = Color(0xFFFFA726); // Orange 600
  static const Color statsScore = Color(0xFFFFCA28); // Amber 600
  static const Color statsTime = Color(0xFF66BB6A); // Green 600

  // ========================================
  // Loading/Loading Screen Colors
  // ========================================
  static const Color loadingStart = Color(0xFF6366F1); // Indigo/Purple start
  static const Color loadingEnd = Color(0xFF8B5CF6); // Purple end

  // ========================================
  // Opacity Helpers (ความโปร่งแสง)
  // ========================================
  static Color withOpacity(Color color, double opacity) {
    return color.withValues(alpha: opacity);
  }

  // Pre-defined opacity variants
  static Color shadow10 = const Color(0x1A000000); // 10% black
  static Color shadow20 = const Color(0x33000000); // 20% black
  static Color overlay = const Color(0x80000000); // 50% black overlay

  // ========================================
  // Kid-Friendly Gradient System - สดใส น่ารัก เหมาะกับเด็ก 3-6 ขวบ
  // ========================================

  // Background Gradients - สีสดใสสไตล์การ์ตูน
  static const Gradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFFFE5F1),  // Baby Pink
      Color(0xFFFFF8DC),  // Light Cream
      Color(0xFFE3F9FF),  // Sky Blue
      Color(0xFFFFF4E3),  // Peach
    ],
    stops: [0.0, 0.33, 0.66, 1.0],
  );

  // Loading Gradient - รุ้งสดใสน่ารัก
  static const Gradient loadingGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFFB5E8),  // Candy Pink
      Color(0xFFFFE4B5),  // Peach
      Color(0xFFB5F5EC),  // Mint
      Color(0xFFD4B5FF),  // Lavender
    ],
    stops: [0.0, 0.33, 0.66, 1.0],
  );

  // Playful Rainbow Background - ท้องฟ้าสีรุ้ง
  static const Gradient rainbowBackground = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFFDAE9),  // Pink Sky
      Color(0xFFFFE8CC),  // Peach Sky
      Color(0xFFFFF4CC),  // Yellow Sky
      Color(0xFFCCF5FF),  // Blue Sky
      Color(0xFFE5CCFF),  // Purple Sky
    ],
    stops: [0.0, 0.25, 0.5, 0.75, 1.0],
  );

  // Sunny Day Background - วันแดดสดใส
  static const Gradient sunnyBackground = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF87CEEB),  // Sky Blue
      Color(0xFFB0E0E6),  // Powder Blue
      Color(0xFFFFFFCC),  // Light Yellow
      Color(0xFFFFE5B4),  // Peach
    ],
    stops: [0.0, 0.4, 0.7, 1.0],
  );

  // Button Gradients - สดใสน่ารักสำหรับเด็ก
  static const Gradient blueGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF64B5F6),  // Light Blue
      Color(0xFF42A5F5),  // Blue
      Color(0xFF2196F3),  // Deep Blue
    ],
    stops: [0.0, 0.5, 1.0],
  );

  static const Gradient pinkGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFF48FB1),  // Light Pink
      Color(0xFFF06292),  // Pink
      Color(0xFFEC407A),  // Deep Pink
    ],
    stops: [0.0, 0.5, 1.0],
  );

  static const Gradient greenGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF81C784),  // Light Green
      Color(0xFF66BB6A),  // Green
      Color(0xFF4CAF50),  // Deep Green
    ],
    stops: [0.0, 0.5, 1.0],
  );

  static const Gradient yellowGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFFF176),  // Light Yellow
      Color(0xFFFFEE58),  // Yellow
      Color(0xFFFFEB3B),  // Deep Yellow
    ],
    stops: [0.0, 0.5, 1.0],
  );

  static const Gradient orangeGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFFB74D),  // Light Orange
      Color(0xFFFFA726),  // Orange
      Color(0xFFFF9800),  // Deep Orange
    ],
    stops: [0.0, 0.5, 1.0],
  );

  static const Gradient purpleGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFCE93D8),  // Light Purple
      Color(0xFFBA68C8),  // Purple
      Color(0xFFAB47BC),  // Deep Purple
    ],
    stops: [0.0, 0.5, 1.0],
  );

  static const Gradient mintGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF80CBC4),  // Light Mint
      Color(0xFF4DB6AC),  // Mint
      Color(0xFF26A69A),  // Deep Mint
    ],
    stops: [0.0, 0.5, 1.0],
  );

  // Rainbow Gradient - สำหรับ Special Effects
  static const Gradient rainbowGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFF5FA2),  // Pink
      Color(0xFFFF8C42),  // Orange
      Color(0xFFFFCB45),  // Yellow
      Color(0xFF4ECDC4),  // Green
      Color(0xFF5B9FFF),  // Blue
      Color(0xFF9B6BFF),  // Purple
    ],
  );

  // Success/Error Gradients - สดใสน่ารัก
  static const Gradient successGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF81C784),  // Light Green
      Color(0xFF66BB6A),  // Green
      Color(0xFF4CAF50),  // Deep Green
    ],
    stops: [0.0, 0.5, 1.0],
  );

  static const Gradient errorGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFF8A80),  // Light Red
      Color(0xFFFF5252),  // Red
      Color(0xFFFF1744),  // Deep Red
    ],
    stops: [0.0, 0.5, 1.0],
  );

  // Card Gradient - สำหรับการ์ดเกม (Deprecated - use game-specific gradients)
  static const Gradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF9B6BFF),
      Color(0xFF5B9FFF),
    ],
  );

  // ========================================
  // Game Card Gradients - สำหรับ Card เลือกเกม (สีพาสเทลสดใส)
  // ========================================

  // Counting Game - ฟ้าพาสเทล
  static const Gradient countingCardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF81D4FA),  // Light Sky Blue
      Color(0xFF4FC3F7),  // Bright Blue
      Color(0xFF29B6F6),  // Ocean Blue
    ],
    stops: [0.0, 0.5, 1.0],
  );

  // Addition Game - เขียวพาสเทล
  static const Gradient additionCardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFA7FFEB),  // Light Mint
      Color(0xFF64FFDA),  // Bright Mint
      Color(0xFF1DE9B6),  // Turquoise
    ],
    stops: [0.0, 0.5, 1.0],
  );

  // Subtraction Game - ส้มพาสเทล
  static const Gradient subtractionCardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFFCC80),  // Light Peach
      Color(0xFFFFB74D),  // Bright Orange
      Color(0xFFFFA726),  // Orange
    ],
    stops: [0.0, 0.5, 1.0],
  );

  // Comparison Game - ชมพูพาสเทล
  static const Gradient comparisonCardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFF8BBD0),  // Baby Pink
      Color(0xFFF48FB1),  // Light Pink
      Color(0xFFEC407A),  // Vibrant Pink
    ],
    stops: [0.0, 0.5, 1.0],
  );

  // Sequence Game - เหลืองพาสเทล
  static const Gradient sequenceCardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFFF59D),  // Light Yellow
      Color(0xFFFFEE58),  // Bright Yellow
      Color(0xFFFFEB3B),  // Sunny Yellow
    ],
    stops: [0.0, 0.5, 1.0],
  );

  // Math Grid Game - ม่วงพาสเทล
  static const Gradient mathGridCardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFE1BEE7),  // Light Lavender
      Color(0xFFCE93D8),  // Lavender
      Color(0xFFBA68C8),  // Purple
    ],
    stops: [0.0, 0.5, 1.0],
  );

  // ========================================
  // Game Background Gradients - สำหรับหน้าเกม (สีพาสเทลอ่อนมาก)
  // ========================================

  // Counting Game - ฟ้าอ่อนนุ่มนวล
  static const Gradient countingGameBackground = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFE3F2FD),  // Very Light Blue
      Color(0xFFF5FAFF),  // Almost White Blue
    ],
  );

  // Addition Game - เขียวอ่อนนุ่มนวล
  static const Gradient additionGameBackground = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFE0F2F1),  // Very Light Teal
      Color(0xFFF5FFFE),  // Almost White Teal
    ],
  );

  // Subtraction Game - ส้มอ่อนนุ่มนวล
  static const Gradient subtractionGameBackground = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFFFF3E0),  // Very Light Orange
      Color(0xFFFFFBF5),  // Almost White Orange
    ],
  );

  // Comparison Game - ชมพูอ่อนนุ่มนวล
  static const Gradient comparisonGameBackground = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFFCE4EC),  // Very Light Pink
      Color(0xFFFFF8FB),  // Almost White Pink
    ],
  );

  // Sequence Game - เหลืองอ่อนนุ่มนวล
  static const Gradient sequenceGameBackground = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFFFFDE7),  // Very Light Yellow
      Color(0xFFFFFFF9),  // Almost White Yellow
    ],
  );

  // Math Grid Game - ม่วงอ่อนนุ่มนวล
  static const Gradient mathGridGameBackground = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFF3E5F5),  // Very Light Purple
      Color(0xFFFCF9FD),  // Almost White Purple
    ],
  );

  // ========================================
  // Game Type Colors (สีตามประเภทเกม)
  // ========================================
  static const Map<String, Color> gameTypeColors = {
    'counting': primaryBlue,
    'addition': primaryGreen,
    'subtraction': primaryOrange,
    'comparison': primaryPink,
    'sequence': primaryPurple,
    'mathGrid': primaryYellow,
  };
}
