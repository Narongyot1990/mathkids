import 'package:flutter_test/flutter_test.dart';
import 'package:mathkids_adventure/data/question_bank/question_config.dart';

void main() {
  group('QuestionTemplate', () {
    test('should create with required fields', () {
      const template = QuestionTemplate(
        level: 1,
        recommendedAge: 3,
        question: '1 + 1 = ?',
        correctAnswer: 2,
        wrongAnswers: [1, 3, 4],
        data: QuestionData(operand1: 1, operand2: 1, operation: '+'),
      );

      expect(template.level, 1);
      expect(template.recommendedAge, 3);
      expect(template.question, '1 + 1 = ?');
      expect(template.correctAnswer, 2);
      expect(template.wrongAnswers, [1, 3, 4]);
    });

    test('should use question as questionShort when not provided', () {
      const template = QuestionTemplate(
        level: 1,
        recommendedAge: 3,
        question: 'Full question',
        correctAnswer: 2,
        wrongAnswers: [1, 3],
        data: QuestionData(),
      );

      expect(template.questionShort, 'Full question');
    });

    test('should use custom questionShort', () {
      const template = QuestionTemplate(
        level: 1,
        recommendedAge: 3,
        question: 'Full question',
        questionShort: 'Short question',
        correctAnswer: 2,
        wrongAnswers: [1, 3],
        data: QuestionData(),
      );

      expect(template.questionShort, 'Short question');
    });

    test('should get options including correct answer', () {
      const template = QuestionTemplate(
        level: 1,
        recommendedAge: 3,
        question: '1 + 1 = ?',
        correctAnswer: 2,
        wrongAnswers: [1, 3, 4],
        data: QuestionData(operand1: 1, operand2: 1),
      );

      final options = template.getOptions();

      expect(options.length, 4);
      expect(options, contains(2));
      expect(options, contains(1));
      expect(options, contains(3));
      expect(options, contains(4));
    });

    test('should have optional hint and encouragement', () {
      const template = QuestionTemplate(
        level: 1,
        recommendedAge: 3,
        question: '1 + 1 = ?',
        correctAnswer: 2,
        wrongAnswers: [1, 3],
        data: QuestionData(operand1: 1, operand2: 1),
        hint: 'นับเพิ่ม',
        encouragement: 'เก่งมาก!',
      );

      expect(template.hint, 'นับเพิ่ม');
      expect(template.encouragement, 'เก่งมาก!');
    });
  });

  group('QuestionData', () {
    test('should create with default values', () {
      const data = QuestionData();

      expect(data.context, isNull);
      expect(data.emoji, isNull);
      expect(data.count, isNull);
      expect(data.operand1, isNull);
      expect(data.operand2, isNull);
      expect(data.answerType, 'number');
    });

    test('should create counting factory', () {
      final data = QuestionData.counting(5);

      expect(data.count, 5);
      expect(data.emoji, isNotNull);
    });

    test('should create addition factory', () {
      final data = QuestionData.addition(2, 3);

      expect(data.operand1, 2);
      expect(data.operand2, 3);
      expect(data.operation, '+');
    });

    test('should create subtraction factory', () {
      final data = QuestionData.subtraction(5, 2);

      expect(data.operand1, 5);
      expect(data.operand2, 2);
      expect(data.operation, '-');
    });

    test('should create comparison factory', () {
      final data = QuestionData.comparison(5, 3);

      expect(data.leftCount, 5);
      expect(data.rightCount, 3);
    });

    test('should create sequence factory', () {
      final data = QuestionData.sequence([1, 2, 3, 4, 5], 1);

      expect(data.sequence, [1, 2, 3, 4, 5]);
      expect(data.step, 1);
    });

    test('should create mathGrid factory', () {
      final data = QuestionData.mathGrid(
        gridLayout: ['1', '+', '2', '=', '?'],
        dragOptions: [1, 2, 3, 4],
      );

      expect(data.gridLayout, ['1', '+', '2', '=', '?']);
      expect(data.dragOptions, [1, 2, 3, 4]);
    });

    test('should create with all fields', () {
      const data = QuestionData(
        context: 'แอปเปิ้ล',
        emoji: '🍎',
        storyContext: 'น้องมีแอปเปิ้ล 3 ลูก',
        count: 3,
        operand1: 1,
        operand2: 2,
        operation: '+',
        action: 'แม่ให้อีก',
        leftCount: 5,
        rightCount: 3,
        comparisonType: 'greater',
        sequence: [1, 2, 3],
        step: 1,
        patternType: '+1',
        gridLayout: ['1', '+', '2'],
        dragOptions: [1, 2, 3],
        answerType: 'number',
      );

      expect(data.context, 'แอปเปิ้ล');
      expect(data.emoji, '🍎');
      expect(data.storyContext, 'น้องมีแอปเปิ้ล 3 ลูก');
      expect(data.count, 3);
      expect(data.operand1, 1);
      expect(data.operand2, 2);
      expect(data.operation, '+');
      expect(data.action, 'แม่ให้อีก');
      expect(data.leftCount, 5);
      expect(data.rightCount, 3);
      expect(data.comparisonType, 'greater');
      expect(data.sequence, [1, 2, 3]);
      expect(data.step, 1);
      expect(data.patternType, '+1');
      expect(data.gridLayout, ['1', '+', '2']);
      expect(data.dragOptions, [1, 2, 3]);
      expect(data.answerType, 'number');
    });
  });
}
