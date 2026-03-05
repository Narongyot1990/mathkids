import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/models/game_type.dart';
import '../data/models/stage_progress.dart';
import '../data/question_bank/question_bank.dart';

class ProgressService {
  // ดึงจำนวนด่านจาก Question Bank (แทนที่จะ hardcode)
  // เตรียมไว้สำหรับ subscription ในอนาคต
  int getTotalStages(GameType gameType) {
    return QuestionBank.getTotalLevels(gameType);
  }

  // บันทึกความคืบหน้าของ stage
  // ⭐ เก็บ Best Score (คะแนนและดาวสูงสุด)
  Future<void> saveStageProgress(
    GameType gameType,
    int stageNumber,
    int stars,
    int score,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '${gameType.name}_stage_$stageNumber';

    // ดึงข้อมูลเก่า (ถ้ามี)
    final existingData = prefs.getString(key);
    int bestStars = stars;
    int bestScore = score;

    if (existingData != null) {
      try {
        final oldProgress = StageProgress.fromJson(
          jsonDecode(existingData) as Map<String, dynamic>,
        );

        // เก็บ Best Score - ดาวมากกว่า หรือดาวเท่ากันแต่คะแนนมากกว่า
        if (oldProgress.stars > stars) {
          bestStars = oldProgress.stars;
          bestScore = oldProgress.score;
        } else if (oldProgress.stars == stars && oldProgress.score > score) {
          bestScore = oldProgress.score;
        }
      } catch (e) {
        // ถ้า parse ไม่ได้ ให้ใช้คะแนนใหม่
      }
    }

    final progress = StageProgress(
      stageNumber: stageNumber,
      stars: bestStars,        // ✅ เก็บดาวที่ดีที่สุด
      score: bestScore,        // ✅ เก็บคะแนนที่ดีที่สุด
      isUnlocked: true,
      isCompleted: true,
    );

    await prefs.setString(key, jsonEncode(progress.toJson()));

    // ปลดล็อค stage ถัดไป (ถ้ามี)
    final totalStages = getTotalStages(gameType);
    if (stageNumber < totalStages) {
      await unlockStage(gameType, stageNumber + 1);
    }
  }

  // ปลดล็อค stage
  Future<void> unlockStage(GameType gameType, int stageNumber) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '${gameType.name}_stage_$stageNumber';

    // ถ้ายังไม่มีข้อมูล ให้สร้างใหม่
    final existingData = prefs.getString(key);
    if (existingData == null) {
      final progress = StageProgress(
        stageNumber: stageNumber,
        isUnlocked: true,
      );
      await prefs.setString(key, jsonEncode(progress.toJson()));
    } else {
      // ถ้ามีแล้ว ให้อัพเดทเฉพาะ isUnlocked
      final json = jsonDecode(existingData) as Map<String, dynamic>;
      json['isUnlocked'] = true;
      await prefs.setString(key, jsonEncode(json));
    }
  }

  // ดึงความคืบหน้าของ stage
  Future<StageProgress> getStageProgress(
    GameType gameType,
    int stageNumber,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '${gameType.name}_stage_$stageNumber';

    final data = prefs.getString(key);
    if (data == null) {
      // ด่าน 1 ปลดล็อคเสมอ
      return StageProgress(
        stageNumber: stageNumber,
        isUnlocked: stageNumber == 1,
      );
    }

    return StageProgress.fromJson(jsonDecode(data) as Map<String, dynamic>);
  }

  // ดึงความคืบหน้าทั้งหมดของเกม
  Future<List<StageProgress>> getAllStageProgress(GameType gameType) async {
    final stages = <StageProgress>[];
    final totalStages = getTotalStages(gameType);

    for (int i = 1; i <= totalStages; i++) {
      final progress = await getStageProgress(gameType, i);
      stages.add(progress);
    }

    return stages;
  }

  // รีเซ็ตความคืบหน้าทั้งหมด (สำหรับ debug)
  Future<void> resetAllProgress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  // รีเซ็ตความคืบหน้าของเกมเดียว
  Future<void> resetGameProgress(GameType gameType) async {
    final prefs = await SharedPreferences.getInstance();
    final totalStages = getTotalStages(gameType);
    for (int i = 1; i <= totalStages; i++) {
      final key = '${gameType.name}_stage_$i';
      await prefs.remove(key);
    }
  }
}
