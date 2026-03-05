# MathKids Adventure - Refactoring Guide

## 📖 Overview

เอกสารนี้อธิบายระบบใหม่ที่ได้ Refactor เพื่อให้ง่ายต่อการจัดการ Assets (emoji, icons) และระบบ Progression แบบ Fixed

---

## 🎯 สิ่งที่เปลี่ยนแปลง

### 1. **Assets Module** - `lib/core/assets/game_emojis.dart`

**ก่อน Refactor:**
```dart
// กระจายอยู่ทุกไฟล์
final emojis = ['🍎', '🍌', '🍊', '⚽', '🎈', '🌟'];
final emoji = emojis[count % emojis.length];
```

**หลัง Refactor:**
```dart
// จัดการที่เดียว ใช้งานง่าย
final emoji = GameEmojis.counting.apple;  // 🍎
final emoji = GameEmojis.counting.getByIndex(5);
```

### 2. **Progression System** - `lib/data/progression/`

**ก่อน Refactor:**
```dart
// Random ทุกครั้ง ไม่ consistent
final correctAnswer = _random.nextInt(maxCount) + 1;
```

**หลัง Refactor:**
```dart
// Fixed progression - ด่าน 5 เป็น 1+5 เสมอ
final config = LevelProgression.addition.getConfig(5);
// Level 5: 1 + 5 = ?
```

---

## 📁 โครงสร้างไฟล์ใหม่

```
lib/
├── core/
│   └── assets/
│       └── game_emojis.dart          ← Assets Module
│
├── data/
│   ├── progression/
│   │   ├── level_progression.dart    ← Progression System
│   │   └── fixed_question_generator.dart
│   └── models/
│       └── game_type.dart            ← Updated to use GameEmojis
│
├── ui/
│   └── painters/
│       ├── objects_painter.dart       ← Updated
│       ├── math_operation_painter.dart ← Updated
│       └── comparison_painter.dart    ← Updated
│
└── providers/
    └── game_provider.dart            ← Updated

test/
├── core/
│   └── assets/
│       └── game_emojis_test.dart     ← 21 tests
└── data/
    └── progression/
        ├── level_progression_test.dart ← 43 tests
        └── fixed_question_generator_test.dart ← 45 tests
```

---

## 🎮 GameEmojis Module

### การใช้งาน

```dart
import 'package:mathkids_adventure/core/assets/game_emojis.dart';

// Counting Emojis
GameEmojis.counting.apple          // 🍎
GameEmojis.counting.banana         // 🍌
GameEmojis.counting.soccer         // ⚽
GameEmojis.counting.balloon        // 🎈
GameEmojis.counting.missing        // ⚫

// Math Operation Emojis
GameEmojis.mathOperation.star      // 🌟
GameEmojis.mathOperation.orange    // 🍊

// Comparison Emojis
GameEmojis.comparison.watermelon   // 🍉
GameEmojis.comparison.grapes       // 🍇

// UI Emojis
GameEmojis.ui.star                 // ⭐
GameEmojis.ui.trophy               // 🏆
GameEmojis.ui.medal                // 🏅
GameEmojis.ui.fire                 // 🔥

// Feedback Emojis
GameEmojis.feedback.correct        // ✅
GameEmojis.feedback.wrong          // ❌
GameEmojis.feedback.happy          // 😊
GameEmojis.feedback.celebrate      // 🎊

// Game Type Icons
GameEmojis.gameTypes.counting      // 🔢
GameEmojis.gameTypes.addition      // ➕
GameEmojis.gameTypes.subtraction   // ➖
GameEmojis.gameTypes.comparison    // ⚖️
```

### ดึง Emoji แบบ Dynamic

```dart
// Get by index (with rotation)
final emoji = GameEmojis.counting.getByIndex(count);

// Get all emojis as list
final allEmojis = GameEmojis.counting.all;
```

### เปลี่ยน Emoji

แก้ที่เดียวใน `lib/core/assets/game_emojis.dart`:

