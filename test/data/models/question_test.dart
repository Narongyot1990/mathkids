import 'package:flutter_test/flutter_test.dart';
import 'package:mathkids_adventure/data/models/question.dart';

void main() {
  group('Question Model', () {
    test('should create question with required fields', () {
      final question = Question(
        questionText: '1 + 1 = ?',
        correctAnswer: 2,
        options: [1, 2, 3, 4],
      );

      expect(question.questionText, '1 + 1 = ?');
      expect(question.correctAnswer, 2);
      expect(question.options, [1, 2, 3, 4]);
    });

    test('should create question with counting data', () {
      final question = Question(
        questionText: 'นับแอปเปิ้ล',
        correctAnswer: 3,
        options: [1, 2, 3, 4],
        imageCount: 3,
        operand1: 3,
      );

      expect(question.imageCount, 3);
      expect(question.operand1, 3);
    });

    test('should create question with math operation data', () {
      final question = Question(
        questionText: '2 + 3 = ?',
        correctAnswer: 5,
        options: [3, 4, 5, 6],
        operand1: 2,
        operand2: 3,
      );

      expect(question.operand1, 2);
      expect(question.operand2, 3);
    });

    test('should create question with comparison data', () {
      final question = Question(
        questionText: 'เปรียบเทียบ',
        correctAnswer: 1,
        options: [0, 1, 2],
        leftCount: 5,
        rightCount: 3,
        comparisonSymbol: '>',
      );

      expect(question.leftCount, 5);
      expect(question.rightCount, 3);
      expect(question.comparisonSymbol, '>');
    });

    test('should create question with sequence data', () {
      final question = Question(
        questionText: 'หาลำดับ',
        correctAnswer: 4,
        options: [2, 3, 4, 5],
        sequence: [1, 2, 3, 4, 5],
      );

      expect(question.sequence, [1, 2, 3, 4, 5]);
    });

    test('should create question with math grid data', () {
      final question = Question(
        questionText: 'ตารางคณิตศาสตร์',
        correctAnswer: 3,
        options: [1, 2, 3, 4],
        gridLayout: ['1', '+', '2', '=', '?'],
        dragOptions: [1, 2, 3, 4],
      );

      expect(question.gridLayout, ['1', '+', '2', '=', '?']);
      expect(question.dragOptions, [1, 2, 3, 4]);
    });
  });
}
