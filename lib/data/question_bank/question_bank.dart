/// Question Bank - ระบบจัดการคำถามทั้งหมด (Data-Driven)
///
/// แนวทาง Roblox-style:
/// - เก็บข้อมูลทั้งหมดเป็น static data
/// - ใช้ index ดึงข้อมูล
/// - ไม่ generate runtime
library;

import '../models/game_type.dart';
import '../models/question.dart';
import 'question_config.dart';
import 'addition_questions.dart';
import 'counting_questions.dart';
import 'subtraction_questions.dart';
import 'comparison_questions.dart';
import 'sequence_questions.dart';

/// Question Bank Manager - จัดการคำถามทุกเกม
class QuestionBank {
  QuestionBank._();

  /// ดึงคำถามตาม GameType และ Level
  static Question getQuestion(GameType gameType, int level) {
    final template = _getTemplate(gameType, level);
    return _templateToQuestion(template);
  }

  /// ดึง template จาก bank
  static QuestionTemplate _getTemplate(GameType gameType, int level) {
    switch (gameType) {
      case GameType.counting:
        return CountingQuestions.getQuestion(level);
      case GameType.addition:
        return AdditionQuestions.getQuestion(level);
      case GameType.subtraction:
        return SubtractionQuestions.getQuestion(level);
      case GameType.comparison:
        return ComparisonQuestions.getQuestion(level);
      case GameType.sequence:
        return SequenceQuestions.getQuestion(level);
      case GameType.mathGrid:
        // TODO: สร้าง MathGridQuestions (ยังไม่ได้ใช้ในระบบ 5 เกม)
        return AdditionQuestions.getQuestion(level);
    }
  }

  /// แปลง Template เป็น Question (legacy format)
  static Question _templateToQuestion(QuestionTemplate template) {
    final data = template.data;

    return Question(
      questionText: template.question,
      correctAnswer: template.correctAnswer,
      options: template.getOptions(),
      // Counting data
      imageCount: data.count,
      // Math operation data
      operand1: data.operand1,
      operand2: data.operand2,
      // Comparison data
      leftCount: data.leftCount,
      rightCount: data.rightCount,
      // Sequence data
      sequence: data.sequence,
      // Math grid data
      gridLayout: data.gridLayout,
      dragOptions: data.dragOptions,
    );
  }

  /// จำนวนด่านทั้งหมดของแต่ละเกม
  static int getTotalLevels(GameType gameType) {
    switch (gameType) {
      case GameType.counting:
        return CountingQuestions.totalLevels;
      case GameType.addition:
        return AdditionQuestions.totalLevels;
      case GameType.subtraction:
        return SubtractionQuestions.totalLevels;
      case GameType.comparison:
        return ComparisonQuestions.totalLevels;
      case GameType.sequence:
        return SequenceQuestions.totalLevels;
      case GameType.mathGrid:
        return 10; // TODO: MathGridQuestions (ยังไม่ได้ใช้)
    }
  }

  /// ดู preview คำถามทั้งหมดของเกม (สำหรับ debug)
  static List<QuestionTemplate> getAllQuestions(GameType gameType) {
    switch (gameType) {
      case GameType.counting:
        return CountingQuestions.bank;
      case GameType.addition:
        return AdditionQuestions.bank;
      case GameType.subtraction:
        return SubtractionQuestions.bank;
      case GameType.comparison:
        return ComparisonQuestions.bank;
      case GameType.sequence:
        return SequenceQuestions.bank;
      case GameType.mathGrid:
        return []; // TODO: MathGridQuestions (ยังไม่ได้ใช้)
    }
  }
}
