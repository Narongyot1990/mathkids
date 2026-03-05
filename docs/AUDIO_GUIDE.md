# Audio System Guide

> เสียงประกอบและดนตรีสำหรับ MathKids Adventure

---

## 📊 System Overview

### Audio Components

| Component | Purpose | Implementation |
|-----------|---------|----------------|
| **Background Music** | ดนตรีพื้นหลัง | `BackgroundMusicService` |
| **Sound Effects** | เสียงเวลาตอบถูก/ผิด | `SoundEffectsService` |
| **Audio Manager** | จัดการทั้งหมด | `AudioManager` (Singleton) |

---

## 🎵 Audio Files

### Background Music
```
assets/audio/music/
├── main_menu.mp3        # หน้าเมนูหลัก
├── game_play.mp3        # ระหว่างเล่นเกม
└── victory.mp3          # ชนะเกม
```

### Sound Effects
```
assets/audio/sfx/
├── button_click.mp3     # กดปุ่ม
├── correct.mp3          # ตอบถูก
├── wrong.mp3            # ตอบผิด
├── star.mp3             # ได้ดาว
└── unlock.mp3           # ปลดล็อคด่าน
```

---

## 🛠️ Implementation

### AudioManager (Singleton)

```dart
// lib/services/audio/audio_manager.dart

final audioManager = AudioManager();

class AudioManager {
  static final AudioManager _instance = AudioManager._internal();
  factory AudioManager() => _instance;
  AudioManager._internal();

  final BackgroundMusicService music = BackgroundMusicService();
  final SoundEffectsService sfx = SoundEffectsService();

  // Global controls
  Future<void> pauseAll() async {
    await music.pause();
    // SFX don't need pause (they're short)
  }

  Future<void> resumeAll() async {
    await music.resume();
  }

  Future<void> stopAll() async {
    await music.stop();
  }
}
```

### Background Music Service

```dart
// lib/services/audio/background_music_service.dart

class BackgroundMusicService {
  final AudioPlayer _player = AudioPlayer();
  String? _currentTrack;

  Future<void> playMainMenu() async {
    await _play('assets/audio/music/main_menu.mp3');
  }

  Future<void> playGamePlay() async {
    await _play('assets/audio/music/game_play.mp3');
  }

  Future<void> playVictory() async {
    await _play('assets/audio/music/victory.mp3', loop: false);
  }

  Future<void> _play(String asset, {bool loop = true}) async {
    if (_currentTrack == asset && _player.state == PlayerState.playing) {
      return; // Already playing this track
    }

    await _player.stop();
    await _player.setSource(AssetSource(asset));
    await _player.setReleaseMode(loop ? ReleaseMode.loop : ReleaseMode.release);
    await _player.resume();

    _currentTrack = asset;
  }

  Future<void> pause() async {
    await _player.pause();
  }

  Future<void> resume() async {
    await _player.resume();
  }

  Future<void> stop() async {
    await _player.stop();
    _currentTrack = null;
  }

  void dispose() {
    _player.dispose();
  }
}
```

### Sound Effects Service

```dart
// lib/services/audio/sound_effects_service.dart

class SoundEffectsService {
  final AudioPlayer _player = AudioPlayer();

  Future<void> playButtonClick() async {
    await _play('assets/audio/sfx/button_click.mp3');
  }

  Future<void> playCorrect() async {
    await _play('assets/audio/sfx/correct.mp3');
  }

  Future<void> playWrong() async {
    await _play('assets/audio/sfx/wrong.mp3');
  }

  Future<void> playStar() async {
    await _play('assets/audio/sfx/star.mp3');
  }

  Future<void> playUnlock() async {
    await _play('assets/audio/sfx/unlock.mp3');
  }

  Future<void> _play(String asset) async {
    await _player.stop();
    await _player.setSource(AssetSource(asset));
    await _player.setReleaseMode(ReleaseMode.release);
    await _player.resume();
  }

  void dispose() {
    _player.dispose();
  }
}
```

