import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';
import '../core/theme/app_sizes.dart';

/// Answer Button Widget
///
/// ปุ่มสำหรับตอบคำถามในเกม - ใช้ร่วมกันในทุก game widget
/// รองรับ:
/// - สีตาม state (default, correct, wrong, disabled)
/// - ขนาดปุ่ม responsive
/// - รูปแบบ content ต่างๆ (number, text, symbol)
class AnswerButton extends StatelessWidget {
  /// ค่าคำตอบ (ส่งกลับเมื่อกด)
  final int value;

  /// ข้อความแสดงบนปุ่ม (ถ้าไม่ระบุจะใช้ value)
  final String? displayText;

  /// Callback เมื่อกดปุ่ม
  final VoidCallback? onPressed;

  /// สีพื้นหลังปุ่ม (override default)
  final Color? backgroundColor;

  /// ขนาดปุ่ม
  final AnswerButtonSize size;

  /// รูปแบบปุ่ม
  final AnswerButtonVariant variant;

  const AnswerButton({
    super.key,
    required this.value,
    this.displayText,
    this.onPressed,
    this.backgroundColor,
    this.size = AnswerButtonSize.normal,
    this.variant = AnswerButtonVariant.number,
  });

  /// Factory constructor สำหรับปุ่มตัวเลข
  factory AnswerButton.number({
    Key? key,
    required int value,
    VoidCallback? onPressed,
    Color? backgroundColor,
    AnswerButtonSize size = AnswerButtonSize.normal,
  }) {
    return AnswerButton(
      key: key,
      value: value,
      onPressed: onPressed,
      backgroundColor: backgroundColor,
      size: size,
      variant: AnswerButtonVariant.number,
    );
  }

  /// Factory constructor สำหรับปุ่มสัญลักษณ์ (comparison: <, =, >)
  factory AnswerButton.symbol({
    Key? key,
    required int value,
    required String symbol,
    VoidCallback? onPressed,
    Color? backgroundColor,
    AnswerButtonSize size = AnswerButtonSize.normal,
  }) {
    return AnswerButton(
      key: key,
      value: value,
      displayText: symbol,
      onPressed: onPressed,
      backgroundColor: backgroundColor,
      size: size,
      variant: AnswerButtonVariant.symbol,
    );
  }

  @override
  Widget build(BuildContext context) {
    // กำหนดขนาดปุ่มตาม size
    final buttonSize = _getButtonSize();

    // กำหนดสีพื้นหลัง
    final bgColor = backgroundColor ?? AppColors.primaryBlue;

    // กำหนด text style
    final textStyle = _getTextStyle();

    // ข้อความที่แสดง
    final text = displayText ?? value.toString();

    return SizedBox(
      width: buttonSize,
      height: buttonSize,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          disabledBackgroundColor: bgColor,
          shape: RoundedRectangleBorder(
            borderRadius: AppSizes.borderRadiusXl,
          ),
          elevation: AppSizes.elevationButton,
          padding: EdgeInsets.zero,
        ),
        child: Text(
          text,
          style: textStyle,
        ),
      ),
    );
  }

  /// คำนวณขนาดปุ่ม
  double _getButtonSize() {
    switch (size) {
      case AnswerButtonSize.small:
        return AppSizes.answerButtonSizeSmall;
      case AnswerButtonSize.normal:
        return AppSizes.answerButtonSize;
    }
  }

  /// คำนวณ text style
  TextStyle _getTextStyle() {
    switch (variant) {
      case AnswerButtonVariant.number:
        return AppTypography.gameAnswer;
      case AnswerButtonVariant.symbol:
        return AppTypography.gameAnswer;
    }
  }
}

/// ขนาดปุ่ม
enum AnswerButtonSize {
  small, // 80x80
  normal, // 95x95
}

/// รูปแบบปุ่ม
enum AnswerButtonVariant {
  number, // ตัวเลข
  symbol, // สัญลักษณ์ (<, =, >)
}

/// Helper Widget: AnswerButtonGrid
///
/// แสดงปุ่มคำตอบหลายปุ่มแบบ Wrap (เหมาะกับ mobile)
class AnswerButtonGrid extends StatelessWidget {
  /// รายการตัวเลือก
  final List<int> options;

  /// คำตอบที่ถูกต้อง
  final int correctAnswer;

  /// คำตอบปัจจุบันที่เลือก (null = ยังไม่เลือก)
  final bool? isCorrect;

  /// กำลังประมวลผลคำตอบอยู่หรือไม่
  final bool isProcessing;

  /// Callback เมื่อกดปุ่ม
  final Function(int) onAnswer;

  /// Custom display text (สำหรับ comparison game)
  final String Function(int)? displayTextBuilder;

  /// ขนาดปุ่ม
  final AnswerButtonSize buttonSize;

  /// ระยะห่างระหว่างปุ่ม
  final double spacing;

  const AnswerButtonGrid({
    super.key,
    required this.options,
    required this.correctAnswer,
    required this.isCorrect,
    required this.isProcessing,
    required this.onAnswer,
    this.displayTextBuilder,
    this.buttonSize = AnswerButtonSize.normal,
    this.spacing = 8.0, // ลดจาก 12.0 เป็น 8.0
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), // ลด padding
      child: Wrap(
        spacing: spacing,
        runSpacing: spacing,
        alignment: WrapAlignment.center,
        children: options.map((option) {
          // คำนวณสีปุ่มตาม state
          Color? buttonColor;
          if (isCorrect != null) {
            if (option == correctAnswer) {
              buttonColor = AppColors.success;
            } else if (isCorrect == false) {
              buttonColor = AppColors.withOpacity(AppColors.error, 0.7);
            }
          }

          // สร้างปุ่ม
          final displayText = displayTextBuilder?.call(option);

          return displayText != null
              ? AnswerButton.symbol(
                  value: option,
                  symbol: displayText,
                  backgroundColor: buttonColor,
                  size: buttonSize,
                  onPressed: (isCorrect == null && !isProcessing)
                      ? () => onAnswer(option)
                      : null,
                )
              : AnswerButton.number(
                  value: option,
                  backgroundColor: buttonColor,
                  size: buttonSize,
                  onPressed: (isCorrect == null && !isProcessing)
                      ? () => onAnswer(option)
                      : null,
                );
        }).toList(),
      ),
    );
  }
}
