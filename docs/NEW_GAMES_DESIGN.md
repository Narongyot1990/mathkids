# MathKids Adventure - เกมใหม่ 5 เกม

เอกสารนี้อธิบายแนวทางการออกแบบเกมใหม่ทั้ง 5 เกมสำหรับ MathKids Adventure

---

## ภาพรวม

- **จำนวนเกม:** 5 เกม
- **Target:** เด็กอายุ 3-6 ปี
- **แพลตฟอร์ม:** Flutter (Mobile/Tablet)
- **ภาษา:** Thai

---

## เกมที่ 1: นับเลข (Counting)

### แนวคิด
แสดงกลุ่มของไอเทมต่างๆ ให้เด็กนับจำนวน

### UI/UX Design
```
┌─────────────────────────────┐
│         🔢 นับเลข           │
├─────────────────────────────┤
│                             │
│     🍎 🍎 🍎 🍎 🍎 🍎       │
│     🍎 🍎 🍎               │
│                             │
│     นับดูซิ มีกี่ผลไม้?    │
│                             │
├─────────────────────────────┤
│  [3]  [5]  [7]  [9]        │
└─────────────────────────────┘
```

### รายละเอียด
- **ไอเทม:** ผลไม้, สัตว์, ของเล่น, ยานพาหนะ (สุ่มจาก emoji)
- **จำนวน:** 1-15 ชิ้น (แบ่งตามระดับ)
- **ปุ่มคำตอบ:** 4 ตัวเลือก
- **Feedback:**
  - ถูก: เสียงเฉลิมฉลอง + ดาว
  - ผิด: เสียงให้กำลังใจ + แสดงคำตอบที่ถูก

### ระดับความยาก
- Level 1-5: นับ 1-5
- Level 6-10: นับ 6-10
- Level 11-15: นับ 11-15

---

## เกมที่ 2: บวกเลข (Addition)

### แนวคิด
แสดงการรวมกลุ่มสองกลุ่มเข้าด้วยกัน ให้เห็นภาพชัดเจน

### UI/UX Design
```
┌─────────────────────────────┐
│         ➕ บวกเลข           │
├─────────────────────────────┤
│                             │
│  🍎🍎🍎    +    🍎🍎       │
│   (3)          (2)          │
│                             │
│        =      [?]           │
│                             │
│      3 + 2 = ?             │
│                             │
├─────────────────────────────┤
│  [3]  [4]  [5]  [6]        │
└─────────────────────────────┘
```

### รายละเอียด
- **รูปแบบ:** แสดง 2 กลุ่ม + เครื่องหมาย + กล่องคำตอบ
- **ไอเทม:** ใช้ภาพเดียวกันในทั้งสองกลุ่ม (เช่น 🍎 + 🍎)
- **Animation:** 
  - กลุ่มที่ 1 ปรากฏก่อน (animate in)
  - กลุ่มที่ 2 ปรากฏตาม
  - คำตอบแสดงตอนตอบ
- **จำนวน:** operand1 + operand2 = 2-15

### ระดับความยาก
- Level 1-5: 1+1 ถึง 3+3
- Level 6-10: 2+2 ถึง 5+3
- Level 11-15: 3+4 ถึง 8+7

### ไฟล์ที่ต้องสร้าง
- `lib/screens/game/widgets/addition_game_widget.dart`
- `lib/data/question_bank/addition_questions.dart`

---

## เกมที่ 3: ลบเลข (Subtraction)

### แนวคิด
แสดงกลุ่มไอเทม แล้วขีดคร่อม/ลบออกบางส่วน ให้เห็นว่าเหลือเท่าไหร่

### UI/UX Design
```
┌─────────────────────────────┐
│         ➖ ลบเลข            │
├─────────────────────────────┤
│                             │
│  🍎🍎🍎🍎🍎 🍎🍎           │
│  ~~🍎🍎~~   (ขีดออก 2)      │
│                             │
│        =      [?]           │
│                             │
│      5 - 2 = ?             │
│                             │
├─────────────────────────────┤
│  [2]  [3]  [4]  [5]        │
└─────────────────────────────┘
```

### รายละเอียด
- **รูปแบบ:** แสดงกลุ่มเต็ม → ขีดคร่อมส่วนที่ลบออก → เหลือเท่าไหร่
- **Animation:** 
  - แสดงกลุ่มเต็ม
  - ขีดคร่อม (cross out) ตัวที่ถูกลบ (ถ้าตอบผิด)
  - ซ่อนตัวที่ถูกลบ (ถ้าตอบถูก)
- **จำนวน:** operand1 - operand2 = 1-10

### ระดับความยาก
- Level 1-5: 2-1, 3-1, 3-2, 4-1 ถึง 4-2
- Level 6-10: 5-1 ถึง 5-4
- Level 11-15: 6-1 ถึง 10-5

### ไฟล์ที่ต้องสร้าง
- `lib/screens/game/widgets/subtraction_game_widget.dart`
- `lib/data/question_bank/subtraction_questions.dart`

---

## เกมที่ 4: เปรียบเทียบ (Comparison)

### แนวคิด
แสดงสองกลุ่ม ให้เปรียบเทียบว่ากลุ่มไหนมากกว่า/น้อยกว่า/เท่ากัน

