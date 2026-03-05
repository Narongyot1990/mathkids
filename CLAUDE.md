# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

MathKids Adventure is a Flutter educational game for children aged 3-6 to learn basic math. It targets Android, iOS, Web, and Windows. UI text is in Thai; code comments may be in English or Thai.

## Commands

```bash
# Dependencies
flutter pub get

# Run
flutter run
flutter run -d chrome        # Web
flutter run -d windows       # Windows desktop

# Code quality
flutter analyze
flutter format lib/

# Tests
flutter test                                          # All tests
flutter test test/core/assets/game_emojis_test.dart  # Single file
flutter test --name "should return correct emoji"     # By name (exact)
flutter test --name "GameEmojis"                      # By pattern (regex)
flutter test test/core/                               # By directory
flutter test --coverage                               # With coverage

# Production builds
flutter build apk --release
flutter build appbundle --release
flutter build ios --release
flutter build web
flutter build windows
```

## Architecture

### Layer Structure

```
lib/
├── core/           # Theme constants (colors, sizes, spacing, typography) and emoji assets
├── data/
│   ├── models/         # Question, GameType, StageProgress, KidStats
│   ├── question_bank/  # Static question data — one file per game type
│   └── repositories/   # StatsRepository (SharedPreferences-backed)
├── providers/      # GameProvider — single ChangeNotifier for all game state
├── screens/        # One folder per screen; game/ has a widgets/ subfolder
├── services/       # ProgressService (save/load stage progress), audio/
├── ui/             # Custom painters
├── widgets/        # Reusable widgets shared across screens
└── main.dart       # Entry point: sets portrait orientation, initializes audio, runs MultiProvider
```

### Key Architectural Patterns

**Data-Driven Question System**: All questions are static data in `lib/data/question_bank/`. Each file (`addition_questions.dart`, `counting_questions.dart`, etc.) defines a list of `QuestionTemplate` objects with `level`, `question`, `correctAnswer`, `wrongAnswers`, and `data`. `QuestionBank` (central manager) retrieves questions by `GameType` and stage number. This gives fixed progression — same questions every playthrough.

**State Management**: A single `GameProvider` (Provider + ChangeNotifier) holds all runtime game state: current question, score, answer feedback. Access via `context.read<GameProvider>()` / `context.watch<GameProvider>()`.

**Progress Persistence**: `ProgressService` saves per-stage results (stars, score) to `SharedPreferences` as JSON. Best-Score logic: higher star count wins; ties resolved by higher score.

**Game Flow**:
```
MainMenuScreen → LevelSelectScreen (5 game types)
  → StageSelectScreen (10 stages per game)
  → GameScreen (10 questions, multiple-choice answers)
  → Results (stars + score saved via ProgressService)
```

### Game Types & Scoring

Six game types defined (`counting`, `addition`, `subtraction`, `comparison`, `sequence`, `mathGrid`) × 10 stages = 60 stages planned. **`mathGrid` is NOT implemented** — `question_bank.dart:42` falls back to Addition questions.

Scoring: 10 pts/correct answer, max 100 per game. Stars: ≥90% → 3⭐, ≥70% → 2⭐, ≥50% → 1⭐.

### Code Conventions

- Files: `snake_case.dart`; Classes/Enums: `PascalCase`; methods/vars: `camelCase`; private: `_prefix`
- Imports: package imports first, then relative imports, each group sorted alphabetically
- Prefer `StatelessWidget` and `const` constructors; use `StatefulWidget` only when local state is needed
- Use `debugPrint` instead of `print`
- Class member order: constants → variables → constructors → lifecycle methods → public methods → private methods → getters/setters

### Adding Content

**New question**: Add a `QuestionTemplate` entry to the relevant file in `lib/data/question_bank/`.

**New screen**: Create `lib/screens/<name>/<name>_screen.dart`, follow existing screen patterns.

**New test**: Mirror the `lib/` path under `test/`, e.g., `lib/data/models/question.dart` → `test/data/models/question_test.dart`.

## Known Bugs (from research 2026-03-02)

> Full analysis: `docs/RESEARCH_REPORT.md`

### 🔴 Critical — Fix Before Anything Else

| Bug | File | Fix |
|-----|------|-----|
| Gemini API key hardcoded in source | `lib/services/gemini_api_service.dart:7` | Move to `String.fromEnvironment('GEMINI_API_KEY')`, rotate key on Google Cloud |
| `_correctAnswers` not reset between games | `lib/providers/game_provider.dart` — `reset()` | Add `_correctAnswers = 0;` |
| Race condition: `Future.delayed` fires after `dispose()` | `lib/providers/game_provider.dart` | Replace with `Timer? _pendingTimer`, cancel in `dispose()` |
| Google Fonts loaded on every `TextStyle` access | `lib/core/theme/app_typography.dart:15` | `static final String _fontFamily = GoogleFonts.fredoka().fontFamily!;` |

### 🟠 High — Sprint 1

| Bug | File |
|-----|------|
| MathGrid falls back to Addition questions | `lib/data/question_bank/question_bank.dart:42` |
| No bounds check → crash if `level > bank.length` | `lib/data/question_bank/*.dart` |
| `KidStats` maps are mutable (can be accidentally modified) | `lib/data/models/kid_stats.dart` |
| `BuildContext` used across `async` gaps (lint warnings) | multiple screens |

## Incomplete Features

- **No `GameResultScreen`** — what the player sees after 10 questions is unclear; needs a proper result/game-over screen with stars, score, replay, and next-stage buttons.
- **MathGrid not implemented** — game type exists in enum but has no question bank or game widget.
- **No Pause / back-button confirmation** — pressing Back during a game exits immediately with no confirmation.
- **No Sound Toggle in-game** — audio can only be controlled from OS settings.
- **`Difficulty` param in `checkAnswer()`** is accepted but never used.

## Roadmap (14 weeks to store launch)

| Sprint | Duration | Focus |
|--------|---------|-------|
| **Sprint 0** | 1 week | Security + critical bug fixes (see bugs above) |
| **Sprint 1** | 2 weeks | GameResultScreen, MathGrid, Pause dialog, Sound toggle, Haptic feedback |
| **Sprint 2** | 2 weeks | DI with `get_it`, service interfaces, test mocking, JSON schema versioning |
| **Sprint 3** | 2 weeks | UX polish: onboarding, confetti, answer animations, tablet layout |
| **Sprint 4** | 2 weeks | Achievements, streak rewards, daily challenge |
| **Sprint 5** | 2 weeks | Multiple child profiles, Parent Dashboard, screen-time limit |
| **Sprint 6** | 2 weeks | Freemium gate (lock stages 4–10), `in_app_purchase` (package already installed) |
| **Sprint 7** | 1 week | Store assets, Privacy Policy, beta test, submit |

## Known Lint Warnings (Non-Critical)

- `print` statements in production code (replace with `debugPrint`)
- `BuildContext` used across async gaps (add `if (!mounted) return;` after every `await`)

Run `flutter analyze` to see the current state.
