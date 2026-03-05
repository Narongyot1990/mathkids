import 'package:flutter/foundation.dart';
import 'package:audioplayers/audioplayers.dart';
import 'audio_config.dart';

/// Sound Effects Service
/// จัดการเสียง effect สั้นๆ - ไม่ loop, เล่นครั้งเดียวแล้วจบ
/// เหมือน PlaySound() ใน Roblox
class SoundEffectsService {
  // Singleton pattern
  static final SoundEffectsService _instance = SoundEffectsService._internal();
  factory SoundEffectsService() => _instance;
  SoundEffectsService._internal();

  // Audio player pool - ใช้หลาย player เพื่อเล่นเสียงทับกันได้
  final List<AudioPlayer> _playerPool = [];
  static const int _maxPlayers = 8; // จำนวน player สูงสุด

  // State
  double _volume = AudioConfig.defaultSfxVolume;
  bool _isMuted = false;

  // ========================================
  // Getters
  // ========================================
  double get volume => _volume;
  bool get isMuted => _isMuted;

  // ========================================
  // Initialization
  // ========================================

  /// เริ่มต้น service - สร้าง player pool
  Future<void> initialize() async {
    // สร้าง player pool
    for (int i = 0; i < _maxPlayers; i++) {
      final player = AudioPlayer();
      await player.setPlayerMode(PlayerMode.lowLatency); // low latency สำหรับ SFX
      _playerPool.add(player);
    }
  }

  // ========================================
  // Play Sound Effects
  // ========================================

  /// เล่นเสียง effect
  Future<void> play(String sfxPath, {double? volumeOverride}) async {
    try {
      // หา player ที่ว่าง
      final player = _getAvailablePlayer();
      if (player == null) {
        debugPrint('No available player for SFX');
        return;
      }

      // ตั้งค่าความดัง
      final effectiveVolume = _isMuted ? 0.0 : (volumeOverride ?? _volume);
      await player.setVolume(effectiveVolume);

      // เล่นเสียง
      await player.play(AssetSource(sfxPath));
    } catch (e) {
      debugPrint('Error playing SFX: $e');
    }
  }

  // ========================================
  // Game Feedback Sounds
  // ========================================

  /// เสียงตอบถูก
  Future<void> playCorrect({double? volume}) async {
    debugPrint('🔊 playCorrect() called');
    await play(AudioConfig.sfxCorrect, volumeOverride: volume);
  }

  /// เสียงตอบผิด
  Future<void> playWrong({double? volume}) async {
    await play(AudioConfig.sfxWrong, volumeOverride: volume);
  }

  /// เสียงได้คะแนนเต็ม/perfect
  Future<void> playPerfect({double? volume}) async {
    await play(AudioConfig.sfxPerfect, volumeOverride: volume);
  }

  // ========================================
  // UI Sounds
  // ========================================

  /// เสียงกดปุ่ม
  Future<void> playButtonClick({double? volume}) async {
    await play(AudioConfig.sfxButtonClick, volumeOverride: volume);
  }

  /// เสียง hover ปุ่ม
  Future<void> playButtonHover({double? volume}) async {
    await play(AudioConfig.sfxButtonHover, volumeOverride: volume);
  }

  /// เสียงเปลี่ยนหน้า
  Future<void> playPageTransition({double? volume}) async {
    await play(AudioConfig.sfxPageTransition, volumeOverride: volume);
  }

  // ========================================
  // Reward Sounds
  // ========================================

  /// เสียงเก็บดาว
  Future<void> playStarCollect({double? volume}) async {
    await play(AudioConfig.sfxStarCollect, volumeOverride: volume);
  }

  /// เสียงเลเวลอัพ
  Future<void> playLevelUp({double? volume}) async {
    await play(AudioConfig.sfxLevelUp, volumeOverride: volume);
  }

  /// เสียงได้ achievement
  Future<void> playAchievement({double? volume}) async {
    await play(AudioConfig.sfxAchievement, volumeOverride: volume);
  }

  /// เสียง confetti
  Future<void> playConfetti({double? volume}) async {
    await play(AudioConfig.sfxConfetti, volumeOverride: volume);
  }

  // ========================================
  // Game State Sounds
  // ========================================

  /// เสียงเริ่มเกม
  Future<void> playGameStart({double? volume}) async {
    await play(AudioConfig.sfxGameStart, volumeOverride: volume);
  }

  /// เสียงจบเกม
  Future<void> playGameOver({double? volume}) async {
    await play(AudioConfig.sfxGameOver, volumeOverride: volume);
  }

  /// เสียงนับถอยหลัง
  Future<void> playCountdown({double? volume}) async {
    await play(AudioConfig.sfxCountdown, volumeOverride: volume);
  }

  /// เสียงเตือนเวลาใกล้หมด
  Future<void> playTimeWarning({double? volume}) async {
    await play(AudioConfig.sfxTimeWarning, volumeOverride: volume);
  }

  // ========================================
  // Volume Control
  // ========================================

  /// ตั้งค่าความดัง (0.0 - 1.0)
  Future<void> setVolume(double volume) async {
    _volume = volume.clamp(0.0, 1.0);

    // อัพเดท volume ของ player ทั้งหมด
    if (!_isMuted) {
      for (final player in _playerPool) {
        await player.setVolume(_volume);
      }
    }
  }

  /// ตั้งค่าความดังแบบ percentage (0 - 100)
  Future<void> setVolumePercentage(int percentage) async {
    await setVolume(AudioConfig.percentageToVolume(percentage));
  }

  /// เปิด/ปิดเสียง
  Future<void> toggleMute() async {
    _isMuted = !_isMuted;

    final newVolume = _isMuted ? 0.0 : _volume;
    for (final player in _playerPool) {
      await player.setVolume(newVolume);
    }
  }

  /// ปิดเสียง
  Future<void> mute() async {
    _isMuted = true;

    for (final player in _playerPool) {
      await player.setVolume(0);
    }
  }

  /// เปิดเสียง
  Future<void> unmute() async {
    _isMuted = false;

    for (final player in _playerPool) {
      await player.setVolume(_volume);
    }
  }

  // ========================================
  // Helper Methods
  // ========================================

  /// หา player ที่พร้อมเล่น
  AudioPlayer? _getAvailablePlayer() {
    // หา player ที่หยุดอยู่
    for (final player in _playerPool) {
      if (player.state != PlayerState.playing) {
        return player;
      }
    }

    // ถ้าไม่มีว่าง ใช้ player แรก (จะตัดเสียงเดิมทิ้ง)
    return _playerPool.isNotEmpty ? _playerPool[0] : null;
  }

  /// หยุดเสียงทั้งหมด
  Future<void> stopAll() async {
    for (final player in _playerPool) {
      await player.stop();
    }
  }

  // ========================================
  // Cleanup
  // ========================================

  /// ทำความสะอาด - เรียกตอน app dispose
  Future<void> dispose() async {
    for (final player in _playerPool) {
      await player.stop();
      await player.dispose();
    }
    _playerPool.clear();
  }
}
