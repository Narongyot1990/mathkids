import 'package:flutter_test/flutter_test.dart';
import 'package:mathkids_adventure/data/models/game_type.dart';
import 'package:mathkids_adventure/data/question_bank/question_bank.dart';

void main() {
  group('QuestionBank', () {
    test('should get question for counting game', () {
      final question = QuestionBank.getQuestion(GameType.counting, 1);

      expect(question.questionText, isNotEmpty);
      expect(question.correctAnswer, isPositive);
    });

    test('should get question for addition game', () {
      final question = QuestionBank.getQuestion(GameType.addition, 1);

      expect(question.questionText, isNotEmpty);
      expect(question.correctAnswer, isPositive);
    });

    test('should get question for subtraction game', () {
      final question = QuestionBank.getQuestion(GameType.subtraction, 1);

      expect(question.questionText, isNotEmpty);
    });

    test('should get question for comparison game', () {
      final question = QuestionBank.getQuestion(GameType.comparison, 1);

      expect(question.questionText, isNotEmpty);
    });

    test('should get question for sequence game', () {
      final question = QuestionBank.getQuestion(GameType.sequence, 1);

      expect(question.questionText, isNotEmpty);
    });

    test('should get question for mathGrid game (fallback to addition)', () {
      final question = QuestionBank.getQuestion(GameType.mathGrid, 1);

      expect(question.questionText, isNotEmpty);
    });

    test('should get total levels for counting', () {
      final total = QuestionBank.getTotalLevels(GameType.counting);

      expect(total, greaterThan(0));
    });

    test('should get total levels for addition', () {
      final total = QuestionBank.getTotalLevels(GameType.addition);

      expect(total, greaterThan(0));
    });

    test('should get total levels for subtraction', () {
      final total = QuestionBank.getTotalLevels(GameType.subtraction);

      expect(total, greaterThan(0));
    });

    test('should get total levels for comparison', () {
      final total = QuestionBank.getTotalLevels(GameType.comparison);

      expect(total, greaterThan(0));
    });

    test('should get total levels for sequence', () {
      final total = QuestionBank.getTotalLevels(GameType.sequence);

      expect(total, greaterThan(0));
    });

    test('should get total levels for mathGrid', () {
      final total = QuestionBank.getTotalLevels(GameType.mathGrid);

      expect(total, 10);
    });

    test('should get all questions for counting', () {
      final questions = QuestionBank.getAllQuestions(GameType.counting);

      expect(questions, isNotEmpty);
    });

    test('should get all questions for addition', () {
      final questions = QuestionBank.getAllQuestions(GameType.addition);

      expect(questions, isNotEmpty);
    });

    test('should get all questions for subtraction', () {
      final questions = QuestionBank.getAllQuestions(GameType.subtraction);

      expect(questions, isNotEmpty);
    });

    test('should get all questions for comparison', () {
      final questions = QuestionBank.getAllQuestions(GameType.comparison);

      expect(questions, isNotEmpty);
    });

    test('should get all questions for sequence', () {
      final questions = QuestionBank.getAllQuestions(GameType.sequence);

      expect(questions, isNotEmpty);
    });

    test('should return empty list for mathGrid', () {
      final questions = QuestionBank.getAllQuestions(GameType.mathGrid);

      expect(questions, isEmpty);
    });

    test('should return question with options', () {
      final question = QuestionBank.getQuestion(GameType.addition, 1);

      expect(question.options, isNotEmpty);
      expect(question.options.length, 4);
    });
  });
}