---

## 🎮 Usage Examples

### In Game Screen

```dart
class GameScreen extends StatefulWidget {
  @override
  void initState() {
    super.initState();

    // Play game music
    audioManager.music.playGamePlay();
  }

  @override
  void dispose() {
    // Stop music when leaving
    audioManager.music.stop();
    super.dispose();
  }

  void _handleAnswer(int answer) {
    final isCorrect = answer == correctAnswer;

    if (isCorrect) {
      audioManager.sfx.playCorrect();
    } else {
      audioManager.sfx.playWrong();
    }
  }

  void _onGameComplete(int stars) {
    audioManager.music.playVictory();

    for (int i = 0; i < stars; i++) {
      Future.delayed(Duration(milliseconds: 500 * i), () {
        audioManager.sfx.playStar();
      });
    }
  }
}
```

### In Main Menu

```dart
class MainMenuScreen extends StatefulWidget {
  @override
  void initState() {
    super.initState();
    audioManager.music.playMainMenu();
  }

  void _onButtonTap() {
    audioManager.sfx.playButtonClick();
    // Navigate...
  }
}
```

### App Lifecycle

```dart
class MyApp extends StatefulWidget {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
        audioManager.pauseAll();
        break;
      case AppLifecycleState.resumed:
        audioManager.resumeAll();
        break;
      case AppLifecycleState.inactive:
        audioManager.pauseAll();
        break;
      case AppLifecycleState.detached:
        audioManager.stopAll();
        break;
    }
  }
}
```

---

## ⚙️ Configuration

### Audio Context

```dart
// lib/services/audio/audio_config.dart

class AudioConfig {
  static const double musicVolume = 0.5;
  static const double sfxVolume = 0.7;

  static const bool enableMusic = true;
  static const bool enableSFX = true;
}
```

### pubspec.yaml

```yaml
dependencies:
  audioplayers: ^6.0.0

flutter:
  assets:
    - assets/audio/music/
    - assets/audio/sfx/
```

---

## 🐛 Troubleshooting

### ปัญหาที่พบบ่อย

#### 1. เสียงไม่ออก (iOS)
**สาเหตุ**: AVAudioSession ไม่ได้ตั้งค่า

**วิธีแก้**:
```swift
// ios/Runner/AppDelegate.swift
import AVFoundation

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let session = AVAudioSession.sharedInstance()
    try? session.setCategory(.playback, mode: .default)
    try? session.setActive(true)

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
```

#### 2. เสียงไม่ loop (Android)
**สาเหตุ**: ReleaseMode ไม่ถูกต้อง

**วิธีแก้**:
```dart
await _player.setReleaseMode(ReleaseMode.loop);
```

#### 3. หลายเสียงเล่นพร้อมกัน
**สาเหตุ**: ใช้ AudioPlayer instance เดียวกัน

**วิธีแก้**: ใช้ AudioPlayer แยกสำหรับ Music และ SFX

---

## 🎯 Best Practices

### DO ✅
- ใช้ `audioManager.sfx.playX()` สำหรับเสียงสั้นๆ
- ใช้ `audioManager.music.playX()` สำหรับดนตรีพื้นหลัง
- หยุดเสียงเมื่อ app pause/inactive
- ใช้ AssetSource สำหรับไฟล์ในแอป

### DON'T ❌
- อย่าสร้าง AudioPlayer instance ใหม่ทุกครั้ง
- อย่าลืม dispose() AudioPlayer
- อย่าเล่นเสียงหลายเพลงพร้อมกัน (Music)
- อย่าใช้เสียงไฟล์ใหญ่เกินไป (>500KB)

---

## 📝 Changelog

### v1.0.0 (Current)
- ✅ Background music system
- ✅ Sound effects system
- ✅ Singleton AudioManager
- ✅ App lifecycle handling

### Future Enhancements
- 🔜 Volume controls UI
- 🔜 Mute/Unmute button
- 🔜 Sound settings persistence
- 🔜 Haptic feedback integration
