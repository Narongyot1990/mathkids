# การแก้ไขระบบคะแนน - Scoring System Fix

## 🔴 ปัญหาที่พบ

### ปัญหา 1: ไม่ได้เก็บ Best Score ⭐ **แก้แล้ว**
**อาการ**:
- เล่นด่าน 1 ได้ 3 ดาว 100 คะแนน
- เล่นใหม่ได้ 2 ดาว 80 คะแนน
- ❌ ระบบบันทึกเหลือ 2 ดาว 80 คะแนน (ผิด!)
- ✅ ควรเก็บ 3 ดาว 100 คะแนน (Best Score)

**สาเหตุ**: [progress_service.dart](lib/services/progress_service.dart) เขียนทับคะแนนทุกครั้ง ไม่เช็คว่าคะแนนเก่าดีกว่า

### ปัญหา 2: หน้าเลือกด่านไม่อัพเดททันที ⭐ **แก้แล้ว**
**อาการ**:
- เล่นด่านจบ ได้ 3 ดาว
- กลับมาหน้าเลือกด่าน ยังแสดง 0 ดาว
- ต้องกลับไปหน้าแรกแล้วเข้าใหม่ถึงจะแสดง 3 ดาว

**สาเหตุ**: [stage_select_screen.dart](lib/screens/stage_select/stage_select_screen.dart) ไม่ reload ข้อมูลหลังกลับมาจากเกม

---

## ✅ การแก้ไข

### 1. แก้ Best Score Logic

**ไฟล์**: [progress_service.dart:14-63](lib/services/progress_service.dart:14-63)

**เปลี่ยนจาก**:
```dart
Future<void> saveStageProgress(...) async {
  final progress = StageProgress(
    stageNumber: stageNumber,
    stars: stars,           // ❌ เขียนทับเลย
    score: score,           // ❌ เขียนทับเลย
    isUnlocked: true,
    isCompleted: true,
  );

  await prefs.setString(key, jsonEncode(progress.toJson()));
}
```

**เป็น**:
```dart
Future<void> saveStageProgress(...) async {
  // ดึงข้อมูลเก่า (ถ้ามี)
  final existingData = prefs.getString(key);
  int bestStars = stars;
  int bestScore = score;

  if (existingData != null) {
    try {
      final oldProgress = StageProgress.fromJson(
        jsonDecode(existingData) as Map<String, dynamic>,
      );

      // ✅ เก็บ Best Score - ดาวมากกว่า หรือดาวเท่ากันแต่คะแนนมากกว่า
      if (oldProgress.stars > stars) {
        bestStars = oldProgress.stars;
        bestScore = oldProgress.score;
      } else if (oldProgress.stars == stars && oldProgress.score > score) {
        bestScore = oldProgress.score;
      }
    } catch (e) {
      // ถ้า parse ไม่ได้ ให้ใช้คะแนนใหม่
    }
  }

  final progress = StageProgress(
    stageNumber: stageNumber,
    stars: bestStars,        // ✅ เก็บดาวที่ดีที่สุด
    score: bestScore,        // ✅ เก็บคะแนนที่ดีที่สุด
    isUnlocked: true,
    isCompleted: true,
  );

  await prefs.setString(key, jsonEncode(progress.toJson()));
}
```

**Logic การเลือก Best Score**:
1. ถ้า**ดาวเก่ามากกว่า** → เก็บดาว + คะแนนเก่า
2. ถ้า**ดาวเท่ากัน แต่คะแนนเก่ามากกว่า** → เก็บคะแนนเก่า
3. ถ้า**ดาวใหม่มากกว่า หรือคะแนนใหม่มากกว่า** → เก็บใหม่

**ตัวอย่าง**:
| เก่า | ใหม่ | ผลลัพธ์ | เหตุผล |
|------|------|---------|--------|
| 3⭐ 100 | 2⭐ 80 | 3⭐ 100 | ดาวเก่ามากกว่า |
| 2⭐ 70 | 3⭐ 90 | 3⭐ 90 | ดาวใหม่มากกว่า |
| 3⭐ 100 | 3⭐ 90 | 3⭐ 100 | ดาวเท่า แต่คะแนนเก่าสูงกว่า |
| 3⭐ 90 | 3⭐ 100 | 3⭐ 100 | ดาวเท่า คะแนนใหม่สูงกว่า |

