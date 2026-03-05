class StageProgress {
  final int stageNumber;
  final int stars; // 0-3 ดาว
  final int score;
  final bool isUnlocked;
  final bool isCompleted;

  StageProgress({
    required this.stageNumber,
    this.stars = 0,
    this.score = 0,
    this.isUnlocked = false,
    this.isCompleted = false,
  });

  // แปลงเป็น JSON สำหรับบันทึก
  Map<String, dynamic> toJson() {
    return {
      'stageNumber': stageNumber,
      'stars': stars,
      'score': score,
      'isUnlocked': isUnlocked,
      'isCompleted': isCompleted,
    };
  }

  // สร้างจาก JSON
  factory StageProgress.fromJson(Map<String, dynamic> json) {
    return StageProgress(
      stageNumber: json['stageNumber'] as int,
      stars: json['stars'] as int? ?? 0,
      score: json['score'] as int? ?? 0,
      isUnlocked: json['isUnlocked'] as bool? ?? false,
      isCompleted: json['isCompleted'] as bool? ?? false,
    );
  }

  // คัดลอกพร้อมแก้ไขค่า
  StageProgress copyWith({
    int? stageNumber,
    int? stars,
    int? score,
    bool? isUnlocked,
    bool? isCompleted,
  }) {
    return StageProgress(
      stageNumber: stageNumber ?? this.stageNumber,
      stars: stars ?? this.stars,
      score: score ?? this.score,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