```dart
class _CountingEmojis {
  const _CountingEmojis();

  // แก้ตรงนี้
  final String apple = '🥕';  // เปลี่ยนจากแอปเปิ้ลเป็นแครอท
  final String banana = '🥒'; // เปลี่ยนจากกล้วยเป็นแตงกวา

  // เพิ่ม emoji ใหม่
  final String tomato = '🍅';

  // อัพเดท all list
  List<String> get all => [
    apple, banana, tomato, // เพิ่ม tomato
    orange, soccer, balloon, star,
  ];
}
```

---

## 📊 LevelProgression System

### การใช้งาน

```dart
import 'package:mathkids_adventure/data/progression/level_progression.dart';

// Get progression for game type
final progression = LevelProgression.addition;

// Get configuration for specific level
final config = progression.getConfig(5);

print(config.level);         // 5
print(config.description);   // "1 + 5 = ?"
print(config.minValue);      // 1
print(config.maxValue);      // 10
print(config.difficulty);    // Difficulty.easy
```

### Progression ของแต่ละเกม

#### 1. **Counting** (30 levels)
```dart
LevelProgression.counting.getConfig(1);   // count 1-1
LevelProgression.counting.getConfig(5);   // count 1-5
LevelProgression.counting.getConfig(10);  // count 1-10
LevelProgression.counting.getConfig(30);  // count 1-30
```

#### 2. **Addition** (50 levels)
```dart
LevelProgression.addition.getConfig(1);   // 1 + 1 = ?
LevelProgression.addition.getConfig(5);   // 1 + 5 = ?
LevelProgression.addition.getConfig(10);  // 1 + 10 = ?
LevelProgression.addition.getConfig(11);  // 2 + 1 = ?
LevelProgression.addition.getConfig(20);  // 2 + 10 = ?
LevelProgression.addition.getConfig(21);  // 3 + 1 = ?
LevelProgression.addition.getConfig(50);  // 5 + 10 = ?
```

**Pattern:**
- Level 1-10: 1 + (1 to 10)
- Level 11-20: 2 + (1 to 10)
- Level 21-30: 3 + (1 to 10)
- Level 31-40: 4 + (1 to 10)
- Level 41-50: 5 + (1 to 10)

#### 3. **Subtraction** (50 levels)
```dart
LevelProgression.subtraction.getConfig(1);   // 2 - 1 = ?
LevelProgression.subtraction.getConfig(10);  // 11 - 1 = ?
LevelProgression.subtraction.getConfig(11);  // 3 - 2 = ?
LevelProgression.subtraction.getConfig(21);  // 4 - 3 = ?
```

**Pattern:**
- Level 1-10: (2 to 11) - 1
- Level 11-20: (3 to 12) - 2
- Level 21-30: (4 to 13) - 3
- และต่อไป...

#### 4. **Sequence** (30 levels)
```dart
LevelProgression.sequence.getConfig(1);   // step = 1: [1,2,3,4] → 5
LevelProgression.sequence.getConfig(5);   // step = 5: [5,10,15,20] → 25
LevelProgression.sequence.getConfig(10);  // step = 10: [10,20,30,40] → 50
```

**Pattern:**
- Level N: step = N, sequence = [N, 2N, 3N, 4N] → answer: 5N

#### 5. **Comparison** (30 levels)
```dart
LevelProgression.comparison.getConfig(5);   // compare 1-5
LevelProgression.comparison.getConfig(15);  // compare 1-10
LevelProgression.comparison.getConfig(25);  // compare 1-15
```

#### 6. **MathGrid** (30 levels)
```dart
LevelProgression.mathGrid.getConfig(5);   // use numbers 1-5
LevelProgression.mathGrid.getConfig(15);  // use numbers 1-8
LevelProgression.mathGrid.getConfig(25);  // use numbers 1-10
```

### ปรับ Progression

แก้ใน `lib/data/progression/level_progression.dart`:

```dart
class AdditionProgression extends GameProgression {
  const AdditionProgression();

  @override
  int get totalLevels => 50; // เปลี่ยนจำนวนด่าน

  @override
  LevelConfig getConfig(int level) {
    // แก้สูตรตรงนี้
    if (level <= 10) {
      return LevelConfig(
        level: level,
        description: '1 + $level = ?',
        minValue: 1,
        maxValue: level,
        difficulty: Difficulty.easy,
      );
    }
    // เพิ่ม pattern ใหม่...
  }
}
```

---

## 🎲 FixedQuestionGenerator

### การใช้งาน

