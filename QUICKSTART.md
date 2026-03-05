# MathKids Adventure - Quick Start Guide

> เกมคณิตศาสตร์สนุกสำหรับเด็ก 3-6 ขวบ | Built with Flutter

---

## 🚀 Quick Start

### 1. Clone & Install

```bash
# Clone project
git clone <repo-url>
cd mathkids_adventure

# Install dependencies
flutter pub get

# Run on Chrome (Web)
flutter run -d chrome
```

### 2. Run Tests

```bash
# All tests
flutter test

# Single test file
flutter test test/core/assets/game_emojis_test.dart

# By test name
flutter test --name "GameProvider"
```

### 3. Build

```bash
# Android APK
flutter build apk --release

# Web
flutter build web

# Windows
flutter build windows
```

---

## 📋 Prerequisites

| Tool | Version |
|------|---------|
| Flutter SDK | ^3.10.4 |
| Dart | ^3.10.4 |
| Node.js | 18+ (for web builds) |

---

## 🎮 Games

| # | Game | Description |
|---|------|-------------|
| 1 | 🔢 Counting | นับวัตถุ 1-10 |
| 2 | ➕ Addition | บวกเลข 1+1 ถึง 4+2 |
| 3 | ➖ Subtraction | ลบเลข 2-1 ถึง 7-3 |
| 4 | ⚖️ Comparison | เปรียบเทียบ <, =, > |
| 5 | 🔄 Sequence | หาลำดับตัวเลข |

**Total Stages**: 5 games × 10 stages = **50 stages**

---

## 📁 Project Structure

```
lib/
├── core/           # Theme, assets, constants
├── data/
│   ├── models/         # Question, GameType, KidStats
│   ├── question_bank/  # Static questions
│   └── repositories/   # StatsRepository
├── providers/      # GameProvider (state management)
├── screens/        # UI screens
├── services/       # Progress, Audio, AI Solver
├── ui/             # Custom painters
├── widgets/        # Reusable widgets
└── main.dart       # Entry point
```

---

## 🔧 Common Commands

```bash
# Code analysis
flutter analyze

# Format code
flutter format lib/

# With coverage
flutter test --coverage
```

---

## 📄 Documentation

- [AGENTS.md](./AGENTS.md) - Developer Guide for AI agents
- [CLAUDE.md](./CLAUDE.md) - Claude Code instructions
- [PROJECT_SUMMARY.md](./PROJECT_SUMMARY.md) - Project overview

---

## ⚠️ Known Issues

- 65 info-level lint warnings (non-critical)
- 6 integration tests fail (require external images + API)

---

## ✅ Status

| Check | Status |
|-------|--------|
| flutter analyze | ✅ Pass |
| flutter test | ✅ 102/108 Pass |
| Build Android | ✅ Ready |
| Build Web | ✅ Ready |
| Build Windows | ✅ Ready |
