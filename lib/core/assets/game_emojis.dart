/// Game Emojis - ระบบจัดการ Emoji ทั้งหมดในเกม
///
/// ใช้งาน: GameEmojis.counting.apple
///         GameEmojis.ui.star
///         GameEmojis.feedback.correct
library;

class GameEmojis {
  GameEmojis._(); // Private constructor

  // ========================================
  // Counting Game Emojis (เกมนับเลข)
  // ========================================
  static const counting = _CountingEmojis();

  // ========================================
  // Addition/Subtraction Game Emojis (เกมบวกลบ)
  // ========================================
  static const mathOperation = _MathOperationEmojis();

  // ========================================
  // Comparison Game Emojis (เกมเปรียบเทียบ)
  // ========================================
  static const comparison = _ComparisonEmojis();

  // ========================================
  // UI Emojis (ใช้ใน UI ทั่วไป)
  // ========================================
  static const ui = _UiEmojis();

  // ========================================
  // Feedback Emojis (ตอบถูก/ผิด)
  // ========================================
  static const feedback = _FeedbackEmojis();

  // ========================================
  // Game Type Icons (ไอคอนแต่ละเกม)
  // ========================================
  static const gameTypes = _GameTypeEmojis();
}

// ========================================
// Counting Emojis
// ========================================
class _CountingEmojis {
  const _CountingEmojis();

  /// Fruits (ผลไม้)
  final String apple = '🍎';
  final String banana = '🍌';
  final String orange = '🍊';
  final String watermelon = '🍉';
  final String grapes = '🍇';
  final String strawberry = '🍓';
  final String cherry = '🍒';
  final String pineapple = '🍍';

  /// Sports (กีฬา)
  final String soccer = '⚽';
  final String basketball = '🏀';
  final String baseball = '⚾';
  final String tennis = '🎾';

  /// Fun Items (ของเล่น)
  final String balloon = '🎈';
  final String star = '🌟';
  final String heart = '💖';
  final String gift = '🎁';
  final String candy = '🍬';
  final String lollipop = '🍭';

  /// Animals (สัตว์)
  final String dog = '🐶';
  final String cat = '🐱';
  final String rabbit = '🐰';
  final String bear = '🐻';
  final String panda = '🐼';
  final String koala = '🐨';

  /// Vehicles (ยานพาหนะ)
  final String car = '🚗';
  final String bus = '🚌';
  final String train = '🚂';
  final String airplane = '✈️';

  /// Error indicator (ตัวบอกว่าขาด)
  final String missing = '⚫';

  /// Get all emojis as list
  List<String> get all => [
        apple, banana, orange, watermelon, grapes, strawberry,
        soccer, basketball, balloon, star, heart, gift,
        dog, cat, rabbit, bear, car, bus,
      ];

  /// Get emoji by index (for rotation)
  String getByIndex(int index) => all[index % all.length];
}

// ========================================
// Math Operation Emojis (บวก/ลบ)
// ========================================
class _MathOperationEmojis {
  const _MathOperationEmojis();

  /// ใช้เหมือน Counting แต่แยกไว้เผื่อต้องการใช้ emoji ต่างกัน
  final String apple = '🍎';
  final String banana = '🍌';
  final String orange = '🍊';
  final String soccer = '⚽';
  final String balloon = '🎈';
  final String star = '🌟';

  /// Get all emojis as list
  List<String> get all => [apple, banana, orange, soccer, balloon, star];

  /// Get emoji by index
  String getByIndex(int index) => all[index % all.length];
}

// ========================================
// Comparison Emojis
// ========================================
class _ComparisonEmojis {
  const _ComparisonEmojis();

  final String apple = '🍎';
  final String banana = '🍌';
  final String orange = '🍊';
  final String watermelon = '🍉';
  final String grapes = '🍇';
  final String strawberry = '🍓';

  /// Get all emojis as list
  List<String> get all => [apple, banana, orange, watermelon, grapes, strawberry];

  /// Get emoji by index
  String getByIndex(int index) => all[index % all.length];
}

// ========================================
// UI Emojis (ใช้ทั่วไป)
// ========================================
class _UiEmojis {
  const _UiEmojis();

  final String star = '⭐';
  final String trophy = '🏆';
  final String medal = '🏅';
  final String crown = '👑';
  final String fire = '🔥';
  final String rocket = '🚀';
  final String party = '🎉';
  final String sparkles = '✨';
  final String heart = '❤️';
  final String thumbsUp = '👍';
  final String clap = '👏';
  final String muscle = '💪';
}

// ========================================
// Feedback Emojis (ตอบถูก/ผิด)
// ========================================
class _FeedbackEmojis {
  const _FeedbackEmojis();

  final String correct = '✅';
  final String wrong = '❌';
  final String thinking = '🤔';
  final String happy = '😊';
  final String sad = '😢';
  final String celebrate = '🎊';
  final String hooray = '🎉';
}

// ========================================
// Game Type Emojis (ไอคอนเกม)
// ========================================
class _GameTypeEmojis {
  const _GameTypeEmojis();

  final String counting = '🔢';
  final String comparison = '⚖️';
  final String sequence = '🔄';
  final String mathGrid = '🎯';
}
