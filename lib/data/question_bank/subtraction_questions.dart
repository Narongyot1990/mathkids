/// Subtraction Questions - เกมลบเลข (Visual Subtraction)
library;

import 'question_config.dart';

class SubtractionQuestions {
  SubtractionQuestions._();

  /// All subtraction questions (Levels 1-30)
  static final List<QuestionTemplate> bank = [
    // Level 1-5 - Basic subtraction (1-3)
    _q(1, 3, '2 - 1 = ?', 1, 2, 3, 0),
    _q(2, 3, '3 - 1 = ?', 2, 1, 3, 4),
    _q(3, 3, '3 - 2 = ?', 1, 2, 0, 3),
    _q(4, 3, '4 - 1 = ?', 3, 2, 4, 5),
    _q(5, 3, '4 - 2 = ?', 2, 1, 3, 4),
    
    // Level 6-10 - Subtraction with 4-5
    _q(6, 4, '4 - 3 = ?', 1, 2, 0, 3),
    _q(7, 4, '5 - 1 = ?', 4, 3, 5, 6),
    _q(8, 4, '5 - 2 = ?', 3, 2, 4, 5),
    _q(9, 4, '5 - 3 = ?', 2, 1, 3, 4),
    _q(10, 4, '5 - 4 = ?', 1, 2, 0, 3),
    
    // Level 11-15 - Subtraction with 6-7
    _q(11, 4, '6 - 1 = ?', 5, 4, 6, 7),
    _q(12, 4, '6 - 2 = ?', 4, 3, 5, 6),
    _q(13, 4, '6 - 3 = ?', 3, 2, 4, 5),
    _q(14, 4, '6 - 4 = ?', 2, 1, 3, 4),
    _q(15, 4, '6 - 5 = ?', 1, 2, 0, 3),
    
    // Level 16-20 - Subtraction with 7-8
    _q(16, 5, '7 - 1 = ?', 6, 5, 7, 8),
    _q(17, 5, '7 - 2 = ?', 5, 4, 6, 7),
    _q(18, 5, '7 - 3 = ?', 4, 3, 5, 6),
    _q(19, 5, '7 - 4 = ?', 3, 2, 4, 5),
    _q(20, 5, '7 - 5 = ?', 2, 1, 3, 4),
    
    // Level 21-25 - Subtraction with 8-9
    _q(21, 5, '8 - 1 = ?', 7, 6, 8, 9),
    _q(22, 5, '8 - 2 = ?', 6, 5, 7, 8),
    _q(23, 5, '8 - 3 = ?', 5, 4, 6, 7),
    _q(24, 5, '8 - 4 = ?', 4, 3, 5, 6),
    _q(25, 5, '8 - 5 = ?', 3, 2, 4, 5),
    
    // Level 26-30 - Subtraction with 9-10
    _q(26, 6, '9 - 1 = ?', 8, 7, 9, 10),
    _q(27, 6, '9 - 2 = ?', 7, 6, 8, 9),
    _q(28, 6, '9 - 3 = ?', 6, 5, 7, 8),
    _q(29, 6, '9 - 4 = ?', 5, 4, 6, 7),
    _q(30, 6, '10 - 5 = ?', 5, 4, 6, 7),
  ];

  static QuestionTemplate _q(
    int level,
    int age,
    String question,
    int correct,
    int wrong1,
    int wrong2,
    int wrong3,
  ) {
    final parts = question.split(' '); // "2 - 1 = ?"
    final operand1 = int.parse(parts[0]);
    final operand2 = int.parse(parts[2]);
    
    return QuestionTemplate(
      level: level,
      recommendedAge: age,
      question: question,
      correctAnswer: correct,
      wrongAnswers: [wrong1, wrong2, wrong3],
      data: QuestionData.subtraction(operand1, operand2),
      hint: 'ลบออก',
      encouragement: 'ทำได้ดีมาก! 🌟',
    );
  }

  /// Get question by level (1-based index)
  static QuestionTemplate getQuestion(int level) {
    if (level < 1 || level > bank.length) {
      return bank[0];
    }
    return bank[level - 1];
  }

  /// Total number of levels
  static int get totalLevels => bank.length;
}
