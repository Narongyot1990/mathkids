import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/kid_stats.dart';
import '../models/game_type.dart';

/// Stats Repository - Simplified
/// จัดการ load/save สถิติเด็กผ่าน SharedPreferences
class StatsRepository {
  static const String _statsKey = 'kid_stats';

  /// Load stats จาก storage
  Future<KidStats> loadStats() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_statsKey);

      if (jsonString == null) {
        return KidStats.empty();
      }

      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return KidStats.fromJson(json);
    } catch (e) {
      debugPrint('Error loading stats: $e');
      return KidStats.empty();
    }
  }

  /// Save stats ไปยัง storage
  Future<void> saveStats(KidStats stats) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = jsonEncode(stats.toJson());
      await prefs.setString(_statsKey, jsonString);
    } catch (e) {
      debugPrint('Error saving stats: $e');
    }
  }

  /// อัพเดทสถิติหลังเล่นเกมเสร็จ
  Future<KidStats> updateStatsAfterGame({
    required GameType gameType,
    required int score,
    required int stars,
    required int correctAnswers, // ข้อถูก
    required int totalQuestions,  // จำนวนข้อทั้งหมด
  }) async {
    final currentStats = await loadStats();
    final today = DateTime.now();

    // Update game play counts
    final newGamePlayCounts = Map<GameType, int>.from(currentStats.gamePlayCounts);
    newGamePlayCounts[gameType] = (newGamePlayCounts[gameType] ?? 0) + 1;

    // Update high scores
    final newGameHighScores = Map<GameType, int>.from(currentStats.gameHighScores);
    final currentHighScore = newGameHighScores[gameType] ?? 0;
    if (score > currentHighScore) {
      newGameHighScores[gameType] = score;
    }

    // Calculate new streak
    final newStreak = currentStats.calculateStreak(today);

    // Update stats
    final updatedStats = currentStats.copyWith(
      totalGamesPlayed: currentStats.totalGamesPlayed + 1,
      totalScore: currentStats.totalScore + score,
      totalStars: currentStats.totalStars + stars,
      totalCorrectAnswers: currentStats.totalCorrectAnswers + correctAnswers,
      totalAnswers: currentStats.totalAnswers + totalQuestions,
      playStreak: newStreak,
      lastPlayedDate: today,
      gamePlayCounts: newGamePlayCounts,
      gameHighScores: newGameHighScores,
    );

    // Find best game based on high scores
    final bestGame = updatedStats.findBestGame();
    final finalStats = updatedStats.copyWith(bestGame: bestGame);

    await saveStats(finalStats);
    return finalStats;
  }

  /// Reset stats (สำหรับทดสอบหรือเริ่มใหม่)
  Future<void> resetStats() async {
    await saveStats(KidStats.empty());
  }
}
