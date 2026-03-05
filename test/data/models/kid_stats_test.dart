import 'package:flutter_test/flutter_test.dart';
import 'package:mathkids_adventure/data/models/kid_stats.dart';
import 'package:mathkids_adventure/data/models/game_type.dart';

void main() {
  group('KidStats Model', () {
    test('should create with default values', () {
      final stats = KidStats();

      expect(stats.totalGamesPlayed, 0);
      expect(stats.totalScore, 0);
      expect(stats.totalStars, 0);
      expect(stats.totalCorrectAnswers, 0);
      expect(stats.totalAnswers, 0);
      expect(stats.bestGame, isNull);
      expect(stats.playStreak, 0);
      expect(stats.lastPlayedDate, isNull);
      expect(stats.gamePlayCounts, isEmpty);
      expect(stats.gameHighScores, isEmpty);
    });

    test('should create empty stats factory', () {
      final stats = KidStats.empty();

      expect(stats.totalGamesPlayed, 0);
      expect(stats.totalScore, 0);
    });

    test('should create with custom values', () {
      final stats = KidStats(
        totalGamesPlayed: 10,
        totalScore: 500,
        totalStars: 25,
        totalCorrectAnswers: 80,
        totalAnswers: 100,
        bestGame: GameType.addition,
        playStreak: 5,
        lastPlayedDate: DateTime(2025, 1, 1),
        gamePlayCounts: {GameType.counting: 5},
        gameHighScores: {GameType.addition: 100},
      );

      expect(stats.totalGamesPlayed, 10);
      expect(stats.totalScore, 500);
      expect(stats.totalStars, 25);
      expect(stats.totalCorrectAnswers, 80);
      expect(stats.totalAnswers, 100);
      expect(stats.bestGame, GameType.addition);
      expect(stats.playStreak, 5);
      expect(stats.gamePlayCounts[GameType.counting], 5);
      expect(stats.gameHighScores[GameType.addition], 100);
    });

    test('should convert to JSON', () {
      final stats = KidStats(
        totalGamesPlayed: 5,
        totalScore: 250,
        totalStars: 12,
        totalCorrectAnswers: 40,
        totalAnswers: 50,
        bestGame: GameType.counting,
        playStreak: 3,
        lastPlayedDate: DateTime(2025, 1, 15),
        gamePlayCounts: {GameType.counting: 3},
        gameHighScores: {GameType.counting: 80},
      );

      final json = stats.toJson();

      expect(json['totalGamesPlayed'], 5);
      expect(json['totalScore'], 250);
      expect(json['totalStars'], 12);
      expect(json['totalCorrectAnswers'], 40);
      expect(json['totalAnswers'], 50);
      expect(json['bestGame'], 'counting');
      expect(json['playStreak'], 3);
      expect(json['lastPlayedDate'], isNotNull);
      expect(json['gamePlayCounts'], isA<Map>());
      expect(json['gameHighScores'], isA<Map>());
    });

    test('should create from JSON', () {
      final json = {
        'totalGamesPlayed': 8,
        'totalScore': 400,
        'totalStars': 20,
        'totalCorrectAnswers': 60,
        'totalAnswers': 80,
        'bestGame': 'addition',
        'playStreak': 4,
        'lastPlayedDate': '2025-01-20T00:00:00.000',
        'gamePlayCounts': {'counting': 4},
        'gameHighScores': {'addition': 90},
      };

      final stats = KidStats.fromJson(json);

      expect(stats.totalGamesPlayed, 8);
      expect(stats.totalScore, 400);
      expect(stats.totalStars, 20);
      expect(stats.totalCorrectAnswers, 60);
      expect(stats.totalAnswers, 80);
      expect(stats.bestGame, GameType.addition);
      expect(stats.playStreak, 4);
      expect(stats.lastPlayedDate, isNotNull);
      expect(stats.gamePlayCounts[GameType.counting], 4);
      expect(stats.gameHighScores[GameType.addition], 90);
    });

    test('should handle missing values in JSON', () {
      final json = <String, dynamic>{};

      final stats = KidStats.fromJson(json);

      expect(stats.totalGamesPlayed, 0);
      expect(stats.totalScore, 0);
      expect(stats.bestGame, isNull);
      expect(stats.lastPlayedDate, isNull);
    });

    test('should handle invalid game type in JSON', () {
      final json = {
        'bestGame': 'invalid_game',
      };

      final stats = KidStats.fromJson(json);

      expect(stats.bestGame, GameType.counting);
    });

    test('should copy with new values', () {
      final original = KidStats(
        totalGamesPlayed: 5,
        totalScore: 100,
      );

      final copied = original.copyWith(
        totalGamesPlayed: 10,
        totalScore: 200,
        totalStars: 15,
      );

      expect(copied.totalGamesPlayed, 10);
      expect(copied.totalScore, 200);
      expect(copied.totalStars, 15);
    });

    test('should calculate streak when played today', () {
      final today = DateTime(2025, 1, 15);
      final stats = KidStats(
        playStreak: 5,
        lastPlayedDate: today,
      );

      final streak = stats.calculateStreak(today);

      expect(streak, 5);
    });

    test('should calculate streak when played yesterday', () {
      final yesterday = DateTime(2025, 1, 14);
      final today = DateTime(2025, 1, 15);
      final stats = KidStats(
        playStreak: 3,
        lastPlayedDate: yesterday,
      );

      final streak = stats.calculateStreak(today);

      expect(streak, 4);
    });

    test('should reset streak when skipped days', () {
      final twoDaysAgo = DateTime(2025, 1, 13);
      final today = DateTime(2025, 1, 15);
      final stats = KidStats(
        playStreak: 5,
        lastPlayedDate: twoDaysAgo,
      );

      final streak = stats.calculateStreak(today);

      expect(streak, 1);
    });

    test('should return 0 streak when never played', () {
      final stats = KidStats();

      final streak = stats.calculateStreak(DateTime.now());

      expect(streak, 0);
    });

    test('should find best game', () {
      final stats = KidStats(
        gameHighScores: {
          GameType.counting: 50,
          GameType.addition: 100,
          GameType.subtraction: 30,
        },
      );

      final bestGame = stats.findBestGame();

      expect(bestGame, GameType.addition);
    });

    test('should return null when no high scores', () {
      final stats = KidStats();

      final bestGame = stats.findBestGame();

      expect(bestGame, isNull);
    });

    test('should calculate average score', () {
      final stats = KidStats(
        totalGamesPlayed: 10,
        totalScore: 500,
      );

      expect(stats.averageScore, 50.0);
    });

    test('should return 0 average when no games played', () {
      final stats = KidStats();

      expect(stats.averageScore, 0);
    });

    test('should calculate accuracy rate', () {
      final stats = KidStats(
        totalCorrectAnswers: 80,
        totalAnswers: 100,
      );

      expect(stats.accuracyRate, 80.0);
    });

    test('should return 0 accuracy when no answers', () {
      final stats = KidStats();

      expect(stats.accuracyRate, 0);
    });
  });
}