---

### 2. แก้ Reload หลังกลับมา

**ไฟล์**: [stage_select_screen.dart:230-247](lib/screens/stage_select/stage_select_screen.dart:230-247)

**เปลี่ยนจาก**:
```dart
void _startStage(int stageNumber) async {
  final result = await Navigator.push(...);

  // ✅ โหลดเฉพาะเมื่อ result == true
  if (result == true && mounted) {
    _loadProgress();
  }
}
```

**เป็น**:
```dart
void _startStage(int stageNumber) async {
  await Navigator.push(...);

  // ✅ โหลดทุกครั้งที่กลับมา (ไม่ว่า result จะเป็นอะไร)
  if (mounted) {
    _loadProgress();
  }
}
```

**เหตุผล**:
- GameScreen บางครั้ง pop โดยไม่ส่ง `true` (เช่น กด back button)
- ปลอดภัยกว่าให้ reload ทุกครั้ง
- Performance impact น้อยมาก (แค่ read SharedPreferences)

---

## 🎯 ผลลัพธ์

### ก่อนแก้:
- ❌ เล่นด่านซ้ำ → คะแนนถูกเขียนทับ
- ❌ กลับมาหน้าเลือกด่าน → คะแนนไม่อัพเดท

### หลังแก้:
- ✅ เล่นด่านซ้ำ → **เก็บคะแนนสูงสุด**
- ✅ กลับมาหน้าเลือกด่าน → **แสดงคะแนนทันที**

---

## 🧪 วิธีทดสอบ

### ทดสอบ Best Score:
1. เล่นด่าน 1 → ตอบถูก 10/10 → ได้ 3⭐ 100 คะแนน
2. เล่นด่าน 1 อีกครั้ง → ตอบถูก 7/10 → ได้ 2⭐ 70 คะแนน
3. ✅ ตรวจสอบ: ต้องแสดง **3⭐ 100 คะแนน** (Best Score)

### ทดสอบ Reload:
1. เล่นด่าน 1 จบเกม → ได้ 3⭐
2. กลับมาหน้าเลือกด่าน
3. ✅ ตรวจสอบ: ต้องแสดง **3⭐ ทันที** (ไม่ต้องกลับหน้าแรก)

---

## 📊 ระบบคะแนนทั้งหมด

### การคำนวณดาว
**ตำแหน่ง**: [game_provider.dart:105-111](lib/providers/game_provider.dart:105-111)

```dart
int calculateStars() {
  final percentage = (_score / (_totalQuestions * 10)) * 100;
  if (percentage >= 90) return 3;  // ทำถูก 9-10 ข้อ → 3⭐
  if (percentage >= 70) return 2;  // ทำถูก 7-8 ข้อ → 2⭐
  if (percentage >= 50) return 1;  // ทำถูก 5-6 ข้อ → 1⭐
  return 0;                         // ทำถูกน้อยกว่า 5 ข้อ → 0⭐
}
```

### การให้คะแนน
- ตอบถูก 1 ข้อ = **+10 คะแนน**
- ตอบผิด = **+0 คะแนน**
- คะแนนเต็ม (10 ข้อ) = **100 คะแนน**

### ตัวอย่างคะแนน
| ข้อถูก | คะแนน | % | ดาว |
|--------|-------|---|-----|
| 10/10 | 100 | 100% | 3⭐ |
| 9/10 | 90 | 90% | 3⭐ |
| 8/10 | 80 | 80% | 2⭐ |
| 7/10 | 70 | 70% | 2⭐ |
| 6/10 | 60 | 60% | 1⭐ |
| 5/10 | 50 | 50% | 1⭐ |
| 4/10 | 40 | 40% | 0⭐ |

---

## ✅ สรุป

| ปัญหา | สถานะ | ไฟล์ที่แก้ |
|-------|-------|-----------|
| Best Score ไม่ถูกเก็บ | ✅ แก้แล้ว | progress_service.dart |
| หน้าเลือกด่านไม่อัพเดท | ✅ แก้แล้ว | stage_select_screen.dart |
| Flutter analyze | ✅ ผ่าน | No errors |

**พร้อมใช้งานแล้วครับ!** 🎉
