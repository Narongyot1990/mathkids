import 'package:flutter/foundation.dart';
import 'package:audioplayers/audioplayers.dart';
import 'audio_config.dart';

/// Background Music Service
/// จัดการเพลงพื้นหลัง - loop, fade in/out, crossfade
/// เหมือน SoundService ใน Roblox แต่เฉพาะ Music
class BackgroundMusicService {
  // Singleton pattern - มี instance เดียวในแอพ
  static final BackgroundMusicService _instance = BackgroundMusicService._internal();
  factory BackgroundMusicService() => _instance;
  BackgroundMusicService._internal();

  // Audio player สำหรับเพลงพื้นหลัง
  final AudioPlayer _musicPlayer = AudioPlayer();

  // State
  String? _currentMusicPath;
  bool _isPlaying = false;
  double _volume = AudioConfig.defaultMusicVolume;
  bool _isMuted = false;

  // ========================================
  // Getters
  // ========================================
  bool get isPlaying => _isPlaying;
  String? get currentMusic => _currentMusicPath;
  double get volume => _volume;
  bool get isMuted => _isMuted;

  // ========================================
  // Initialization
  // ========================================

  /// เริ่มต้น service - ตั้งค่า player mode
  Future<void> initialize() async {
    // Set player mode เป็น mediaPlayer สำหรับ music (ให้คุณภาพเสียงดีกว่า lowLatency)
    await _musicPlayer.setPlayerMode(PlayerMode.mediaPlayer);

    // ฟังสถานะ player
    _musicPlayer.onPlayerStateChanged.listen((state) {
      _isPlaying = (state == PlayerState.playing);
    });
  }

  // ========================================
  // Play Music
  // ========================================

  /// เล่นเพลง - ถ้าเพลงเดิมอยู่แล้วจะไม่เล่นซ้ำ
  Future<void> play(String musicPath, {bool fadeIn = true}) async {
    debugPrint('🎵 [MUSIC] play() called with: $musicPath');
    debugPrint('🎵 [MUSIC] Current music: $_currentMusicPath, isPlaying: $_isPlaying');

    // ถ้าเป็นเพลงเดียวกันที่กำลังเล่นอยู่ ไม่ต้องทำอะไร
    if (_currentMusicPath == musicPath && _isPlaying) {
      debugPrint('🎵 [MUSIC] Same music already playing, skipping');
      return;
    }

    // หยุดเพลงเดิม
    debugPrint('🎵 [MUSIC] Stopping old music...');
    await stop(fadeOut: false);

    try {
      debugPrint('🎵 [MUSIC] Setting loop mode...');
      // ตั้งค่า loop mode ก่อนเล่น (สำคัญ!)
      await _musicPlayer.setReleaseMode(ReleaseMode.loop);

      debugPrint('🎵 [MUSIC] Loading and playing: $musicPath');
      // โหลดและเล่นเพลงใหม่
      await _musicPlayer.play(AssetSource(musicPath));

      _currentMusicPath = musicPath;
      debugPrint('🎵 [MUSIC] Music started, player state: ${_musicPlayer.state}');

      // ตั้ง volume ทันที (ไม่ fade in เพราะทำให้เพลงไม่เล่น)
      final vol = _isMuted ? 0.0 : _volume;
      debugPrint('🎵 [MUSIC] Setting volume to: $vol');
      await _musicPlayer.setVolume(vol);

      debugPrint('🎵 [MUSIC] ✅ Play completed successfully');
    } catch (e) {
      debugPrint('❌ [MUSIC] Error playing music: $e');
      debugPrint('❌ [MUSIC] Stack trace: ${StackTrace.current}');
    }
  }

  /// เล่นเพลงเมนู
  Future<void> playMenuMusic({bool fadeIn = true}) async {
    await play(AudioConfig.bgmMenu, fadeIn: fadeIn);
  }

  /// เล่นเพลงเกม
  Future<void> playGameMusic({bool fadeIn = true}) async {
    await play(AudioConfig.bgmGame, fadeIn: fadeIn);
  }

