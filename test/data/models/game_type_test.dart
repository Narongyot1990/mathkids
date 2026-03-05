import 'package:flutter_test/flutter_test.dart';
import 'package:mathkids_adventure/data/models/game_type.dart';

void main() {
  group('GameType Enum', () {
    test('should have all game types', () {
      expect(GameType.values.length, 6);
      expect(GameType.values, contains(GameType.counting));
      expect(GameType.values, contains(GameType.addition));
      expect(GameType.values, contains(GameType.subtraction));
      expect(GameType.values, contains(GameType.comparison));
      expect(GameType.values, contains(GameType.sequence));
      expect(GameType.values, contains(GameType.mathGrid));
    });

    test('should return correct display name', () {
      expect(GameType.counting.displayName, 'นับเลข');
      expect(GameType.addition.displayName, 'บวก');
      expect(GameType.subtraction.displayName, 'ลบ');
      expect(GameType.comparison.displayName, 'เปรียบเทียบ');
      expect(GameType.sequence.displayName, 'หาลำดับ');
      expect(GameType.mathGrid.displayName, 'ตารางคณิตศาสตร์');
    });

    test('should return correct emoji', () {
      expect(GameType.counting.emoji, isNotEmpty);
      expect(GameType.addition.emoji, isNotEmpty);
      expect(GameType.subtraction.emoji, isNotEmpty);
      expect(GameType.comparison.emoji, isNotEmpty);
      expect(GameType.sequence.emoji, isNotEmpty);
      expect(GameType.mathGrid.emoji, isNotEmpty);
    });
  });

  group('Difficulty Enum', () {
    test('should have all difficulty levels', () {
      expect(Difficulty.values.length, 3);
      expect(Difficulty.values, contains(Difficulty.easy));
      expect(Difficulty.values, contains(Difficulty.medium));
      expect(Difficulty.values, contains(Difficulty.hard));
    });

    test('should return correct display name', () {
      expect(Difficulty.easy.displayName, 'ง่าย');
      expect(Difficulty.medium.displayName, 'ปานกลาง');
      expect(Difficulty.hard.displayName, 'ยาก');
    });
  });
}
