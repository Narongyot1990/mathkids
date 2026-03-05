# MathKids Adventure - Project Summary

> เกมคณิตศาสตร์สนุกสำหรับเด็ก 3-6 ขวบ | Built with Flutter

---

## 📊 Project Statistics

| Metric | Value |
|--------|-------|
| **Total Tests** | 105 |
| **Test Files** | 9 |
| **Coverage (Core/Data)** | ~80%+ |
| **Total Dart Files** | 70+ |
| **Total Lines of Code** | ~15,000+ |

---

## 🎮 Game Overview

### 5 Core Games
1. **🔢 Counting** - นับวัตถุ 1-10 ลูก
2. **➕ Addition** - บวกเลข 1+1 ถึง 4+2
3. **➖ Subtraction** - ลบเลข 2-1 ถึง 7-3
4. **⚖️ Comparison** - เปรียบเทียบ <, =, >
5. **🔄 Sequence** - หาลำดับตัวเลข

**Total Stages**: 5 games × 10 stages = **50 stages**

---

## 🏗️ Architecture

### Tech Stack
- **Framework**: Flutter 3.0+
- **Language**: Dart 3.0+
- **State Management**: Provider
- **Storage**: SharedPreferences
- **Audio**: audioplayers

### Design Patterns
- ✅ **Data-Driven Design** - Questions stored as static data
- ✅ **Provider Pattern** - State management
- ✅ **Repository Pattern** - Data access layer
- ✅ **Service Pattern** - Business logic

---

## 📂 Project Structure

```
lib/
├── core/                         # Core utilities
│   ├── assets/                  # Game emojis
│   └── theme/                   # App theme, colors, sizes
├── data/                         # Data layer
│   ├── models/                  # Data models
│   │   ├── game_type.dart      # GameType, Difficulty enums
│   │   ├── kid_stats.dart      # Player statistics
│   │   ├── question.dart       # Question model
│   │   └── stage_progress.dart # Stage progress model
│   ├── question_bank/           # Static question data
│   │   ├── addition_questions.dart
│   │   ├── counting_questions.dart
│   │   ├── subtraction_questions.dart
│   │   ├── comparison_questions.dart
│   │   ├── sequence_questions.dart
│   │   ├── question_bank.dart
│   │   └── question_config.dart
│   └── repositories/            # Data repositories
├── providers/                   # State management
│   └── game_provider.dart      # Main game state
├── screens/                     # UI screens
│   ├── main_menu/
│   ├── level_select/
│   ├── stage_select/
│   ├── game/
│   │   └── widgets/            # Game-specific widgets
│   └── ai_math_solver/         # AI solver feature
├── services/                    # Business logic
│   ├── audio/                  # Audio services
│   ├── progress_service.dart
│   └── gemini_api_service*     # AI services
├── widgets/                     # Reusable widgets
└── main.dart                   # App entry point
```

---

## 🧪 Testing

### Test Structure
```
test/
├── core/
│   ├── assets/
│   │   └── game_emojis_test.dart
│   └── theme/
│       └── app_sizes_test.dart
├── data/
│   ├── models/
│   │   ├── game_type_test.dart
│   │   ├── kid_stats_test.dart
│   │   ├── question_test.dart
│   │   └── stage_progress_test.dart
│   └── question_bank/
│       ├── question_bank_test.dart
│       └── question_config_test.dart
└── providers/
    └── game_provider_test.dart
```

### Running Tests
```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/core/assets/game_emojis_test.dart

# Run tests with coverage
flutter test --coverage

# Run tests by name pattern
flutter test --name "QuestionBank"
```

---

## 📦 Dependencies

### Core Dependencies
- `provider: ^6.1.5+1` - State management
- `audioplayers: ^6.5.1` - Audio playback
- `shared_preferences: ^2.5.4` - Local storage
- `google_fonts: ^6.3.3` - Typography
- `lottie: ^3.3.2` - Animations
- `confetti: ^0.8.0` - Celebration effects
- `vibration: ^3.1.4` - Haptic feedback

### Additional Features
- `in_app_purchase` - Monetization
- `url_launcher` - External links
- `camera` / `image_picker` - AI Solver
- `http` - API calls
- `flutter_markdown` - Markdown rendering
- `flutter_math_fork` - LaTeX rendering

---

## 🚀 Features

### Implemented
- ✅ 5 Math Games with 10 stages each
- ✅ Data-Driven Question System (static progression)
- ✅ Best Score System (stars + high scores)
- ✅ Audio System (background music + sound effects)
- ✅ Progress Tracking
- ✅ Responsive Design (iPhone optimized)
- ✅ Kid-Friendly UI (vibrant colors, large buttons)

### Planned
- 🔜 Parent Gate (COPPA compliance)
- 🔜 Paywall & Subscriptions
- 🔜 AI Math Solver (camera-based)

---

## 🎨 UI/UX Design

### Color System
- **Primary**: Blue, Pink, Yellow, Green, Orange, Purple
- **Background**: Cream/Beige, Light Sky Blue
- **Status**: Success (Green), Error (Red), Warning (Orange)

### Typography
- **Font**: Google Fonts (Kanit for Thai)
- **Style**: Large, readable, child-friendly

### Responsive Breakpoints
- Small: < 360px (iPhone SE)
- Medium: 360-430px (iPhone 13/14/15)
- Large: > 430px (iPhone Pro Max)

---

## 📝 Key Classes

### Models
| Class | Description |
|-------|-------------|
| `Question` | Math question with options |
| `GameType` | Enum for 5 game types |
| `Difficulty` | Easy/Medium/Hard |
| `KidStats` | Player statistics |
| `StageProgress` | Stage completion status |

### Providers
| Provider | Description |
|----------|-------------|
| `GameProvider` | Main game state management |

### Services
| Service | Description |
|---------|-------------|
| `ProgressService` | Save/load stage progress |
| `StatsRepository` | Player statistics management |
| `AudioManager` | Audio playback control |

---

## 📈 Build Commands

```bash
# Install dependencies
flutter pub get

# Run the app
flutter run

# Build for production
flutter build apk --release       # Android
flutter build ios --release       # iOS
flutter build web                 # Web
flutter build windows             # Windows

# Code quality
flutter analyze                   # Lint check
flutter format lib/               # Format code
```

---

## 📅 Version History

### v1.0.0 (2025-12-29)
- ✅ Initial release
- ✅ 5 games × 10 stages
- ✅ Data-driven question system
- ✅ Best Score system
- ✅ Audio system
- ✅ Progress tracking

---

## 👨‍💻 Development Team

- **Lead Developer**: Flutter/Dart
- **Target Audience**: Children 3-6 years old
- **Language**: Thai (primary), English (code)

---

## 📄 License

Copyright © 2025 MathKids Adventure. All rights reserved.

---

**Made with ❤️ for young learners** 🎮
