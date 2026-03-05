/// Audio Configuration
/// ไฟล์กำหนดค่าเสียงทั้งหมด - จัดการ path และ settings ในที่เดียว
/// เหมือน Configuration Module ใน Roblox
class AudioConfig {
  // ========================================
  // Background Music (BGM)
  // ========================================
  static const String bgmMenu = 'audio/music/menu_theme.mp3';
  static const String bgmGame = 'audio/music/game_theme.mp3';
  static const String bgmVictory = 'audio/music/victory_theme.mp3';

  // ========================================
  // Sound Effects (SFX)
  // ========================================

  // Game Feedback Sounds
  static const String sfxCorrect = 'audio/sfx/correct.wav';
  static const String sfxWrong = 'audio/sfx/wrong.wav';
  static const String sfxPerfect = 'audio/sfx/perfect.wav';

  // UI Sounds
  static const String sfxButtonClick = 'audio/sfx/button_click.wav';
  static const String sfxButtonHover = 'audio/sfx/button_hover.wav';
  static const String sfxPageTransition = 'audio/sfx/page_transition.wav';

  // Reward Sounds
  static const String sfxStarCollect = 'audio/sfx/star_collect.wav';
  static const String sfxLevelUp = 'audio/sfx/level_up.wav';
  static const String sfxAchievement = 'audio/sfx/achievement.wav';
  static const String sfxConfetti = 'audio/sfx/confetti.wav';

  // Game State Sounds
  static const String sfxGameStart = 'audio/sfx/game_start.wav';
  static const String sfxGameOver = 'audio/sfx/game_over.wav';
  static const String sfxCountdown = 'audio/sfx/countdown.wav';
  static const String sfxTimeWarning = 'audio/sfx/time_warning.wav';

  // ========================================
  // Volume Settings (0.0 - 1.0)
  // ========================================
  static const double defaultMusicVolume = 0.7;
  static const double defaultSfxVolume = 0.8;
  static const double defaultMasterVolume = 1.0;

  // ========================================
  // Fade Durations (milliseconds)
  // ========================================
  static const int musicFadeInDuration = 1000;
  static const int musicFadeOutDuration = 500;
  static const int musicCrossfadeDuration = 1500;

  // ========================================
  // Helper Methods
  // ========================================

  /// ตรวจสอบว่าเป็น music file หรือไม่
  static bool isMusicFile(String path) {
    return path.contains('audio/music/');
  }

  /// ตรวจสอบว่าเป็น sfx file หรือไม่
  static bool isSfxFile(String path) {
    return path.contains('audio/sfx/');
  }

  /// แปลง volume จาก percentage (0-100) เป็น 0.0-1.0
  static double percentageToVolume(int percentage) {
    return (percentage.clamp(0, 100) / 100.0);
  }

  /// แปลง volume จาก 0.0-1.0 เป็น percentage (0-100)
  static int volumeToPercentage(double volume) {
    return (volume.clamp(0.0, 1.0) * 100).round();
  }
}
