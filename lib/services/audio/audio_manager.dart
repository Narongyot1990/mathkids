import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'background_music_service.dart';
import 'sound_effects_service.dart';
import 'audio_config.dart';
import 'audio_context.dart';

/// Audio Manager
/// ตัวจัดการเสียงหลัก - ใช้ระบบ State-based แทน Event-based
/// เล่นเพลงตาม AudioContext (สถานะปัจจุบัน) ไม่ใช่ตามเหตุการณ์
class AudioManager {
  // Singleton pattern
  static final AudioManager _instance = AudioManager._internal();
  factory AudioManager() => _instance;
  AudioManager._internal();

  // Services
  final BackgroundMusicService _musicService = BackgroundMusicService();
  final SoundEffectsService _sfxService = SoundEffectsService();

  // State
  bool _isInitialized = false;
  double _masterVolume = AudioConfig.defaultMasterVolume;
  bool _isMasterMuted = false;
  AudioContext? _currentContext; // เริ่มต้นเป็น null เพื่อให้เพลงเล่นได้ตอนแรก

  // SharedPreferences keys
  static const String _keyMusicVolume = 'audio_music_volume';
  static const String _keySfxVolume = 'audio_sfx_volume';
  static const String _keyMasterVolume = 'audio_master_volume';
  static const String _keyMusicMuted = 'audio_music_muted';
  static const String _keySfxMuted = 'audio_sfx_muted';
  static const String _keyMasterMuted = 'audio_master_muted';

  // ========================================
  // Getters
  // ========================================
  bool get isInitialized => _isInitialized;
  double get masterVolume => _masterVolume;
  bool get isMasterMuted => _isMasterMuted;
  AudioContext? get currentContext => _currentContext;

  // Music getters
  BackgroundMusicService get music => _musicService;
  bool get isMusicPlaying => _musicService.isPlaying;
  double get musicVolume => _musicService.volume;
  bool get isMusicMuted => _musicService.isMuted;

  // SFX getters
  SoundEffectsService get sfx => _sfxService;
  double get sfxVolume => _sfxService.volume;
  bool get isSfxMuted => _sfxService.isMuted;

  // ========================================
  // Initialization
  // ========================================

  /// เริ่มต้น AudioManager - เรียกครั้งเดียวตอน app start
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // เริ่มต้น services
      await _musicService.initialize();
      await _sfxService.initialize();

      // โหลด settings ที่บันทึกไว้
      await _loadSettings();

      _isInitialized = true;