  /// เล่นเพลงชนะ
  Future<void> playVictoryMusic({bool fadeIn = true}) async {
    await play(AudioConfig.bgmVictory, fadeIn: fadeIn);
  }

  // ========================================
  // Stop Music
  // ========================================

  /// หยุดเพลง
  Future<void> stop({bool fadeOut = true}) async {
    if (!_isPlaying) return;

    if (fadeOut) {
      await _fadeOut();
    }

    await _musicPlayer.stop();
    _currentMusicPath = null;
  }

  /// พักเพลง (ไม่ใช่หยุด - สามารถ resume ได้)
  Future<void> pause({bool fadeOut = true}) async {
    if (!_isPlaying) return;

    if (fadeOut) {
      await _fadeOut();
    }

    await _musicPlayer.pause();
  }

  /// เล่นต่อจากที่พัก
  Future<void> resume({bool fadeIn = true}) async {
    await _musicPlayer.resume();

    if (fadeIn) {
      await _fadeIn();
    }
  }

  // ========================================
  // Volume Control
  // ========================================

  /// ตั้งค่าความดัง (0.0 - 1.0)
  Future<void> setVolume(double volume) async {
    _volume = volume.clamp(0.0, 1.0);

    if (!_isMuted) {
      await _musicPlayer.setVolume(_volume);
    }
  }

  /// ตั้งค่าความดังแบบ percentage (0 - 100)
  Future<void> setVolumePercentage(int percentage) async {
    await setVolume(AudioConfig.percentageToVolume(percentage));
  }

  /// เปิด/ปิดเสียง
  Future<void> toggleMute() async {
    _isMuted = !_isMuted;
    await _musicPlayer.setVolume(_isMuted ? 0 : _volume);
  }

  /// ปิดเสียง
  Future<void> mute() async {
    _isMuted = true;
    await _musicPlayer.setVolume(0);
  }

  /// เปิดเสียง
  Future<void> unmute() async {
    _isMuted = false;
    await _musicPlayer.setVolume(_volume);
  }

  // ========================================
  // Fade Effects
  // ========================================

  /// Fade in - เพิ่มเสียงค่อยๆ
  Future<void> _fadeIn() async {
    const steps = 20; // จำนวนขั้นตอนการ fade
    final duration = AudioConfig.musicFadeInDuration;
    final stepDuration = duration ~/ steps;
    final targetVolume = _isMuted ? 0 : _volume;
    final volumeStep = targetVolume / steps;

    for (int i = 0; i <= steps; i++) {
      await _musicPlayer.setVolume(volumeStep * i);
      await Future.delayed(Duration(milliseconds: stepDuration));
    }
  }

  /// Fade out - ลดเสียงค่อยๆ
  Future<void> _fadeOut() async {
    const steps = 20;
    final duration = AudioConfig.musicFadeOutDuration;
    final stepDuration = duration ~/ steps;
    final currentVol = _isMuted ? 0 : _volume;
    final volumeStep = currentVol / steps;

    for (int i = steps; i >= 0; i--) {
      await _musicPlayer.setVolume(volumeStep * i);
      await Future.delayed(Duration(milliseconds: stepDuration));
    }
  }

  /// Crossfade - เปลี่ยนเพลงแบบ fade out เพลงเก่า + fade in เพลงใหม่
  Future<void> crossfadeTo(String newMusicPath) async {
    if (_currentMusicPath == newMusicPath) return;

    // Fade out เพลงเดิม
    if (_isPlaying) {
      await _fadeOut();
      await _musicPlayer.stop();
    }

    // เล่นและ fade in เพลงใหม่
    await play(newMusicPath, fadeIn: true);
  }

  // ========================================
  // Cleanup
  // ========================================

  /// ทำความสะอาด - เรียกตอน app dispose
  Future<void> dispose() async {
    await _musicPlayer.stop();
    await _musicPlayer.dispose();
  }
}
