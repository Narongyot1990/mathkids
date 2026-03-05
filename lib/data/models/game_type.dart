import '../../core/assets/game_emojis.dart';

enum GameType {
  counting,
  addition,
  subtraction,
  comparison,
  sequence,
  mathGrid,
}

extension GameTypeExtension on GameType {
  String get displayName {
    switch (this) {
      case GameType.counting:
        return 'นับเลข';
      case GameType.addition:
        return 'บวก';
      case GameType.subtraction:
        return 'ลบ';
      case GameType.comparison:
        return 'เปรียบเทียบ';
      case GameType.sequence:
        return 'หาลำดับ';
      case GameType.mathGrid:
        return 'ตารางคณิตศาสตร์';
    }
  }

  String get emoji {
    switch (this) {
      case GameType.counting:
        return GameEmojis.gameTypes.counting;
      case GameType.addition:
        return GameEmojis.gameTypes.addition;
      case GameType.subtraction:
        return GameEmojis.gameTypes.subtraction;
      case GameType.comparison:
        return GameEmojis.gameTypes.comparison;
      case GameType.sequence:
        return GameEmojis.gameTypes.sequence;
      case GameType.mathGrid:
        return GameEmojis.gameTypes.mathGrid;
    }
  }
}

enum Difficulty { easy, medium, hard }

extension DifficultyExtension on Difficulty {
  String get displayName {
    switch (this) {
      case Difficulty.easy:
        return 'ง่าย';
      case Difficulty.medium:
        return 'ปานกลาง';
      case Difficulty.hard:
        return 'ยาก';
    }
  }
}
