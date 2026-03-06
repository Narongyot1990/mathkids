/// Addition Questions - เกมบวกเลข (Visual Addition)
library;

import 'question_config.dart';

class AdditionQuestions {
  AdditionQuestions._();

  /// All addition questions (Levels 1-30)
  static final List<QuestionTemplate> bank = [
    // Level 1 - 1+1 to 1+3 (Basic)
    _q(1, 3, '1 + 1 = ?', 1, 1, 2, 3),
    _q(2, 3, '1 + 2 = ?', 2, 1, 3, 4),
    _q(3, 3, '1 + 3 = ?', 3, 2, 4, 5),
    
    // Level 4-6 - 2+1 to 2+3
    _q(4, 3, '2 + 1 = ?', 2, 1, 3, 4),
    _q(5, 3, '2 + 2 = ?', 3, 1, 4, 5),
    _q(6, 3, '2 + 3 = ?', 4, 2, 5, 6),
    
    // Level 7-10 - 3+1 to 3+4
    _q(7, 4, '3 + 1 = ?', 3, 2, 4, 5),
    _q(8, 4, '3 + 2 = ?', 4, 2, 5, 6),
    _q(9, 4, '3 + 3 = ?', 5, 4, 6, 7),
    _q(10, 4, '3 + 4 = ?', 6, 5, 7, 8),
    
    // Level 11-15 - 4+1 to 4+5
    _q(11, 4, '4 + 1 = ?', 4, 3, 5, 6),
    _q(12, 4, '4 + 2 = ?', 5, 3, 6, 7),
    _q(13, 4, '4 + 3 = ?', 6, 4, 7, 8),
    _q(14, 4, '4 + 4 = ?', 7, 5, 8, 9),
    _q(15, 4, '4 + 5 = ?', 8, 6, 9, 10),
    
    // Level 16-20 - 5+1 to 5+5
    _q(16, 5, '5 + 1 = ?', 5, 4, 6, 7),
    _q(17, 5, '5 + 2 = ?', 6, 4, 7, 8),
    _q(18, 5, '5 + 3 = ?', 7, 5, 8, 9),
    _q(19, 5, '5 + 4 = ?', 8, 6, 9, 10),
    _q(20, 5, '5 + 5 = ?', 9, 7, 10, 11),
    
    // Level 21-25 - 6+1 to 6+6
    _q(21, 5, '6 + 1 = ?', 6, 5, 7, 8),
    _q(22, 5, '6 + 2 = ?', 7, 5, 8, 9),
    _q(23, 5, '6 + 3 = ?', 8, 6, 9, 10),
    _q(24, 5, '6 + 4 = ?', 9, 7, 10, 11),
    _q(25, 5, '6 + 5 = ?', 10, 8, 11, 12),
    
    // Level 26-30 - 7+1 to 8+8 (Advanced)
    _q(26, 6, '7 + 1 = ?', 7, 6, 8, 9),
    _q(27, 6, '7 + 2 = ?', 8, 6, 9, 10),
    _q(28, 6, '7 + 3 = ?', 9, 7, 10, 11),
    _q(29, 6, '8 + 2 = ?', 9, 7, 10, 11),
    _q(30, 6, '8 + 3 = ?', 10, 8, 11, 12),
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
    final parts = question.split(' '); // "1 + 1 = ?"
    final operand1 = int.parse(parts[0]);
    final operand2 = int.parse(parts[2]);
    
    return QuestionTemplate(
      level: level,
      recommendedAge: age,
      question: question,
      correctAnswer: correct,
      wrongAnswers: [wrong1, wrong2, wrong3],
      data: QuestionData.addition(operand1, operand2),
      hint: 'นับรวมกัน',
      encouragement: 'เก่งมาก! 🎉',
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
