# AGENTS.md - Developer Guide for MathKids Adventure

This document provides guidelines and commands for AI agents working on this Flutter project.

---

## 1. Build, Lint, and Test Commands

### Flutter Commands

```bash
# Install dependencies
flutter pub get

# Run the app
flutter run

# Run on a specific device
flutter run -d <device_id>
flutter run -d chrome  # Web
flutter run -d windows # Windows desktop
```

### Code Analysis & Formatting

```bash
# Analyze code for errors and warnings
flutter analyze

# Format code
flutter format lib/
flutter format .  # Format entire project

# Check specific file
flutter analyze lib/main.dart
```

### Testing

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run a single test file
flutter test test/core/assets/game_emojis_test.dart

# Run a single test by name (exact match)
flutter test --name "should have correct counting emojis"

# Run tests matching a pattern (regex)
flutter test --name "GameEmojis"

# Run tests in a specific directory
flutter test test/core/

# Run tests with verbose output
flutter test -reporter expanded
```

### Build Commands

```bash
# Android APK
flutter build apk --release

# Android App Bundle (for Play Store)
flutter build appbundle --release

# iOS
flutter build ios --release

# Web
flutter build web

# Windows
flutter build windows
```

---

## 2. Code Style Guidelines

This project follows [Effective Dart](https://dart.dev/guides/language/effective-dart) and Flutter best practices.

### 2.1 File Structure

```
lib/
├── core/                    # Core utilities, theme, assets
├── data/                    # Data layer (models, repositories, question banks)
├── providers/              # State management (Provider pattern)
├── screens/                # UI screens
├── services/               # Business logic services
├── ui/                     # Custom painters
├── widgets/                # Reusable widgets
└── main.dart               # App entry point
```

### 2.2 Imports

- Use **package imports** for external packages:
  ```dart
  import 'package:flutter/material.dart';
  import 'package:provider/provider.dart';
  ```

- Use **relative imports** for internal modules:
  ```dart
  import '../data/models/question.dart';
  import 'providers/game_provider.dart';
  ```

- Sort imports alphabetically within groups:
  ```dart
  import 'package:flutter/material.dart';
  import 'package:provider/provider.dart';
  
  import '../data/models/question.dart';
  import '../services/progress_service.dart';
  ```

### 2.3 Naming Conventions

| Element | Convention | Example |
|---------|------------|---------|
| Classes | PascalCase | `GameProvider`, `Question` |
| Files (classes) | snake_case | `game_provider.dart`, `question.dart` |
| Functions | camelCase | `startGame()`, `checkAnswer()` |
| Variables | camelCase | `currentQuestion`, `isCorrect` |
| Constants | camelCase | `maxScore`, `totalQuestions` |
| Private members | prefix `_` | `_currentLevel`, `_generateNextQuestion()` |
| Enums | PascalCase | `GameType`, `Difficulty` |
| Enum values | camelCase | `GameType.counting` |

### 2.4 Widgets and UI

- Use `const` constructors where possible:
  ```dart
  const SizedBox(width: 16),
  const Text('Score:'),
  ```

- Prefer stateless widgets when state is not needed:
  ```dart
  class KidButton extends StatelessWidget {
    const KidButton({super.key, required this.text, required this.onPressed});
    // ...
  }
  ```

- Use meaningful names for widgets:
  ```dart
  // Good
  class CountingGameWidget extends StatelessWidget { }
  
  // Avoid
  class GameWidget1 extends StatelessWidget { }
  ```

### 2.5 State Management

- Use **Provider** pattern with `ChangeNotifier`:
  ```dart
  class GameProvider with ChangeNotifier {
    Question? _currentQuestion;
    
    Question? get currentQuestion => _currentQuestion;
    
    void checkAnswer(int answer) {
      _isCorrect = answer == _currentQuestion!.correctAnswer;
      notifyListeners();
    }
  }
  ```

- Keep providers focused (single responsibility):
  ```dart
  // Good: Separate providers for different concerns
  class GameProvider with ChangeNotifier { }
  class AudioProvider with ChangeNotifier { }
  
  // Avoid: God provider
  class MegaProvider with ChangeNotifier { }
  ```

### 2.6 Types and Null Safety

- Enable strict null safety:
  ```dart
  // Use nullable types when needed
  Question? _currentQuestion;
  
  // Always check before using nullable
  if (_currentQuestion != null) {
    print(_currentQuestion!.correctAnswer);
  }
  ```

- Prefer `final` for immutable variables:
  ```dart
  final int totalQuestions = 10;
  final Question question = Question(...);
  ```

- Use type inference wisely:
  ```dart
  // Explicit type for public API
  Question get currentQuestion => _currentQuestion;
  
  // var is fine for local inference
  var score = 0;
  ```

### 2.7 Error Handling

- Use try-catch with specific exceptions:
  ```dart
  try {
    final progress = StageProgress.fromJson(
      jsonDecode(data) as Map<String, dynamic>,
    );
  } catch (e) {
    // Handle gracefully
    debugPrint('Error parsing progress: $e');
  }
  ```

- Handle async errors:
  ```dart
  Future<void> loadData() async {
    try {
      final data = await fetchData();
    } catch (e) {
      // Show error UI or fallback
    }
  }
  ```

- Use `debugPrint` instead of `print` for debugging:
  ```dart
  debugPrint('Question loaded: $_currentQuestion');
  ```

### 2.8 Documentation

- Add doc comments for public classes and methods:
  ```dart
  /// Represents a math question with multiple choice options.
  class Question {
    /// The text displayed to the user
    final String questionText;
    
    /// The correct answer value
    final int correctAnswer;
  }
  ```

- Keep comments concise and meaningful:
  ```dart
  // Good: Explains why
  // รีเซ็ตคำตอบที่เลือก
  _lastSelectedAnswer = null;
  
  // Avoid: Redundant
  // Set lastSelectedAnswer to null
  _lastSelectedAnswer = null;
  ```

### 2.9 Code Organization

- One class per file (except small related classes):
  ```dart
  // lib/data/models/question.dart
  class Question { }
  
  // lib/data/models/game_type.dart  
  enum GameType { counting, addition, subtraction, comparison, sequence }
  ```

- Order class members:
  1. Constants
  2. Variables (late, final, var)
  3. Constructors
  4. Lifecycle methods (initState, dispose)
  5. Public methods
  6. Private methods
  7. Getters/Setters

- Limit function length (max 20-30 lines):
  ```dart
  // Break large functions
  void startGame(GameType gameType, Difficulty difficulty) {
    _resetState();
    _loadQuestions(gameType);
    _initializeGame(difficulty);
  }
  ```

---

## 3. Architecture Patterns

### Data-Driven Design
Questions are stored as static data in `lib/data/question_bank/`. This allows:
- Fixed progression (no random generation)
- Easy content updates
- Consistent difficulty

### Repository Pattern
```dart
class StatsRepository {
  Future<void> updateStatsAfterGame({...});
  Future<KidStats> getStats();
}
```

### Service Pattern
```dart
class ProgressService {
  Future<void> saveStageProgress(...);
  Future<List<StageProgress>> getAllStageProgress(...);
}
```

---

## 4. Common Tasks

### Adding a New Question
Edit files in `lib/data/question_bank/`:
```dart
// lib/data/question_bank/addition_questions.dart
QuestionTemplate(
  level: 1,
  question: '1 + 1 = ?',
  correctAnswer: 2,
  wrongAnswers: [1, 3, 4],
  data: QuestionData(operand1: 1, operand2: 1, operation: '+'),
),
```

### Adding a New Screen
1. Create file in `lib/screens/`
2. Use consistent naming: `*_screen.dart`
3. Follow existing screen patterns

### Adding Tests
1. Create file in `test/` matching the lib structure
2. Use descriptive test names:
   ```dart
   test('should return correct emoji for counting game', () { });
   ```

---

## 5. Known Issues

- Print statements in production code (lint warnings only)
- BuildContext async gap warnings (non-critical)

Run `flutter analyze` to check current issues.

---

## 6. Quick Reference

| Task | Command |
|------|---------|
| Get deps | `flutter pub get` |
| Analyze | `flutter analyze` |
| Format | `flutter format lib/` |
| Test all | `flutter test` |
| Test one | `flutter test --name "test name"` |
| Build APK | `flutter build apk --release` |
| Run | `flutter run` |

---

Last updated: 2025-12-29
