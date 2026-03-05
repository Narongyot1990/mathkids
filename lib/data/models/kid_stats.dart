import 'game_type.dart';

/// Kid Statistics Model - Simplified
/// เก็บสถิติหลักๆ ที่สำคัญเท่านั้น ไม่ซับซ้อน
class KidStats {
  final int totalGamesPlayed;     // จำนวนเกมที่เล่นทั้งหมด
  final int totalScore;            // คะแนนรวม
  final int totalStars;            // ดาวรวม
  final int totalCorrectAnswers;   // ข้อถูกทั้งหมด
  final int totalAnswers;          // จำนวนข้อทั้งหมด (ถูก+ผิด)
  final GameType? bestGame;        // เกมที่เล่นเก่งที่สุด
  final int playStreak;            // เล่นต่อเนื่องกี่วัน
  final DateTime? lastPlayedDate;  // วันที่เล่นครั้งล่าสุด
  final Map<GameType, int> gamePlayCounts;  // จำนวนครั้งที่เล่นแต่ละเกม
  final Map<GameType, int> gameHighScores;  // คะแนนสูงสุดแต่ละเกม

  const KidStats({
    this.totalGamesPlayed = 0,
    this.totalScore = 0,
    this.totalStars = 0,
    this.totalCorrectAnswers = 0,
    this.totalAnswers = 0,
    this.bestGame,
    this.playStreak = 0,
    this.lastPlayedDate,
    this.gamePlayCounts = const {},
    this.gameHighScores = const {},
  });

  /// สร้าง empty stats
  factory KidStats.empty() => const KidStats();

  /// สร้างจาก JSON (สำหรับ SharedPreferences)
  factory KidStats.fromJson(Map<String, dynamic> json) {
    return KidStats(
      totalGamesPlayed: json['totalGamesPlayed'] ?? 0,
      totalScore: json['totalScore'] ?? 0,
      totalStars: json['totalStars'] ?? 0,
      totalCorrectAnswers: json['totalCorrectAnswers'] ?? 0,
      totalAnswers: json['totalAnswers'] ?? 0,
      bestGame: json['bestGame'] != null
          ? GameType.values.firstWhere(
              (g) => g.name == json['bestGame'],
              orElse: () => GameType.counting,
            )
          : null,
      playStreak: json['playStreak'] ?? 0,
      lastPlayedDate: json['lastPlayedDate'] != null
          ? DateTime.parse(json['lastPlayedDate'])
          : null,
      gamePlayCounts: Map.unmodifiable(
          (json['gamePlayCounts'] as Map<String, dynamic>?)
              ?.map((key, value) => MapEntry(
                    GameType.values.firstWhere((g) => g.name == key),
                    value as int,
                  )) ??
          {},
      ),
      gameHighScores: Map.unmodifiable(
          (json['gameHighScores'] as Map<String, dynamic>?)
              ?.map((key, value) => MapEntry(
                    GameType.values.firstWhere((g) => g.name == key),
                    value as int,
                  )) ??
          {},
      ),
    );
  }

  /// แปลงเป็น JSON
  Map<String, dynamic> toJson() {
    return {
      'totalGamesPlayed': totalGamesPlayed,
      'totalScore': totalScore,
      'totalStars': totalStars,
      'totalCorrectAnswers': totalCorrectAnswers,
      'totalAnswers': totalAnswers,
      'bestGame': bestGame?.name,
      'playStreak': playStreak,
      'lastPlayedDate': lastPlayedDate?.toIso8601String(),
      'gamePlayCounts': gamePlayCounts.map((key, value) => MapEntry(key.name, value)),
      'gameHighScores': gameHighScores.map((key, value) => MapEntry(key.name, value)),
    };
  }

  /// Copy with new values
  KidStats copyWith({
    int? totalGamesPlayed,
    int? totalScore,
    int? totalStars,
    int? totalCorrectAnswers,
    int? totalAnswers,
    GameType? bestGame,
    int? playStreak,
    DateTime? lastPlayedDate,
    Map<GameType, int>? gamePlayCounts,
    Map<GameType, int>? gameHighScores,
  }) {
    return KidStats(
      totalGamesPlayed: totalGamesPlayed ?? this.totalGamesPlayed,
      totalScore: totalScore ?? this.totalScore,
      totalStars: totalStars ?? this.totalStars,
      totalCorrectAnswers: totalCorrectAnswers ?? this.totalCorrectAnswers,
      totalAnswers: totalAnswers ?? this.totalAnswers,
      bestGame: bestGame ?? this.bestGame,
      playStreak: playStreak ?? this.playStreak,
      lastPlayedDate: lastPlayedDate ?? this.lastPlayedDate,
      gamePlayCounts: gamePlayCounts != null ? Map.unmodifiable(gamePlayCounts) : this.gamePlayCounts,
      gameHighScores: gameHighScores != null ? Map.unmodifiable(gameHighScores) : this.gameHighScores,
    );
  }

  /// คำนวณ play streak
  int calculateStreak(DateTime today) {
    if (lastPlayedDate == null) return 0;

    final daysSinceLastPlay = today.difference(lastPlayedDate!).inDays;

    if (daysSinceLastPlay == 0) {
      // เล่นวันนี้แล้ว
      return playStreak;
    } else if (daysSinceLastPlay == 1) {
      // เล่นเมื่อวาน = ต่อ streak
      return playStreak + 1;
    } else {
      // เว้นเกิน 1 วัน = streak หลุด
      return 1;
    }
  }

  /// ค้นหาเกมที่เล่นเก่งที่สุด (คะแนนสูงสุด)
  GameType? findBestGame() {
    if (gameHighScores.isEmpty) return null;

    var maxScore = 0;
    GameType? bestGameType;

    for (final entry in gameHighScores.entries) {
      if (entry.value > maxScore) {
        maxScore = entry.value;
        bestGameType = entry.key;
      }
    }

    return bestGameType;
  }

  /// Average score per game
  double get averageScore {
    if (totalGamesPlayed == 0) return 0;
    return totalScore / totalGamesPlayed;
  }

  /// Accuracy rate (อัตราความแม่นยำ) เป็น %
  double get accuracyRate {
    if (totalAnswers == 0) return 0;
    return (totalCorrectAnswers / totalAnswers) * 100;
  }
}