```dart
import 'package:mathkids_adventure/data/progression/fixed_question_generator.dart';

final generator = FixedQuestionGenerator();

// Generate question for specific level
final question = generator.generateForLevel(GameType.addition, 5);

print(question.questionText);  // "1 + 5 = ?"
print(question.correctAnswer); // 6
print(question.operand1);      // 1
print(question.operand2);      // 5
print(question.options);       // [3, 6, 7, 9] (shuffled)
```

### ตัวอย่าง Questions

```dart
// Counting
final q = generator.generateForLevel(GameType.counting, 5);
// questionText: "นับกี่ลูก?"
// correctAnswer: 5
// imageCount: 5

// Addition
final q = generator.generateForLevel(GameType.addition, 11);
// questionText: "2 + 1 = ?"
// correctAnswer: 3
// operand1: 2, operand2: 1

// Sequence
final q = generator.generateForLevel(GameType.sequence, 5);
// questionText: "เลขอะไรต่อไป?"
// sequence: [5, 10, 15, 20]
// correctAnswer: 25
```

---

## 🔄 Migration จากระบบเก่า

### GameProvider

**ก่อน:**
```dart
import '../services/question_generator.dart';

final QuestionGenerator _questionGenerator = QuestionGenerator();

void _generateNextQuestion(GameType gameType, Difficulty difficulty) {
  _currentQuestion = _questionGenerator.generate(gameType, difficulty);
}
```

**หลัง:**
```dart
import '../data/progression/fixed_question_generator.dart';

final FixedQuestionGenerator _questionGenerator = FixedQuestionGenerator();
int? _currentLevel;

void _generateNextQuestion(GameType gameType) {
  final level = (_currentLevel ?? 1) + (_currentQuestionNumber - 1);
  _currentQuestion = _questionGenerator.generateForLevel(gameType, level);
}
```

### Painters

**ก่อน:**
```dart
// objects_painter.dart
final emojis = ['🍎', '🍌', '🍊', '⚽', '🎈', '🌟'];
final emoji = emojis[count % emojis.length];
```

**หลัง:**
```dart
import '../../core/assets/game_emojis.dart';

final emoji = GameEmojis.counting.getByIndex(count);
```

---

## ✅ Testing

### Run Tests
```bash
# All tests
flutter test

# Specific test file
flutter test test/core/assets/game_emojis_test.dart
flutter test test/data/progression/level_progression_test.dart
flutter test test/data/progression/fixed_question_generator_test.dart

# With coverage
flutter test --coverage
```

### Test Coverage
- **GameEmojis**: 21 tests ✅
- **LevelProgression**: 43 tests ✅
- **FixedQuestionGenerator**: 45 tests ✅
- **Total**: 109 tests ✅

---

## 📝 ข้อดีของระบบใหม่

### 1. **จัดการ Assets ง่าย**
- ✅ แก้ emoji ที่เดียวใน `game_emojis.dart`
- ✅ ไม่ต้องไล่แก้ทุกไฟล์
- ✅ Type-safe (autocomplete ใน IDE)
- ✅ ง่ายต่อการเปลี่ยน theme

### 2. **Progression แบบ Fixed**
- ✅ ด่านเดียวกัน = คำถามเดียวกัน (consistent)
- ✅ ความยากเพิ่มขึ้นแบบ progressive
- ✅ เด็กสามารถเรียนรู้จากรูปแบบ
- ✅ ง่ายต่อการออกแบบ curriculum

### 3. **ปรับแต่งง่าย**
- ✅ แก้ progression ได้ที่เดียว
- ✅ เพิ่ม/ลด level ได้ง่าย
- ✅ เปลี่ยนสูตรได้เลย
- ✅ Test ครอบคลุม

### 4. **Maintainable**
- ✅ Code organized ดี
- ✅ มี Unit tests ครบถ้วน
- ✅ Documentation ชัดเจน
- ✅ ง่ายต่อการ debug

---

## 🚀 ตัวอย่างการใช้งานจริง

### เปลี่ยน Theme Emoji ทั้งหมด