      debugPrint('✅ AudioManager initialized successfully');
    } catch (e) {
      debugPrint('❌ Error initializing AudioManager: $e');
    }
  }

  // ========================================
  // Master Volume Control
  // ========================================

  /// ตั้งค่า master volume (ส่งผลกับเสียงทั้งหมด)
  Future<void> setMasterVolume(double volume) async {
    _masterVolume = volume.clamp(0.0, 1.0);

    // อัพเดท volume ของ music และ sfx
    final musicVol = _musicService.volume * _masterVolume;
    final sfxVol = _sfxService.volume * _masterVolume;

    if (!_isMasterMuted) {
      await _musicService.setVolume(musicVol);
      await _sfxService.setVolume(sfxVol);
    }

    await _saveSettings();
  }

  /// ตั้งค่า master volume แบบ percentage
  Future<void> setMasterVolumePercentage(int percentage) async {
    await setMasterVolume(AudioConfig.percentageToVolume(percentage));
  }

  /// เปิด/ปิดเสียงทั้งหมด
  Future<void> toggleMasterMute() async {
    _isMasterMuted = !_isMasterMuted;

    if (_isMasterMuted) {
      await _musicService.mute();
      await _sfxService.mute();
    } else {
      await _musicService.unmute();
      await _sfxService.unmute();
    }

    await _saveSettings();
  }

  /// ปิดเสียงทั้งหมด
  Future<void> muteAll() async {
    _isMasterMuted = true;
    await _musicService.mute();
    await _sfxService.mute();
    await _saveSettings();
  }

  /// เปิดเสียงทั้งหมด
  Future<void> unmuteAll() async {
    _isMasterMuted = false;
    await _musicService.unmute();
    await _sfxService.unmute();
    await _saveSettings();
  }

  // ========================================
  // Audio Context Management (ระบบใหม่!)
  // ========================================

  /// ตั้งค่า AudioContext - เพลงจะเปลี่ยนตาม context อัตโนมัติ
  Future<void> setContext(AudioContext context) async {
    debugPrint('🎮 [MANAGER] setContext() called: $context');
    debugPrint('🎮 [MANAGER] Current context: $_currentContext');

    if (_currentContext == context) {
      debugPrint('🎮 [MANAGER] Same context, skipping');
      return;
    }

    _currentContext = context;

    // เล่นเพลงตาม context
    final musicPath = context.musicPath;
    debugPrint('🎮 [MANAGER] Will play music: $musicPath');
    await _musicService.play(musicPath);
    debugPrint('🎮 [MANAGER] ✅ setContext completed');
  }

  // ========================================
  // Quick Access Methods (รักษาไว้เพื่อ backward compatibility)
  // ========================================

  // Music shortcuts - ใช้ setContext() แทนจะดีกว่า!
  Future<void> playMenuMusic() => setContext(AudioContext.mainMenu);
  Future<void> playGameMusic() => setContext(AudioContext.inGame);
  Future<void> playVictoryMusic() => setContext(AudioContext.gameVictory);
  Future<void> stopMusic() => _musicService.stop();
  Future<void> pauseMusic() => _musicService.pause();
  Future<void> resumeMusic() => _musicService.resume();

  // SFX shortcuts - Game feedback
  Future<void> playCorrectSound() => _sfxService.playCorrect();
  Future<void> playWrongSound() => _sfxService.playWrong();
  Future<void> playPerfectSound() => _sfxService.playPerfect();

  // SFX shortcuts - UI
  Future<void> playButtonClick() => _sfxService.playButtonClick();
  Future<void> playButtonHover() => _sfxService.playButtonHover();
  Future<void> playPageTransition() => _sfxService.playPageTransition();

  // SFX shortcuts - Rewards
  Future<void> playStarCollect() => _sfxService.playStarCollect();
  Future<void> playLevelUp() => _sfxService.playLevelUp();
  Future<void> playAchievement() => _sfxService.playAchievement();
  Future<void> playConfetti() => _sfxService.playConfetti();

  // SFX shortcuts - Game state
  Future<void> playGameStart() => _sfxService.playGameStart();
  Future<void> playGameOver() => _sfxService.playGameOver();
  Future<void> playCountdown() => _sfxService.playCountdown();
  Future<void> playTimeWarning() => _sfxService.playTimeWarning();

  // ========================================
  // Settings Persistence
  // ========================================

  /// โหลด settings จาก SharedPreferences
  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Load volumes
      final musicVol = prefs.getDouble(_keyMusicVolume) ?? AudioConfig.defaultMusicVolume;
      final sfxVol = prefs.getDouble(_keySfxVolume) ?? AudioConfig.defaultSfxVolume;
      _masterVolume = prefs.getDouble(_keyMasterVolume) ?? AudioConfig.defaultMasterVolume;

      // Load mute states
      final musicMuted = prefs.getBool(_keyMusicMuted) ?? false;
      final sfxMuted = prefs.getBool(_keySfxMuted) ?? false;
      _isMasterMuted = prefs.getBool(_keyMasterMuted) ?? false;

      // Apply settings
      await _musicService.setVolume(musicVol);
      await _sfxService.setVolume(sfxVol);

      if (musicMuted) await _musicService.mute();
      if (sfxMuted) await _sfxService.mute();
      if (_isMasterMuted) {
        await _musicService.mute();
        await _sfxService.mute();
      }
    } catch (e) {
      debugPrint('Error loading audio settings: $e');
    }
  }

  /// บันทึก settings ไปยัง SharedPreferences
  Future<void> _saveSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Save volumes
      await prefs.setDouble(_keyMusicVolume, _musicService.volume);
      await prefs.setDouble(_keySfxVolume, _sfxService.volume);
      await prefs.setDouble(_keyMasterVolume, _masterVolume);

      // Save mute states
      await prefs.setBool(_keyMusicMuted, _musicService.isMuted);
      await prefs.setBool(_keySfxMuted, _sfxService.isMuted);
      await prefs.setBool(_keyMasterMuted, _isMasterMuted);
    } catch (e) {
      debugPrint('Error saving audio settings: $e');
    }
  }

  /// บันทึก settings แบบ manual (เรียกหลังแก้ settings)
  Future<void> saveSettings() async {
    await _saveSettings();
  }

  /// รีเซ็ต settings กลับเป็นค่า default
  Future<void> resetSettings() async {
    await _musicService.setVolume(AudioConfig.defaultMusicVolume);
    await _sfxService.setVolume(AudioConfig.defaultSfxVolume);
    _masterVolume = AudioConfig.defaultMasterVolume;

    await _musicService.unmute();
    await _sfxService.unmute();
    _isMasterMuted = false;

    await _saveSettings();
  }

  // ========================================
  // Cleanup
  // ========================================

  /// ทำความสะอาด - เรียกตอน app dispose
  Future<void> dispose() async {
    await _musicService.dispose();
    await _sfxService.dispose();
    _isInitialized = false;
  }
}

// ========================================
// Global Instance (สะดวกในการเรียกใช้)
// ========================================

/// Global audio manager instance
/// เรียกใช้ได้ทุกที่: audioManager.playCorrectSound()
final audioManager = AudioManager();