### UI/UX Design
```
┌─────────────────────────────┐
│       ⚖️ เปรียบเทียบ       │
├─────────────────────────────┤
│                             │
│  🍎🍎🍎      vs     🍎🍎    │
│   (3)               (2)     │
│                             │
│       [?] กับ [?]          │
│                             │
├─────────────────────────────┤
│  [<]  [=]  [>]             │
└─────────────────────────────┘
```

### รายละเอียด
- **รูปแบบ:** แสดงสองกลุ่มเคียงข้างกัน
- **คำตอบ:** 3 ตัวเลือก (<, =, >)
- **ไอเทม:** ผลไม้ต่างชนิดกันในแต่ละข้อ
- **Animation:** เลือกแล้วแสดงเครื่องหมาย

### ระดับความยาก
- Level 1-5: เปรียบเทียบ 1-5
- Level 6-10: เปรียบเทียบ 3-8
- Level 11-15: เปรียบเทียบ 5-10

### ไฟล์ที่ต้องสร้าง
- `lib/screens/game/widgets/comparison_game_widget.dart`
- `lib/data/question_bank/comparison_questions.dart`

---

## เกมที่ 5: หาลำดับ (Sequence/Pattern)

### แนวคิด
แสดงตัวเลขหรือรูปที่เรียงตามรูปแบบ ให้หาตัวถัดไป

### UI/UX Design
```
┌─────────────────────────────┐
│       🔄 หาลำดับ           │
├─────────────────────────────┤
│                             │
│  [1] → [2] → [3] → [?]     │
│                             │
│  ตัวถัดไปคืออะไร?          │
│                             │
├─────────────────────────────┤
│  [2]  [4]  [5]  [6]        │
└──────────────────────────────────┘
```

### รายละเอียด
- **รูปแบบ:** แสดงลำดับ 3-4 ตัว ตัวสุดท้ายเป็น ?
- **Pattern Types:**
  - +1 (1,2,3,4,...)
  - +2 (2,4,6,8,...)
  - +3 (3,6,9,12,...)
- **Animation:** ตัวเลขปรากฏทีละตัว

### ระดับความยาก
- Level 1-5: +1 pattern
- Level 6-10: +2 pattern  
- Level 11-15: +3 pattern

### ไฟล์ที่ต้องสร้าง
- `lib/screens/game/widgets/sequence_game_widget.dart`
- `lib/data/question_bank/sequence_questions.dart`

---

## โครงสร้างไฟล์ที่ต้องสร้าง

### Widgets (ใน lib/screens/game/widgets/)
- `counting_game_widget.dart`
- `addition_game_widget.dart`
- `subtraction_game_widget.dart`
- `comparison_game_widget.dart`
- `sequence_game_widget.dart`

### Question Banks (ใน lib/data/question_bank/)
- `counting_questions.dart` - คำถามนับเลข
- `addition_questions.dart` - คำถามบวก
- `subtraction_questions.dart` - คำถามลบ
- `comparison_questions.dart` - คำถามเปรียบเทียบ
- `sequence_questions.dart` - คำถามหาลำดับ

### Base Classes (มีอยู่แล้ว)
- `base_game_widget.dart` - Abstract class สำหรับทุกเกม
- `game_screen.dart` - Screen หลักที่เรียก game widget
- `question_config.dart` - โครงสร้างคำถาม
- `question_bank.dart` - Manager สำหรับดึงคำถาม

---

## ข้อกำหนดทางเทคนิค

### ต้องใช้
- Flutter SDK
- Provider (state management)
- Responsive design (mobile/tablet)

### Responsive Breakpoints
- Mobile: < 600px
- Tablet: 600px - 1024px
- Desktop: > 1024px

### Animations
- ใช้ `AnimatedBuilder` หรือ `TweenAnimationBuilder`
- Duration: 300-600ms
- Curves: `Curves.easeOut`, `Curves.elasticOut`

### Colors (ใช้จาก AppColors)
- Counting: เขียว/ฟ้า
- Addition: เขียว
- Subtraction: ส้ม/แดง
- Comparison: ม่วง/ชมพู
- Sequence: ฟ้า/น้ำเงิน

---

## ตัวอย่างโค้ดสำหรับ Question Bank

```dart
// lib/data/question_bank/counting_questions.dart
class CountingQuestions {
  static final List<QuestionTemplate> bank = [
    QuestionTemplate(
      level: 1,
      recommendedAge: 3,
      question: 'นับดูซิ มีกี่ผลไม้?',
      correctAnswer: 3,
      wrongAnswers: [2, 4, 5],
      data: QuestionData.counting(3),
    ),
    // ... more questions
  ];
  
  static QuestionTemplate getQuestion(int level) => bank[level - 1];
  static int get totalLevels => bank.length;
}
```

---

## หมายเหตุสำคัญ

1. **ทุกเกมต้อง extends `BaseGameWidget`**
2. **ใช้ `ResponsiveHelper` สำหรับขนาดต่างๆ**
3. **ใช้ emoji จาก `GameEmojis` class**
4. **คำถามทั้งหมดเก็บใน question bank (static data)**
5. **ไม่ generate ตอน runtime**