```dart
// ใน game_emojis.dart

// Theme 1: Fruits & Sports (ปัจจุบัน)
final String apple = '🍎';
final String banana = '🍌';

// Theme 2: Animals
final String apple = '🐶';  // แทน apple ด้วยหมา
final String banana = '🐱'; // แทน banana ด้วยแมว

// Theme 3: Vehicles
final String apple = '🚗';  // แทน apple ด้วยรถ
final String banana = '🚌'; // แทน banana ด้วยรถบัส
```

### เพิ่ม Level ใหม่

```dart
// ใน level_progression.dart

class AdditionProgression extends GameProgression {
  @override
  int get totalLevels => 100; // เพิ่มจาก 50 → 100

  @override
  LevelConfig getConfig(int level) {
    // เพิ่ม pattern ใหม่สำหรับ level 51-100
    if (level > 50 && level <= 60) {
      return LevelConfig(
        level: level,
        description: '6 + ${level - 50} = ?',
        minValue: 1,
        maxValue: 10,
        difficulty: Difficulty.hard,
      );
    }
  }
}
```

### Custom Progression

```dart
// สร้าง progression แบบกำหนดเอง
class CustomAdditionProgression extends GameProgression {
  const CustomAdditionProgression();

  @override
  int get totalLevels => 20;

  @override
  LevelConfig getConfig(int level) {
    // Level 1-10: เลข 2 หลัก
    if (level <= 10) {
      final operand1 = level + 10;  // 11-20
      final operand2 = level;
      return LevelConfig(
        level: level,
        description: '$operand1 + $operand2 = ?',
        minValue: 10,
        maxValue: 30,
        difficulty: Difficulty.hard,
      );
    }
    // Level 11-20: เลข 3 หลัก
    else {
      final operand1 = (level - 10) * 10 + 100; // 110, 120, 130...
      final operand2 = (level - 10) * 5;
      return LevelConfig(
        level: level,
        description: '$operand1 + $operand2 = ?',
        minValue: 100,
        maxValue: 300,
        difficulty: Difficulty.hard,
      );
    }
  }
}
```

---

## 🎓 Best Practices

### 1. **การตั้งชื่อ**
- ใช้ชื่อที่สื่อความหมาย
- ตาม pattern ที่มีอยู่แล้ว
- เพิ่ม comment อธิบาย

### 2. **การเพิ่ม Emoji**
```dart
// ❌ แย่
final String x = '🍎';

// ✅ ดี
final String apple = '🍎';  // Red apple for counting
```

### 3. **การปรับ Progression**
```dart
// ✅ ดี - มี comment อธิบาย
// Level 1-10: เริ่มต้น (1+1 ถึง 1+10)
if (level <= 10) {
  return LevelConfig(
    level: level,
    description: '1 + $level = ?',
    minValue: 1,
    maxValue: level,
    difficulty: Difficulty.easy,
  );
}
```

### 4. **การเขียน Test**
```dart
test('should generate 1+5 for level 5', () {
  // Arrange
  final generator = FixedQuestionGenerator();

  // Act
  final question = generator.generateForLevel(GameType.addition, 5);

  // Assert
  expect(question.questionText, '1 + 5 = ?');
  expect(question.correctAnswer, 6);
});
```

---

## 🐛 Troubleshooting

### Q: Emoji ไม่แสดง?
```dart
// A: ตรวจสอบ import
import 'package:mathkids_adventure/core/assets/game_emojis.dart';
```

### Q: Level progression ไม่ถูกต้อง?
```dart
// A: ตรวจสอบใน level_progression_test.dart
flutter test test/data/progression/level_progression_test.dart
```

### Q: คำถาม random ยังไง?
```dart
// A: ตอนนี้เป็น fixed แล้ว ไม่ random
// ด่านเดียวกัน = คำถามเดียวกันเสมอ
```

---

## 📚 อ่านเพิ่มเติม

- [TEST_SUMMARY.md](TEST_SUMMARY.md) - รายละเอียด Unit Tests
- [lib/core/assets/game_emojis.dart](lib/core/assets/game_emojis.dart) - Assets Module
- [lib/data/progression/level_progression.dart](lib/data/progression/level_progression.dart) - Progression System
- [lib/data/progression/fixed_question_generator.dart](lib/data/progression/fixed_question_generator.dart) - Question Generator

---

## 👨‍💻 Author

Refactored by Claude (Anthropic) on 2024
