/// Question Configuration - Data-Driven Question System
///
/// แนวทาง: เก็บข้อมูลทั้งหมดเป็น static data
/// ไม่ต้อง generate runtime, ดึงจาก index ได้เลย
library;

import '../../core/assets/game_emojis.dart';

/// Question Template - โครงสร้างของคำถาม 1 ข้อ
class QuestionTemplate {
  final int level;                    // ด่านที่
  final int recommendedAge;           // อายุที่แนะนำ (3-6 ขวบ)
  final String question;              // คำถามแบบเต็ม (มี context)
  final String questionShort;         // คำถามแบบสั้น (สำหรับ UI ขนาดเล็ก)
  final int correctAnswer;            // คำตอบที่ถูก
  final List<int> wrongAnswers;       // คำตอบที่ผิด
  final QuestionData data;            // ข้อมูลเพิ่มเติม (operands, emoji, etc.)
  final String? hint;                 // คำใบ้ (optional)
  final String? encouragement;        // กำลังใจเมื่อตอบถูก (optional)

  const QuestionTemplate({
    required this.level,
    required this.recommendedAge,
    required this.question,
    String? questionShort,
    required this.correctAnswer,
    required this.wrongAnswers,
    required this.data,
    this.hint,
    this.encouragement,
  }) : questionShort = questionShort ?? question;

  /// Get all options (shuffled)
  List<int> getOptions() {
    final options = [correctAnswer, ...wrongAnswers];
    options.shuffle();
    return options;
  }
}

/// Question Data - ข้อมูลเพิ่มเติมของคำถาม
class QuestionData {
  // Shared
  final String? context;        // บริบท เช่น "แอปเปิ้ล", "คุกกี้"
  final String? emoji;          // อิโมจิ เช่น "🍎", "🍪"
  final String? storyContext;   // เรื่องราว เช่น "น้องมีแอปเปิ้ล..."

  // Counting
  final int? count;

  // Addition/Subtraction
  final int? operand1;
  final int? operand2;
  final String? operation;
  final String? action;         // การกระทำ เช่น "แม่ให้อีก", "กินไป"

  // Comparison
  final int? leftCount;
  final int? rightCount;
  final String? comparisonType; // ประเภทการเปรียบเทียบ

  // Sequence
  final List<int>? sequence;
  final int? step;
  final String? patternType;    // รูปแบบ เช่น "+1", "+2", "even", "odd"

  // Math Grid
  final List<String>? gridLayout;
  final List<int>? dragOptions;

  // Answer Type
  final String answerType;      // ประเภทคำตอบ: "number", "text", "symbol", "emoji"

  const QuestionData({
    this.context,
    this.emoji,
    this.storyContext,
    this.count,
    this.operand1,
    this.operand2,
    this.operation,
    this.action,
    this.leftCount,
    this.rightCount,
    this.comparisonType,
    this.sequence,
    this.step,
    this.patternType,
    this.gridLayout,
    this.dragOptions,
    this.answerType = 'number',
  });

  /// Factory: Counting
  factory QuestionData.counting(int count) {
    return QuestionData(
      count: count,
      emoji: GameEmojis.counting.getByIndex(count),
    );
  }

  /// Factory: Addition
  factory QuestionData.addition(int operand1, int operand2) {
    return QuestionData(
      operand1: operand1,
      operand2: operand2,
      operation: '+',
    );
  }

  /// Factory: Subtraction
  factory QuestionData.subtraction(int operand1, int operand2) {
    return QuestionData(
      operand1: operand1,
      operand2: operand2,
      operation: '-',
    );
  }

  /// Factory: Comparison
  factory QuestionData.comparison(int leftCount, int rightCount) {
    return QuestionData(
      leftCount: leftCount,
      rightCount: rightCount,
    );
  }

  /// Factory: Sequence
  factory QuestionData.sequence(List<int> sequence, int step) {
    return QuestionData(
      sequence: sequence,
      step: step,
    );
  }

  /// Factory: MathGrid
  factory QuestionData.mathGrid({
    required List<String> gridLayout,
    required List<int> dragOptions,
  }) {
    return QuestionData(
      gridLayout: gridLayout,
      dragOptions: dragOptions,
    );
  }
}
