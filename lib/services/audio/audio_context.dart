/// Audio Context
/// กำหนดสถานะของแอพเพื่อให้เล่นเพลงที่ถูกต้อง
enum AudioContext {
  mainMenu,     // หน้าเมนูหลัก
  levelSelect,  // หน้าเลือกด่าน
  inGame,       // กำลังเล่นเกม
  gameVictory,  // ชนะเกมแล้ว
}

/// Extension เพื่อแปลง AudioContext เป็น music path
extension AudioContextExtension on AudioContext {
  String get musicPath {
    switch (this) {
      case AudioContext.mainMenu:
      case AudioContext.levelSelect:
        return 'audio/music/menu_theme.mp3';
      case AudioContext.inGame:
        return 'audio/music/game_theme.mp3';
      case AudioContext.gameVictory:
        return 'audio/music/victory_theme.mp3';
    }
  }

  String get displayName {
    switch (this) {
      case AudioContext.mainMenu:
        return 'Main Menu';
      case AudioContext.levelSelect:
        return 'Level Select';
      case AudioContext.inGame:
        return 'In Game';
      case AudioContext.gameVictory:
        return 'Victory';
    }
  }
}
