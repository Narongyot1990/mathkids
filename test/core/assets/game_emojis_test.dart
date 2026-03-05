import 'package:flutter_test/flutter_test.dart';
import 'package:mathkids_adventure/core/assets/game_emojis.dart';

void main() {
  group('GameEmojis - Counting', () {
    test('should have correct counting emojis', () {
      expect(GameEmojis.counting.apple, '🍎');
      expect(GameEmojis.counting.banana, '🍌');
      expect(GameEmojis.counting.orange, '🍊');
      expect(GameEmojis.counting.soccer, '⚽');
      expect(GameEmojis.counting.balloon, '🎈');
      expect(GameEmojis.counting.star, '🌟');
    });

    test('should return all counting emojis list', () {
      final all = GameEmojis.counting.all;
      expect(all.length, greaterThan(0));
      expect(all, contains('🍎'));
      expect(all, contains('🍌'));
    });

    test('should get emoji by index with rotation', () {
      final all = GameEmojis.counting.all;
      final length = all.length;

      // Test first emoji
      expect(GameEmojis.counting.getByIndex(0), all[0]);

      // Test rotation (index > length)
      expect(GameEmojis.counting.getByIndex(length), all[0]);
      expect(GameEmojis.counting.getByIndex(length + 1), all[1]);
    });

    test('should have missing emoji indicator', () {
      expect(GameEmojis.counting.missing, '⚫');
    });
  });

  group('GameEmojis - Math Operation', () {
    test('should have correct math operation emojis', () {
      expect(GameEmojis.mathOperation.apple, '🍎');
      expect(GameEmojis.mathOperation.banana, '🍌');
      expect(GameEmojis.mathOperation.star, '🌟');
    });

    test('should return all math operation emojis', () {
      final all = GameEmojis.mathOperation.all;
      expect(all.length, 6);
      expect(all, contains('🍎'));
    });

    test('should get emoji by index', () {
      final emoji = GameEmojis.mathOperation.getByIndex(0);
      expect(emoji, isNotEmpty);
    });
  });

  group('GameEmojis - Comparison', () {
    test('should have correct comparison emojis', () {
      expect(GameEmojis.comparison.apple, '🍎');
      expect(GameEmojis.comparison.watermelon, '🍉');
    });

    test('should return all comparison emojis', () {
      final all = GameEmojis.comparison.all;
      expect(all.length, greaterThan(0));
    });
  });

  group('GameEmojis - UI', () {
    test('should have correct UI emojis', () {
      expect(GameEmojis.ui.star, '⭐');
      expect(GameEmojis.ui.trophy, '🏆');
      expect(GameEmojis.ui.medal, '🏅');
      expect(GameEmojis.ui.crown, '👑');
      expect(GameEmojis.ui.fire, '🔥');
      expect(GameEmojis.ui.rocket, '🚀');
    });
  });

  group('GameEmojis - Feedback', () {
    test('should have correct feedback emojis', () {
      expect(GameEmojis.feedback.correct, '✅');
      expect(GameEmojis.feedback.wrong, '❌');
      expect(GameEmojis.feedback.thinking, '🤔');
      expect(GameEmojis.feedback.happy, '😊');
      expect(GameEmojis.feedback.celebrate, '🎊');
    });
  });

  group('GameEmojis - Game Types', () {
    test('should have correct game type icons', () {
      expect(GameEmojis.gameTypes.counting, '🔢');
      expect(GameEmojis.gameTypes.addition, '➕');
      expect(GameEmojis.gameTypes.subtraction, '➖');
      expect(GameEmojis.gameTypes.comparison, '⚖️');
      expect(GameEmojis.gameTypes.sequence, '🔄');
      expect(GameEmojis.gameTypes.mathGrid, '🎯');
    });
  });
}
