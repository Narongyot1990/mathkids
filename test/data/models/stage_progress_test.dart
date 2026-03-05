import 'package:flutter_test/flutter_test.dart';
import 'package:mathkids_adventure/data/models/stage_progress.dart';

void main() {
  group('StageProgress Model', () {
    test('should create with default values', () {
      final progress = StageProgress(stageNumber: 1);

      expect(progress.stageNumber, 1);
      expect(progress.stars, 0);
      expect(progress.score, 0);
      expect(progress.isUnlocked, false);
      expect(progress.isCompleted, false);
    });

    test('should create with all values', () {
      final progress = StageProgress(
        stageNumber: 5,
        stars: 3,
        score: 100,
        isUnlocked: true,
        isCompleted: true,
      );

      expect(progress.stageNumber, 5);
      expect(progress.stars, 3);
      expect(progress.score, 100);
      expect(progress.isUnlocked, true);
      expect(progress.isCompleted, true);
    });

    test('should convert to JSON', () {
      final progress = StageProgress(
        stageNumber: 3,
        stars: 2,
        score: 80,
        isUnlocked: true,
        isCompleted: true,
      );

      final json = progress.toJson();

      expect(json['stageNumber'], 3);
      expect(json['stars'], 2);
      expect(json['score'], 80);
      expect(json['isUnlocked'], true);
      expect(json['isCompleted'], true);
    });

    test('should create from JSON', () {
      final json = {
        'stageNumber': 4,
        'stars': 3,
        'score': 100,
        'isUnlocked': true,
        'isCompleted': true,
      };

      final progress = StageProgress.fromJson(json);

      expect(progress.stageNumber, 4);
      expect(progress.stars, 3);
      expect(progress.score, 100);
      expect(progress.isUnlocked, true);
      expect(progress.isCompleted, true);
    });

    test('should handle missing values in JSON', () {
      final json = <String, dynamic>{
        'stageNumber': 1,
      };

      final progress = StageProgress.fromJson(json);

      expect(progress.stageNumber, 1);
      expect(progress.stars, 0);
      expect(progress.score, 0);
      expect(progress.isUnlocked, false);
      expect(progress.isCompleted, false);
    });

    test('should copy with new values', () {
      final original = StageProgress(
        stageNumber: 1,
        stars: 1,
        score: 50,
        isUnlocked: true,
        isCompleted: false,
      );

      final copied = original.copyWith(
        stars: 3,
        score: 100,
        isCompleted: true,
      );

      expect(copied.stageNumber, 1);
      expect(copied.stars, 3);
      expect(copied.score, 100);
      expect(copied.isUnlocked, true);
      expect(copied.isCompleted, true);
    });

    test('should copy without changes', () {
      final original = StageProgress(
        stageNumber: 2,
        stars: 2,
        score: 70,
        isUnlocked: true,
        isCompleted: true,
      );

      final copied = original.copyWith();

      expect(copied.stageNumber, original.stageNumber);
      expect(copied.stars, original.stars);
      expect(copied.score, original.score);
      expect(copied.isUnlocked, original.isUnlocked);
      expect(copied.isCompleted, original.isCompleted);
    });
  });
}
