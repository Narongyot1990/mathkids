# MathKids Adventure — Research Report & Roadmap

> วันที่วิเคราะห์: 2026-03-02
> วิเคราะห์โดย: Claude Code (Sonnet 4.6)
> เวอร์ชันโปรเจกต์: 1.0.0

---

## สารบัญ

1. [ภาพรวมและประเมินสุขภาพโปรเจกต์](#1-ภาพรวม)
2. [วิเคราะห์ Logic](#2-logic)
3. [วิเคราะห์ Layout & Responsive](#3-layout--responsive)
4. [วิเคราะห์ UI / UX](#4-ui--ux)
5. [วิเคราะห์ Theme & Design System](#5-theme--design-system)
6. [วิเคราะห์ Architecture & Code Quality](#6-architecture--code-quality)
7. [วิเคราะห์ Security & Performance](#7-security--performance)
8. [วิเคราะห์ Testing](#8-testing)
9. [สรุป: อะไรต้องปรับ (Fix)](#9-สรุป-อะไรต้องปรับ)
10. [สรุป: อะไรต้องเพิ่ม (Add)](#10-สรุป-อะไรต้องเพิ่ม)
11. [Roadmap ละเอียด](#11-roadmap)

---

## 1. ภาพรวม

### ✅ จุดแข็ง
| ด้าน | สถานะ | หมายเหตุ |
|------|--------|----------|
| Code Structure | ดีมาก | แยก layer ชัดเจน (data/providers/screens/services/widgets) |
| Design System | ดีมาก | มี theme tokens ครบ (colors, sizes, spacing, typography) |
| State Management | ดี | Provider + ChangeNotifier ตามมาตรฐาน |
| Data-Driven Design | ดีมาก | คำถามเป็น static data แยกไฟล์สะอาด |
| Test Coverage | พอใช้ | มี 105 tests ใน 9 ไฟล์ |
| Audio System | ดี | แยก music/SFX, มี lifecycle handling |

### ⚠️ จุดอ่อนวิกฤต
| ปัญหา | ความรุนแรง | ผลกระทบ |
|--------|------------|---------|
| API Key อยู่ใน source code | 🔴 Critical | Security breach |
| Race condition ใน GameProvider | 🔴 Critical | Memory leak / crash |
| สถิติไม่ reset ระหว่างเกม | 🔴 Critical | คะแนนผิดพลาด |
| MathGrid ไม่ได้ implement | 🟠 High | Feature ไม่ทำงาน |
| ไม่มี error handling | 🟠 High | User ไม่รู้ว่ามี error |

---

## 2. Logic

### 2.1 Game Flow Logic
```
App → MainMenu → LevelSelect → StageSelect → GameScreen → (Results?)
```

**ปัญหาที่พบ:**

#### ❌ Bug: `_correctAnswers` ไม่ถูก reset
**ไฟล์:** `lib/providers/game_provider.dart` — เมธอด `reset()`
```dart
// ปัจจุบัน (บกพร่อง)
void reset() {
  _score = 0;
  _currentQuestionIndex = 0;
  _isCorrect = null;
  _isGameOver = false;
  // ❌ ลืม reset _correctAnswers!
}

// ควรเป็น
void reset() {
  _score = 0;
  _correctAnswers = 0;   // เพิ่มบรรทัดนี้
  _currentQuestionIndex = 0;
  _isCorrect = null;
  _isGameOver = false;
  _lastSelectedAnswer = null;
}
```
**ผลกระทบ:** เล่นเกม 2 ต่อจากเกม 1 → จำนวน correct answers รวมกัน → stars ผิด

---

#### ❌ Bug: Race Condition เมื่อออกจากหน้าเร็ว
**ไฟล์:** `lib/providers/game_provider.dart` — เมธอด `checkAnswer()`
```dart
// ปัจจุบัน (อันตราย)
Future.delayed(const Duration(milliseconds: 1500), () {
  _nextQuestion(gameType);   // อาจ call หลัง dispose แล้ว!
});

// ควรเป็น
Timer? _pendingTimer;

void checkAnswer(...) {
  ...
  _pendingTimer?.cancel();
  _pendingTimer = Timer(const Duration(milliseconds: 1500), () {
    if (!_disposed) _nextQuestion(gameType);
  });
}

bool _disposed = false;

@override
void dispose() {
  _disposed = true;
  _pendingTimer?.cancel();
  super.dispose();
}
```

---

#### ⚠️ Logic: Difficulty ถูก pass แต่ไม่ถูกใช้
**ไฟล์:** `lib/providers/game_provider.dart`
```dart
// Difficulty รับเข้ามาแต่ไม่ได้ทำอะไรเลย
void checkAnswer(int answer, GameType gameType, Difficulty difficulty) {
  // difficulty ไม่มีในตัวแปรใดเลย
}
```
ควรตัดออก หรือ implement ให้เปลี่ยน threshold การให้ดาว

---

#### ❌ Logic: MathGrid ใช้คำถาม Addition แทน
**ไฟล์:** `lib/data/question_bank/question_bank.dart`
```dart
case GameType.mathGrid:
  return AdditionQuestions.getQuestion(level);  // ❌ fallback ผิด
```
ยังไม่มี `MathGridQuestions` class เลย

---

#### ⚠️ Logic: Stars calculation hardcoded
**ไฟล์:** `lib/providers/game_provider.dart`
```dart
int calculateStars() {
  final percentage = (_score / (_totalQuestions * 10)) * 100;
  // hardcode 10 pts ต่อข้อ
}
```
ถ้าเปลี่ยน scoring ในอนาคต ต้องแก้ 2 ที่

---

#### ⚠️ Logic: Streak calculation มี edge case
**ไฟล์:** `lib/data/models/kid_stats.dart`
```dart
int calculateStreak(DateTime today) {
  final daysSinceLastPlay = today.difference(lastPlayedDate!).inDays;

  if (daysSinceLastPlay == 0) return playStreak;    // เล่นวันเดียวกัน = ไม่นับเพิ่ม ✅
  else if (daysSinceLastPlay == 1) return playStreak + 1;  // เล่นเมื่อวาน ✅
  else return 1;  // หยุดมากกว่า 1 วัน = reset ✅
}
```
ปัญหา: `inDays` นับจากเที่ยงคืน ไม่ใช่ 24 ชั่วโมง
เล่น 23:59 คืนนี้ → เล่น 00:01 พรุ่งนี้ = `inDays == 1` → นับ streak ทั้งที่เล่นห่างกันแค่ 2 นาที

---

#### ⚠️ Logic: Question shuffle ไม่ deterministic
**ไฟล์:** `lib/data/question_bank/question_config.dart`
```dart
List<int> getOptions() {
  final options = [correctAnswer, ...wrongAnswers];
  options.shuffle();   // random ทุกครั้ง
  return options;
}
```
ทุก render ปุ่มตอบจะสลับที่ใหม่ → เด็กอาจงง ถ้า rebuild ระหว่างเล่น

---

### 2.2 Progress & Scoring Logic

**Best Score Logic** — ใน `lib/services/progress_service.dart`:
```
เงื่อนไขบันทึก: Stars ใหม่ > Stars เก่า → บันทึก
                Stars เท่ากัน + Score ใหม่ > Score เก่า → บันทึก
```
Logic ถูกต้อง แต่ code อ่านยาก ควร refactor ให้ชัดขึ้น

---

## 3. Layout & Responsive

### 3.1 Breakpoint System
**ไฟล์:** `lib/core/theme/app_sizes.dart`

| Breakpoint | ขนาด | อุปกรณ์ |
|-----------|------|---------|
| Small | < 360px | iPhone SE, เก่า |
| Medium | 360-430px | iPhone 13/14/15 |
| Large | > 430px | iPhone Pro Max |

**ปัญหา:**

#### ❌ ไม่รองรับ Tablet / iPad
```dart
// ปัจจุบัน: max 430px
static double get scaleFactor {
  final width = ...
  if (width < 360) return 0.92;
  if (width > 430) return 1.12;  // ทุกอย่างใหญ่กว่านี้ = 1.12 เท่าเท่ากันหมด
  return 1.0;
}
```
iPad ขนาด 768px-1024px จะใช้ scale 1.12 เท่ากับ iPhone Pro Max — ทำให้ UI ดูเล็กบน tablet

**แนะนำ:**
```dart
static double get scaleFactor {
  if (width < 360) return 0.92;
  if (width < 430) return 1.0;
  if (width < 600) return 1.12;
  if (width < 768) return 1.3;   // เพิ่ม tablet breakpoints
  return 1.5;                     // iPad
}
```

---

#### ⚠️ ล็อค Portrait อย่างเดียว
**ไฟล์:** `lib/main.dart`
```dart
SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
```
สำหรับเด็กเล็กอาจโอเค แต่ในอนาคตถ้าต้องการ landscape (เช่น game board ใหญ่ขึ้น) ต้องแก้

---

#### ⚠️ Answer Button Size ไม่ responsive
**ไฟล์:** `lib/widgets/answer_button.dart`
```dart
final buttonSize = isSmall ? 80.0 : 95.0;  // hardcoded pixel
```
บน iPad 95px ดูเล็กมาก ควรใช้ `AppSizes.answerButtonSize` ที่ scale ตาม breakpoint

---

#### ⚠️ ไม่มี max-width container
ถ้าเปิดบน Web หรือ Desktop ที่หน้าจอกว้าง layout จะยืดออก ควรมี `ConstrainedBox` หรือ `Center` + `SizedBox(width: 430)`

---

### 3.2 Padding & Spacing

**ดี:** ใช้ `AppSpacing` ทั่วโปรเจกต์ — สม่ำเสมอ
**ปัญหา:** บางหน้าใช้ hardcoded `SizedBox(height: 16)` แทน `AppSpacing.spaceM`

---

### 3.3 Custom Painter Layout
**ไฟล์:** `lib/ui/painters/objects_painter.dart`

Grid layout สำหรับ counting game:
```dart
int cols = (count <= 5) ? count : ((count <= 12) ? 4 : 5);
```
**ปัญหา:** count=6 → cols=4 → 2 rows แต่ count=7 → cols=4 → 2 rows (7/4=1.75 → ceil=2 rows, 7 emoji ใน grid 4x2=8 slot → slot เยอะกว่า)
Centering logic ซับซ้อนและ error-prone

---

## 4. UI / UX

### 4.1 ปัญหา UX สำหรับเด็ก

#### ❌ ไม่มีปุ่ม Pause / กลับกลางเกม
เด็กออกจากเกมโดยกด Back → ไม่มี confirmation → progress หาย

**แนะนำ:** Dialog ถามก่อน:
```
"หยุดเล่นไหม? คะแนนของหนูจะหายนะ"
[เล่นต่อ] [ออก]
```

---

#### ❌ ไม่มี Pause Menu / Sound Toggle ใน Game
ผู้ปกครองอยากปิดเสียงระหว่างเกมต้องออกไปที่ Settings ของ OS — ไม่ดี

---

#### ⚠️ Answer Feedback ไม่ชัดเจนพอ

**ปัจจุบัน:** ปุ่มที่ถูกเปลี่ยนสีเขียว, ปุ่มที่กดผิดเปลี่ยนสีแดง
**ปัญหา:** เด็กเล็ก 3-4 ขวบ อาจยังแยกสีไม่ออกชัด ควรมี:
- ✅ Icon ขนาดใหญ่ (✓ หรือ ✗) overlay บนปุ่ม
- 🔊 เสียงชัดเจน (ปัจจุบันมีแต่อาจ delay)
- 📳 Vibration feedback (มี `vibration` package แต่ไม่ถูกใช้ใน answer feedback)

---

#### ⚠️ ไม่มี Countdown Timer
ไม่มีเวลาจำกัดต่อข้อ — สำหรับเด็กเล็กโอเค แต่ใน future stage ที่ยากขึ้น timer จะเพิ่มความท้าทาย

---

#### ⚠️ ปุ่มกลับ (Back Button) บน Android
ถ้ากด back กลางเกม → `Navigator.pop(context, true)` → ออกทันที ไม่มี confirm dialog

---

#### ⚠️ Loading State ไม่ชัด
มี `GameLoadingScreen` แต่ transition จาก loading → game ไม่ smooth

---

#### ❌ ไม่มีหน้า Result Screen ที่ชัดเจน
จากการวิเคราะห์ code ไม่พบ `ResultScreen` หรือ `GameOverScreen` ที่สมบูรณ์
หลังเกมจบ ผู้ใช้เห็นอะไร? Stars? Score? ปุ่ม Play Again?

---

#### ⚠️ Navigation Flow ซับซ้อนเกินไป
```
MainMenu → LevelSelect → StageSelect → Game
```
3 หน้าก่อนเล่นได้ สำหรับเด็กเล็กอาจมากเกิน
**แนะนำ:** ลด friction ด้วย Quick Play หรือ "เล่นต่อจากที่เล่นค้างไว้"

---

### 4.2 Accessibility

| ปัญหา | ระดับ |
|-------|------|
| ไม่มี semantic labels สำหรับ screen reader | 🟠 High |
| สีเขียว/แดง เป็น feedback เดียว (ไม่รองรับ colorblind) | 🟠 High |
| ไม่มี haptic feedback | 🟡 Medium |
| ขนาด touch target บางส่วนอาจน้อยกว่า 48x48px | 🟡 Medium |

---

### 4.3 Engagement & Motivation

**ปัจจุบัน:** Stars + Score
**ขาด:**
- Badge / Achievement system
- Daily challenge
- Streak reward visual
- Parent progress report
- Leaderboard (สำหรับครอบครัว)

---

## 5. Theme & Design System

### 5.1 Color System
**ไฟล์:** `lib/core/theme/app_colors.dart` (442 lines)

**ดี:**
- มี semantic names ครบ (primary, background, status, neutral)
- มี gradient ครบ (background, button, game card)
- ใช้ const ทั้งหมด — performance ดี

**ปัญหา:**

#### ⚠️ Color ซ้ำกัน / ไม่ consistent
```dart
static const Color gameStar = Color(0xFFFFD700);    // gold
static const Color statsScore = Color(0xFFFFCA28);   // amber — ต่างกัน!
```
ควรใช้ค่าเดียวกัน

#### ⚠️ ไม่มี Disabled State Color
ปุ่มที่ถูก lock (stage ยังไม่ unlock) ควรมีสี disabled ที่ชัดเจน

#### ⚠️ Dark Mode ไม่รองรับ
`AppTheme` มีแค่ `lightTheme` ไม่มี `darkTheme`
เด็กเล่นกลางคืน → สว่างมาก → ไม่ดีสำหรับตา

---

### 5.2 Typography
**ไฟล์:** `lib/core/theme/app_typography.dart`

#### 🔴 Performance Bug: Google Fonts โหลดทุก access
```dart
// ปัจจุบัน (โหลดทุกครั้ง)
static String get fontFamily => GoogleFonts.fredoka().fontFamily!;

// แก้ไข: cache ไว้
static final String _fontFamily = GoogleFonts.fredoka().fontFamily!;
static String get fontFamily => _fontFamily;
```

#### ⚠️ Force Unwrap อาจ crash
```dart
GoogleFonts.fredoka().fontFamily!  // ถ้า null = crash
```

#### ⚠️ Line height สำหรับเด็ก
`lineHeightTight = 1.2` — สำหรับ body text เด็กเล็กควร 1.4-1.5 อ่านง่ายกว่า

---

### 5.3 Sizing System
**ไฟล์:** `lib/core/theme/app_sizes.dart`

**ดี:** มี semantic names ครบ, shadow system, responsive scaling

**ปัญหา:**

#### ⚠️ Scaling ไม่ครอบคลุม Tablet
ดูหัวข้อ Layout ด้านบน

#### ⚠️ ไม่มี max-width constraints สำหรับ Web/Desktop
บน Web ที่ resolution สูง UI จะยืดออกผิดปกติ

---

### 5.4 Spacing System
**ไฟล์:** `lib/core/theme/app_spacing.dart`

**ดี:** 8pt grid, semantic names, pre-built SizedBox

**ปัญหา:**
- บางหน้ายังใช้ hardcoded values แทน `AppSpacing.*`
- ไม่มี margin helper (มีแค่ padding)

---

### 5.5 App Theme
**ไฟล์:** `lib/core/theme/app_theme.dart`

#### ⚠️ Backward compat constants ที่ deprecated
```dart
// lines 18-35: ควรลบออกเมื่อ refactor เสร็จ
static const Color primaryColor = AppColors.primaryBlue;  // old pattern
```

#### ⚠️ InputDecoration ไม่ complete
ไม่มี cursor color, hint text style — สำคัญถ้าเพิ่ม input field ในอนาคต

---

## 6. Architecture & Code Quality

### 6.1 Architecture Overview

```
✅ Layer Separation     — ดีมาก
✅ Data-Driven Design   — ดีมาก
⚠️ Dependency Injection — ไม่มี (services สร้างใน provider)
⚠️ Error Strategy       — ไม่มี centralized error handling
⚠️ Logging             — ใช้ print() ปะปนกับ debugPrint()
❌ DI Container         — ไม่มี GetIt หรือ equivalent
```

---

### 6.2 Data Model Issues
**ไฟล์:** `lib/data/models/question.dart`

#### ⚠️ God Object: Question มี fields ของทุก game type
```dart
class Question {
  final int? imageCount;           // counting เท่านั้น
  final int? operand1;             // addition/subtraction เท่านั้น
  final int? leftCount;            // comparison เท่านั้น
  final List<int>? sequence;       // sequence เท่านั้น
  final List<List<int>>? gridLayout; // mathGrid เท่านั้น
  // ...
}
```
ควร refactor เป็น sealed class หรือ abstract base:
```dart
sealed class GameQuestion { ... }
class CountingQuestion extends GameQuestion { final int imageCount; }
class AdditionQuestion extends GameQuestion { final int operand1, operand2; }
```

---

#### ⚠️ ไม่มี `toString()`, `==`, `hashCode`
Debugging ยากมาก, cannot compare questions in tests

---

### 6.3 Question Bank Issues

#### ⚠️ Code Duplication ใน Question Banks
ทุก game type มี `getQuestion(int level)` ที่ copy กัน
ควรมี base class:
```dart
abstract class BaseQuestionBank {
  static List<QuestionTemplate> get bank;
  static Question getQuestion(int level) {
    // common implementation
  }
}
```

#### ⚠️ ไม่มี bounds checking
```dart
static Question getQuestion(int level) {
  // ถ้า level > bank.length → crash!
}
```

#### ⚠️ Hardcoded data ยากต่อการ maintain
500+ lines ต่อไฟล์สำหรับ question data
ควรย้ายไป `assets/data/questions.json`

---

### 6.4 Service Layer Issues

#### ⚠️ Tight Coupling
```dart
// ใน GameProvider constructor
_progressService = ProgressService();    // สร้างเองข้างใน
_statsRepository = StatsRepository();    // ไม่ inject
```
ทำ unit test ลำบากมาก ต้องใช้ mock

---

#### ⚠️ ไม่มี interface/abstract class สำหรับ services
```dart
// ควรเป็น
abstract class IProgressService {
  Future<void> saveStageProgress(...);
  Future<List<StageProgress>> getAllStageProgress(...);
}

class ProgressService implements IProgressService { ... }
class MockProgressService implements IProgressService { ... }  // สำหรับ test
```

---

### 6.5 Immutability Issues
**ไฟล์:** `lib/data/models/kid_stats.dart`
```dart
final Map<GameType, int> gamePlayCounts;    // Mutable!
final Map<GameType, int> gameHighScores;    // Mutable!
```
ควรใช้ `Map.unmodifiable()` เพื่อป้องกัน accidental mutation

---

## 7. Security & Performance

### 7.1 🔴 CRITICAL: API Key Exposed

**ไฟล์:** `lib/services/gemini_api_service.dart`
```dart
static const String _apiKey = 'AIzaSyDTSXm0WpXt2SPPhKZzhxFCHWrI0iJB6YY';
// ^^^ API key อยู่ใน source code = ทุกคนที่ decompile APK เห็นได้
```

**ต้องทำทันที:**
1. Rotate key นี้ที่ Google Cloud Console
2. ย้ายไป environment variable:
   ```dart
   static const String _apiKey = String.fromEnvironment('GEMINI_API_KEY');
   ```
3. หรือใช้ backend proxy เพื่อไม่ให้ key อยู่ใน client เลย

---

### 7.2 Performance Issues

#### ⚠️ Google Fonts โหลดทุก TextStyle access
ดูหัวข้อ Typography ด้านบน

#### ⚠️ Custom Painter: ไม่มี cache สำหรับ emoji rendering
**ไฟล์:** `lib/ui/painters/objects_painter.dart`
```dart
// สร้าง TextPainter ใหม่ทุก emoji ทุก repaint
final textPainter = TextPainter(text: TextSpan(text: emoji, ...));
textPainter.layout();
textPainter.paint(canvas, offset);
```
ควร cache `TextPainter` ต่อ emoji ต่อ size

#### ⚠️ ไม่มี lazy loading
Questions bank โหลดทั้งหมดที่ app start — ไม่ใช่ปัญหาตอนนี้ แต่จะเป็นปัญหาถ้า content เพิ่มขึ้น

---

### 7.3 Data Persistence Issues

**ไฟล์:** `lib/data/repositories/stats_repository.dart`

#### ⚠️ ไม่มี schema versioning
```dart
// JSON ที่บันทึกไม่มี version
final key = 'kid_stats';
```
ถ้า app update เปลี่ยน JSON structure → data เก่า parse ไม่ได้ → crash

**แนะนำ:**
```dart
final data = {'version': 2, 'stats': kidStats.toJson()};
```

#### ⚠️ ไม่มี data migration strategy
---

## 8. Testing

### 8.1 สถานะ Test Coverage

| ไฟล์ | Tests | สิ่งที่ test |
|------|-------|------------|
| game_provider_test.dart | ~20 | State management |
| question_bank_test.dart | ~15 | Question retrieval |
| kid_stats_test.dart | ~15 | Stats calculations |
| stage_progress_test.dart | ~12 | Progress model |
| game_type_test.dart | ~10 | Enum helpers |
| question_test.dart | ~10 | Question model |
| game_emojis_test.dart | ~10 | Emoji access |
| question_config_test.dart | ~8 | Config templates |
| app_sizes_test.dart | ~5 | Size constants |

### 8.2 ปัญหา Testing

#### ❌ Tests ไม่ได้ wait สำหรับ async operations
```dart
// ใน game_provider_test.dart
provider.checkAnswer(correctAnswer, ...);
// checkAnswer ใช้ Future.delayed(1.5s) ก่อน nextQuestion
// test จบก่อนที่ delay จะสิ้นสุด
expect(provider.currentQuestionIndex, 1);  // อาจ fail!
```

#### ❌ ไม่มี mock สำหรับ dependencies
Tests ใช้ real `ProgressService` และ `StatsRepository`
→ tests เป็น integration tests ไม่ใช่ unit tests

#### ❌ ไม่มี Widget Tests
ไม่มีการ test UI components เลย (AnswerButton, GameCard, etc.)

#### ❌ ไม่มี Integration/E2E tests
ไม่มี test สำหรับ full game flow

---

## 9. สรุป: อะไรต้องปรับ

### 🔴 Critical — ทำทันที

| # | ปัญหา | ไฟล์ | วิธีแก้ |
|---|-------|------|---------|
| 1 | **API Key ใน source code** | `lib/services/gemini_api_service.dart:7` | ย้ายไป `--dart-define` หรือ backend proxy |
| 2 | **Race condition ใน timer** | `lib/providers/game_provider.dart` | ใช้ `Timer?` + cancel ใน `dispose()` |
| 3 | **`_correctAnswers` ไม่ reset** | `lib/providers/game_provider.dart` | เพิ่มใน `reset()` method |
| 4 | **Font family โหลดซ้ำ** | `lib/core/theme/app_typography.dart:15` | Cache เป็น `static final` |

---

### 🟠 High — ทำใน Sprint ถัดไป

| # | ปัญหา | ไฟล์ | วิธีแก้ |
|---|-------|------|---------|
| 5 | **MathGrid ไม่ implement** | `lib/data/question_bank/question_bank.dart:42` | สร้าง `MathGridQuestions` class |
| 6 | **ไม่มี Result Screen** | `lib/screens/` | สร้าง `GameResultScreen` ที่สมบูรณ์ |
| 7 | **ไม่มี Pause / Back confirm** | `lib/screens/game/game_screen.dart` | เพิ่ม WillPopScope + PauseDialog |
| 8 | **Silent errors** | ทุก service | เพิ่ม error handling + user feedback |
| 9 | **Mutable maps ใน KidStats** | `lib/data/models/kid_stats.dart` | ใช้ `Map.unmodifiable()` |
| 10 | **ไม่มี bounds check ใน QuestionBank** | `lib/data/question_bank/` | เพิ่ม validation |

---

### 🟡 Medium — ทำใน Quarter นี้

| # | ปัญหา | ไฟล์ | วิธีแก้ |
|---|-------|------|---------|
| 11 | **Question เป็น God Object** | `lib/data/models/question.dart` | Refactor เป็น sealed classes |
| 12 | **Tight coupling ใน Provider** | `lib/providers/game_provider.dart` | Inject dependencies via constructor |
| 13 | **Duplicate code ใน Question Banks** | `lib/data/question_bank/` | Extract base class |
| 14 | **ไม่มี schema versioning** | `lib/data/repositories/` | เพิ่ม version field ใน JSON |
| 15 | **Tablet layout ไม่รองรับ** | `lib/core/theme/app_sizes.dart` | เพิ่ม tablet breakpoints |
| 16 | **Backward compat constants** | `lib/core/theme/app_theme.dart:18-35` | ลบออกหลัง refactor |
| 17 | **Difficulty ไม่ถูกใช้** | `lib/providers/game_provider.dart` | Implement หรือลบออก |

---

### 🔵 Low — Technical Debt

| # | ปัญหา | วิธีแก้ |
|---|-------|---------|
| 18 | print() ใน production code | เปลี่ยนเป็น `debugPrint()` ทั้งหมด |
| 19 | ขาด `toString()`, `==`, `hashCode` ใน models | เพิ่มใน Question, StageProgress |
| 20 | Line height สำหรับเด็ก | เพิ่มเป็น 1.4 สำหรับ body text |
| 21 | buildContext async gap warnings | ตรวจสอบ mounted ก่อนใช้ context |

---

## 10. สรุป: อะไรต้องเพิ่ม

### 🎮 Feature ที่ขาด (ต้องมีก่อน Launch)

#### 1. Result / Game Over Screen ที่สมบูรณ์
```
หลังตอบครบ 10 ข้อ:
┌─────────────────────────────┐
│  ⭐⭐⭐  ยอดเยี่ยมมาก!      │
│  คะแนน: 90/100              │
│  ตอบถูก: 9/10 ข้อ           │
│                              │
│  [เล่นอีกครั้ง] [ด่านถัดไป] │
│  [กลับเมนู]                  │
└─────────────────────────────┘
```

#### 2. Pause Menu
```
[II] ปุ่มในเกม →
┌────────────────┐
│   หยุดพัก     │
│  [เล่นต่อ]    │
│  [🔊/🔇 เสียง] │
│  [ออกจากเกม]  │
└────────────────┘
```

#### 3. Sound Toggle ใน Game
ควบคุมเสียงได้ทันทีโดยไม่ต้องออกจากเกม

#### 4. MathGrid Game Implementation
Game type ที่ 6 ที่ยังไม่ implement

---

### 👪 Parent Features

#### 5. Parent Dashboard
```
[Parent Mode] → PIN หรือ math question สำหรับผู้ใหญ่
├── รายงานความคืบหน้า (เล่นกี่ชั่วโมง, ด่านไหนผ่าน)
├── ตั้งเวลาเล่น (เล่นได้สูงสุดกี่นาทีต่อวัน)
├── เลือก game types ที่เปิดให้เล่น
└── Export รายงาน
```

#### 6. Multiple Child Profiles
ครอบครัวที่มีลูกหลายคน ควรมี profile แยก:
```
เลือกตัวละคร: [น้องแก้ว] [น้องแป้ง] [+ เพิ่มใหม่]
```

#### 7. Screen Time Limit
```dart
// ตั้งได้ว่าเล่นได้ไม่เกิน N นาทีต่อวัน
// เมื่อครบเวลา → แสดงหน้า "พักตาหน่อยนะ" พร้อมขอ PIN ผู้ปกครอง
```

---

### 🎨 UX Enhancements

#### 8. Onboarding / Tutorial
เด็กเล่นครั้งแรกควรมี tutorial:
```
"กดปุ่มตัวเลขที่คิดว่าถูกต้องนะ!"
[highlight ปุ่ม] → [แสดง animation] → [เริ่มเล่น]
```

#### 9. Haptic Feedback
ใช้ `vibration` package (ติดตั้งแล้ว) ให้ครบ:
- ตอบถูก: short buzz
- ตอบผิด: double buzz
- ได้ดาว: long celebration buzz

#### 10. Loading Screen ที่ Polished
Animation ระหว่างโหลด เช่น emoji กระโดด หรือ counting animation

#### 11. Confetti สำหรับ 3 ดาว
ปัจจุบันมี confetti package แล้ว แต่อาจไม่ได้ trigger ที่ result screen

---

### 🏆 Engagement Features

#### 12. Achievement / Badge System
```
🏅 First Win — ผ่านด่านแรกได้
🌟 Perfect Score — ได้ 100 คะแนน
🔥 Hot Streak — เล่น 7 วันติดกัน
🎯 Sharpshooter — ตอบถูก 10 ข้อติดกัน
🎓 Math Master — ผ่านทุกด่านของ game type นึง
```

#### 13. Daily Challenge
ทุกวันมีโจทย์พิเศษ 5 ข้อ → ได้ bonus stars

#### 14. Streak Rewards
เล่นติดต่อกัน 3 วัน → unlock emoji set ใหม่
เล่นติดต่อกัน 7 วัน → unlock theme สี

---

### 💰 Monetization (Phase 2)

#### 15. Freemium Model
```
Free: ด่าน 1-3 ของทุก game (15 ด่าน)
Premium: ด่าน 4-10 ของทุก game (35 ด่าน) + ฟีเจอร์พิเศษ
```

#### 16. Parent Gate (COPPA Compliance)
ก่อนเข้า purchase → ต้องมี parent gate (คำนวณ 2+3=? สำหรับผู้ใหญ่)

#### 17. In-App Purchase
ใช้ `in_app_purchase` package (ติดตั้งแล้ว) implement:
- One-time purchase: "ปลดล็อคทุกด่าน"
- Subscription: รายเดือน/รายปี

---

### 🤖 AI Features

#### 18. AI Solver ที่ Stable
ปัจจุบันมี AI Math Solver แต่:
- API key exposed → ต้องแก้ก่อน
- ไม่มี error handling ถ้า network ล่ม
- ไม่มี rate limiting

#### 19. AI-Generated Hints
เมื่อเด็กตอบผิดหลายครั้ง → AI อธิบาย hint แบบเข้าใจง่าย

---

### 🔧 Technical Improvements

#### 20. Dependency Injection
ใช้ `get_it` package:
```dart
// lib/core/di/injection.dart
final getIt = GetIt.instance;

void configureDependencies() {
  getIt.registerSingleton<AudioManager>(AudioManager());
  getIt.registerLazySingleton<IProgressService>(() => ProgressService());
  getIt.registerLazySingleton<IStatsRepository>(() => StatsRepository());
}
```

#### 21. Proper Logging
ใช้ `logger` package:
```dart
final log = Logger();
log.d('Game started: $gameType, stage: $stageNumber');
log.e('Failed to save progress', error: e, stackTrace: st);
```

#### 22. Question Data as JSON Assets
ย้ายคำถามออกจาก Dart code:
```
assets/data/questions/
├── counting.json
├── addition.json
├── subtraction.json
├── comparison.json
└── sequence.json
```

#### 23. Dark Mode Support
```dart
// lib/core/theme/app_theme.dart
static ThemeData get darkTheme => ThemeData.dark().copyWith(
  colorScheme: ColorScheme.dark(...),
  // ...
);
```

---

## 11. Roadmap

### Sprint 0 — Security & Critical Bugs (1 สัปดาห์)
**Priority: MUST DO ก่อนทุกอย่าง**

| Task | ไฟล์ | Effort |
|------|------|--------|
| 🔴 Rotate & secure Gemini API key | `gemini_api_service.dart` | 2h |
| 🔴 Fix `_correctAnswers` ไม่ reset | `game_provider.dart` | 1h |
| 🔴 Fix race condition / timer leak | `game_provider.dart` | 2h |
| 🔴 Cache font family | `app_typography.dart` | 30m |
| 🔴 เพิ่ม mounted checks ทุก async context | screens | 2h |

**Deliverable:** App ไม่ crash, scores ถูกต้อง, API key ปลอดภัย

---

### Sprint 1 — Core Game Completion (2 สัปดาห์)
**Priority: Phase 1 ยังไม่สมบูรณ์**

| Task | Effort |
|------|--------|
| 🟠 สร้าง `GameResultScreen` สมบูรณ์ (stars, score, replay, next stage) | 3 days |
| 🟠 Implement MathGrid game + questions | 3 days |
| 🟠 เพิ่ม Pause Dialog + Back Button confirmation | 1 day |
| 🟠 เพิ่ม Sound Toggle ใน game | 1 day |
| 🟠 Haptic feedback สำหรับ correct/wrong answer | 1 day |
| 🟠 Fix bounds checking ใน QuestionBank | 2h |

**Deliverable:** ครบ 6 games, result screen สมบูรณ์, UX พื้นฐานครบ

---

### Sprint 2 — Architecture & Quality (2 สัปดาห์)
**Priority: Technical foundation**

| Task | Effort |
|------|--------|
| ⚠️ Add interfaces สำหรับ services (`IProgressService`, `IStatsRepository`) | 1 day |
| ⚠️ Inject dependencies via constructor ใน GameProvider | 1 day |
| ⚠️ Setup `get_it` DI container | 1 day |
| ⚠️ เปลี่ยน `Map` เป็น `Map.unmodifiable()` ใน KidStats | 2h |
| ⚠️ เพิ่ม schema versioning ใน JSON storage | 1 day |
| ⚠️ เปลี่ยน `print()` → `debugPrint()` ทั้งโปรเจกต์ | 2h |
| ⚠️ เพิ่ม `toString()`, `==`, `hashCode` ใน models | 3h |
| ⚠️ Refactor Question Banks ให้มี base class | 2 days |
| ⚠️ Fix tests: add async waits, mock dependencies | 2 days |

**Deliverable:** Code clean, testable, DI พร้อม

---

### Sprint 3 — UX & Polish (2 สัปดาห์)
**Priority: เด็กใช้งานดีขึ้น**

| Task | Effort |
|------|--------|
| ✨ Onboarding/Tutorial ครั้งแรก | 2 days |
| ✨ Confetti animation ที่ Result Screen | 1 day |
| ✨ Answer feedback ชัดขึ้น (icon overlay + animation) | 2 days |
| ✨ Loading screen animation | 1 day |
| ✨ Improve ObjectsPainter: cache + better grid | 1 day |
| ✨ เพิ่ม semantic labels สำหรับ accessibility | 1 day |
| ✨ Tablet responsive layout | 2 days |
| ✨ Fix hardcoded values → AppSpacing/AppSizes | 1 day |

**Deliverable:** App สวย, responsive, accessible

---

### Sprint 4 — Engagement System (2 สัปดาห์)
**Priority: Retention**

| Task | Effort |
|------|--------|
| 🏆 Achievement system (10 badges) | 3 days |
| 🔥 Streak tracking + rewards | 2 days |
| 📅 Daily Challenge (5 ข้อต่อวัน) | 2 days |
| 🌟 Unlock-able emoji sets | 1 day |
| 📊 Simple stats dashboard ใน MainMenu | 2 days |

**Deliverable:** เด็กอยากกลับมาเล่นทุกวัน

---

### Sprint 5 — Parent Features (2 สัปดาห์)
**Priority: ผู้ปกครอง trust app มากขึ้น**

| Task | Effort |
|------|--------|
| 👪 Multiple child profiles | 3 days |
| 📋 Parent Dashboard + progress report | 3 days |
| ⏰ Screen time limit + parent PIN | 2 days |
| 🔒 Parent Gate (COPPA) | 1 day |

**Deliverable:** ผู้ปกครองควบคุมได้, COPPA compliant

---

### Sprint 6 — Monetization (2 สัปดาห์)
**Priority: Revenue**

| Task | Effort |
|------|--------|
| 💰 Freemium gate (lock stages 4-10) | 2 days |
| 💳 Implement `in_app_purchase` (one-time unlock) | 3 days |
| 📱 Subscription model (monthly/yearly) | 2 days |
| 🧾 Receipt validation | 2 days |
| ✅ Test on Google Play Sandbox | 1 day |

**Deliverable:** Revenue model พร้อม submit Play Store

---

### Sprint 7 — Launch Prep (1 สัปดาห์)
**Priority: Go to market**

| Task | Effort |
|------|--------|
| 📸 Store screenshots (5-8 หน้า) | 1 day |
| 📝 Store listing copy (Thai + English) | 1 day |
| 🔐 Privacy Policy + Terms of Service | 1 day |
| 🧪 Beta testing (TestFlight / Play Console) | 2 days |
| 🚀 Submit to stores | 1 day |

**Deliverable:** App บน Play Store + App Store

---

### Quarter 2 — Growth (หลัง Launch)

| Feature | Priority | Effort |
|---------|---------|--------|
| Questions as JSON assets (ง่ายต่อการ update content) | High | 1 week |
| AI-generated hints เมื่อตอบผิดซ้ำ | Medium | 1 week |
| Dark Mode | Medium | 3 days |
| Push notifications (daily reminder) | Medium | 3 days |
| Backend sync (cross-device progress) | Low | 2 weeks |
| Multiplayer / family leaderboard | Low | 3 weeks |
| More game types (Multiplication, Division) | High | 2 weeks |
| Landscape mode support | Low | 1 week |

---

### Timeline Summary

```
Week 1:     Sprint 0 — Security & Critical Bugs
Week 2-3:   Sprint 1 — Core Game Completion
Week 4-5:   Sprint 2 — Architecture & Quality
Week 6-7:   Sprint 3 — UX & Polish
Week 8-9:   Sprint 4 — Engagement System
Week 10-11: Sprint 5 — Parent Features
Week 12-13: Sprint 6 — Monetization
Week 14:    Sprint 7 — Launch Prep
─────────────────────────────────────────
Month 4+:   Growth Features
```

---

## Priority Matrix

```
                HIGH IMPACT
                    │
   Parent Dashboard │ Result Screen
   Monetization     │ Pause Menu
   Achievement      │ Sound Toggle
                    │ Haptic Feedback
   ─────────────────┼─────────────────
   HARD TO DO       │             EASY TO DO
                    │
   MathGrid Game    │ Font Cache Fix
   DI Container     │ Correct Answers Reset
   Tablet Layout    │ API Key Secure
   Backend Sync     │ Bounds Checking
                    │
                LOW IMPACT
```

---

*Report นี้ generate จากการ analyze source code โดยตรง — ทุก issue มี file path อ้างอิง*
