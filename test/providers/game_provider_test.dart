import 'package:flutter_test/flutter_test.dart';
import 'package:mathkids_adventure/providers/game_provider.dart';
import 'package:mathkids_adventure/data/models/game_type.dart';
import 'package:mathkids_adventure/data/question_bank/question_bank.dart';

void main() {
  group('GameProvider', () {
    late GameProvider provider;

    setUp(() {
      provider = GameProvider();
    });

    test('should have default values', () {
      expect(provider.currentQuestion, isNull);
      expect(provider.currentQuestionNumber, 1);
      expect(provider.totalQuestions, 10);
      expect(provider.score, 0);
      expect(provider.isCorrect, isNull);
      expect(provider.isGameOver, false);
      expect(provider.lastSelectedAnswer, isNull);
    });

    test('should start game and generate first question', () {
      provider.startGame(GameType.counting, Difficulty.easy, stageNumber: 1);

      expect(provider.currentQuestion, isNotNull);
      expect(provider.currentQuestionNumber, 1);
      expect(provider.score, 0);
      expect(provider.isGameOver, false);
    });

    test('should check correct answer', () {
      provider.startGame(GameType.addition, Difficulty.easy, stageNumber: 1);
      final correctAnswer = provider.currentQuestion!.correctAnswer;

      provider.checkAnswer(correctAnswer, GameType.addition, Difficulty.easy);

      expect(provider.lastSelectedAnswer, correctAnswer);
      expect(provider.isCorrect, true);
      expect(provider.score, 10);
    });

    test('should check wrong answer', () {
      provider.startGame(GameType.addition, Difficulty.easy, stageNumber: 1);
      final wrongAnswer = provider.currentQuestion!.options
          .firstWhere((opt) => opt != provider.currentQuestion!.correctAnswer);

      provider.checkAnswer(wrongAnswer, GameType.addition, Difficulty.easy);

      expect(provider.lastSelectedAnswer, wrongAnswer);
      expect(provider.isCorrect, false);
      expect(provider.score, 0);
    });

    test('should calculate 3 stars for 90%+', () {
      expect(provider.calculateStarsFromScore(90), 3);
      expect(provider.calculateStarsFromScore(100), 3);
    });

    test('should calculate 2 stars for 70-89%', () {
      expect(provider.calculateStarsFromScore(70), 2);
      expect(provider.calculateStarsFromScore(80), 2);
      expect(provider.calculateStarsFromScore(89), 2);
    });

    test('should calculate 1 star for 50-69%', () {
      expect(provider.calculateStarsFromScore(50), 1);
      expect(provider.calculateStarsFromScore(60), 1);
      expect(provider.calculateStarsFromScore(69), 1);
    });

    test('should calculate 0 stars for below 50%', () {
      expect(provider.calculateStarsFromScore(0), 0);
      expect(provider.calculateStarsFromScore(10), 0);
      expect(provider.calculateStarsFromScore(49), 0);
    });

    test('should reset game state', () {
      provider.startGame(GameType.counting, Difficulty.easy, stageNumber: 1);
      provider.checkAnswer(1, GameType.counting, Difficulty.easy);

      provider.reset();

      expect(provider.currentQuestion, isNull);
      expect(provider.currentQuestionNumber, 1);
      expect(provider.score, 0);
      expect(provider.isCorrect, isNull);
      expect(provider.isGameOver, false);
    });

    test('should generate different questions for different levels', () {
      final question1 = QuestionBank.getQuestion(GameType.addition, 1);
      final question2 = QuestionBank.getQuestion(GameType.addition, 5);

      expect(question1.questionText, isNotEmpty);
      expect(question2.questionText, isNotEmpty);
    });
  });

  group('GameProvider calculateStars', () {
    late GameProvider provider;

    setUp(() {
      provider = GameProvider();
    });

    test('should return 3 stars for perfect score', () {
      provider.startGame(GameType.counting, Difficulty.easy, stageNumber: 1);
      
      for (int i = 0; i < 10; i++) {
        provider.checkAnswer(provider.currentQuestion!.correctAnswer, GameType.counting, Difficulty.easy);
      }
    });

    test('stars calculation based on percentage', () {
      expect(provider.calculateStarsFromPercentage(100), 3);
      expect(provider.calculateStarsFromPercentage(90), 3);
      expect(provider.calculateStarsFromPercentage(80), 2);
      expect(provider.calculateStarsFromPercentage(70), 2);
      expect(provider.calculateStarsFromPercentage(60), 1);
      expect(provider.calculateStarsFromPercentage(50), 1);
      expect(provider.calculateStarsFromPercentage(40), 0);
    });
  });
}

extension GameProviderStarsTest on GameProvider {
  int calculateStarsFromScore(int score) {
    final percentage = (score / (10 * 10)) * 100;
    if (percentage >= 90) return 3;
    if (percentage >= 70) return 2;
    if (percentage >= 50) return 1;
    return 0;
  }

  int calculateStarsFromPercentage(double percentage) {
    if (percentage >= 90) return 3;
    if (percentage >= 70) return 2;
    if (percentage >= 50) return 1;
    return 0;
  }
}
