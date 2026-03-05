/// Comparison Question Bank - คลังคำถามเกมเปรียบเทียบ (ยากตั้งแต่ต้น!)
///
/// โครงสร้าง: 5 stages × 10 questions = 50 คำถาม
/// Range: เลข 8-40 (ยากตั้งแต่ Stage 1!)
/// - Stage 1: เปรียบเทียบ 8-12
/// - Stage 2: เปรียบเทียบ 13-20
/// - Stage 3: เปรียบเทียบ 21-28
/// - Stage 4: เปรียบเทียบ 29-35
/// - Stage 5: เปรียบเทียบ 36-40 (โหดสุด!)
///
/// คำตอบ: 0 = น้อยกว่า (<), 1 = เท่ากับ (=), 2 = มากกว่า (>)
library;

import 'question_config.dart';

class ComparisonQuestions {
  ComparisonQuestions._();

  static const List<QuestionTemplate> bank = [
    // Stage 1: เปรียบเทียบ 8-12
    QuestionTemplate(level: 1, recommendedAge: 5, question: 'ข้างไหนมีมากกว่า?', questionShort: '8 vs 10',
      correctAnswer: 0, wrongAnswers: [1, 2], data: QuestionData(leftCount: 8, rightCount: 10, comparisonType: 'moreOrLess'),
      hint: 'นับทีละข้างแล้วเปรียบเทียบ', encouragement: 'เก่งมาก! 8 < 10 ถูกต้อง! 🎉'),
    QuestionTemplate(level: 1, recommendedAge: 5, question: 'ข้างไหนมีมากกว่า?', questionShort: '12 vs 9',
      correctAnswer: 2, wrongAnswers: [0, 1], data: QuestionData(leftCount: 12, rightCount: 9, comparisonType: 'moreOrLess'),
      hint: 'เปรียบเทียบทั้งสองข้าง', encouragement: 'ยอดเยี่ยม! 12 > 9 ถูกต้อง! ⭐'),
    QuestionTemplate(level: 1, recommendedAge: 5, question: 'ข้างไหนมีมากกว่า?', questionShort: '10 vs 10',
      correctAnswer: 1, wrongAnswers: [0, 2], data: QuestionData(leftCount: 10, rightCount: 10, comparisonType: 'moreOrLess'),
      hint: 'ดูให้ดี เท่ากันหรือเปล่า?', encouragement: 'เจ๋ง! 10 = 10 ถูกต้อง! 🎯'),
    QuestionTemplate(level: 1, recommendedAge: 5, question: 'ข้างไหนมีน้อยกว่า?', questionShort: '11 vs 9',
      correctAnswer: 2, wrongAnswers: [0, 1], data: QuestionData(leftCount: 11, rightCount: 9, comparisonType: 'less'),
      hint: 'หาข้างที่น้อยกว่า', encouragement: 'สุดยอด! ขวาน้อยกว่า! 👏'),
    QuestionTemplate(level: 1, recommendedAge: 5, question: 'ข้างไหนมีมากกว่า?', questionShort: '8 vs 12',
      correctAnswer: 0, wrongAnswers: [1, 2], data: QuestionData(leftCount: 8, rightCount: 12, comparisonType: 'moreOrLess'),
      hint: 'นับให้ครบทุกอัน', encouragement: 'เยี่ยม! 8 < 12 ถูกต้อง! 🌟'),
    QuestionTemplate(level: 1, recommendedAge: 5, question: 'เท่ากันไหม?', questionShort: '11 vs 11',
      correctAnswer: 1, wrongAnswers: [0, 2], data: QuestionData(leftCount: 11, rightCount: 11, comparisonType: 'equal'),
      hint: 'เช็คว่าเท่ากันหรือไม่', encouragement: 'ว้าว! 11 = 11 ถูกต้อง! 🎊'),
    QuestionTemplate(level: 1, recommendedAge: 5, question: 'ข้างไหนมีมากกว่า?', questionShort: '10 vs 8',
      correctAnswer: 2, wrongAnswers: [0, 1], data: QuestionData(leftCount: 10, rightCount: 8, comparisonType: 'moreOrLess'),
      hint: 'เปรียบเทียบให้ดี', encouragement: 'เก่ง! 10 > 8 ถูกต้อง! 🏆'),
    QuestionTemplate(level: 1, recommendedAge: 5, question: 'ข้างไหนมีน้อยกว่า?', questionShort: '12 vs 10',
      correctAnswer: 0, wrongAnswers: [1, 2], data: QuestionData(leftCount: 12, rightCount: 10, comparisonType: 'less'),
      hint: 'หาข้างที่น้อยกว่า', encouragement: 'ดีมาก! ขวาน้อยกว่า! 🎈'),
    QuestionTemplate(level: 1, recommendedAge: 5, question: 'ข้างไหนมีมากกว่า?', questionShort: '9 vs 11',
      correctAnswer: 0, wrongAnswers: [1, 2], data: QuestionData(leftCount: 9, rightCount: 11, comparisonType: 'moreOrLess'),
      hint: 'นับแล้วเทียบ', encouragement: 'เจ๋งมาก! 9 < 11 ถูกต้อง! 💫'),
    QuestionTemplate(level: 1, recommendedAge: 5, question: 'เท่ากันไหม?', questionShort: '12 vs 12',
      correctAnswer: 1, wrongAnswers: [0, 2], data: QuestionData(leftCount: 12, rightCount: 12, comparisonType: 'equal'),
      hint: 'ดูว่าเท่ากันหรือไม่', encouragement: 'สุดยอด! 12 = 12 ถูกต้อง! 🎯'),

    // Stage 2: เปรียบเทียบ 13-20
    QuestionTemplate(level: 2, recommendedAge: 6, question: 'ข้างไหนมีมากกว่า?', questionShort: '13 vs 17',
      correctAnswer: 0, wrongAnswers: [1, 2], data: QuestionData(leftCount: 13, rightCount: 17, comparisonType: 'moreOrLess'),
      hint: 'เปรียบเทียบทั้งสองข้าง', encouragement: 'เยี่ยม! 13 < 17 ถูกต้อง! 🎉'),
    QuestionTemplate(level: 2, recommendedAge: 6, question: 'ข้างไหนมีมากกว่า?', questionShort: '19 vs 14',
      correctAnswer: 2, wrongAnswers: [0, 1], data: QuestionData(leftCount: 19, rightCount: 14, comparisonType: 'moreOrLess'),
      hint: 'นับให้ครบ', encouragement: 'ยอดเยี่ยม! 19 > 14 ถูกต้อง! ⭐'),
    QuestionTemplate(level: 2, recommendedAge: 6, question: 'เท่ากันไหม?', questionShort: '15 vs 15',
      correctAnswer: 1, wrongAnswers: [0, 2], data: QuestionData(leftCount: 15, rightCount: 15, comparisonType: 'equal'),
      hint: 'เช็คว่าเท่ากันไหม', encouragement: 'เจ๋ง! 15 = 15 ถูกต้อง! 🎯'),
    QuestionTemplate(level: 2, recommendedAge: 6, question: 'ข้างไหนมีน้อยกว่า?', questionShort: '18 vs 13',
      correctAnswer: 0, wrongAnswers: [1, 2], data: QuestionData(leftCount: 18, rightCount: 13, comparisonType: 'less'),
      hint: 'หาข้างที่น้อยกว่า', encouragement: 'สุดยอด! ขวาน้อยกว่า! 👏'),
    QuestionTemplate(level: 2, recommendedAge: 6, question: 'ข้างไหนมีมากกว่า?', questionShort: '14 vs 19',
      correctAnswer: 0, wrongAnswers: [1, 2], data: QuestionData(leftCount: 14, rightCount: 19, comparisonType: 'moreOrLess'),
      hint: 'เปรียบเทียบให้ดี', encouragement: 'เก่ง! 14 < 19 ถูกต้อง! 🌟'),
    QuestionTemplate(level: 2, recommendedAge: 6, question: 'เท่ากันไหม?', questionShort: '20 vs 20',
      correctAnswer: 1, wrongAnswers: [0, 2], data: QuestionData(leftCount: 20, rightCount: 20, comparisonType: 'equal'),
      hint: 'ดูว่าเท่ากันไหม', encouragement: 'ว้าว! 20 = 20 ถูกต้อง! 🎊'),
    QuestionTemplate(level: 2, recommendedAge: 6, question: 'ข้างไหนมีมากกว่า?', questionShort: '17 vs 13',
      correctAnswer: 2, wrongAnswers: [0, 1], data: QuestionData(leftCount: 17, rightCount: 13, comparisonType: 'moreOrLess'),
      hint: 'นับแล้วเทียบ', encouragement: 'เยี่ยม! 17 > 13 ถูกต้อง! 🏆'),
    QuestionTemplate(level: 2, recommendedAge: 6, question: 'ข้างไหนมีน้อยกว่า?', questionShort: '20 vs 16',
      correctAnswer: 0, wrongAnswers: [1, 2], data: QuestionData(leftCount: 20, rightCount: 16, comparisonType: 'less'),
      hint: 'หาข้างที่น้อยกว่า', encouragement: 'ดีมาก! ขวาน้อยกว่า! 🎈'),
    QuestionTemplate(level: 2, recommendedAge: 6, question: 'ข้างไหนมีมากกว่า?', questionShort: '15 vs 18',
      correctAnswer: 0, wrongAnswers: [1, 2], data: QuestionData(leftCount: 15, rightCount: 18, comparisonType: 'moreOrLess'),
      hint: 'เปรียบเทียบทั้งสองข้าง', encouragement: 'เจ๋งมาก! 15 < 18 ถูกต้อง! 💫'),
    QuestionTemplate(level: 2, recommendedAge: 6, question: 'เท่ากันไหม?', questionShort: '16 vs 16',
      correctAnswer: 1, wrongAnswers: [0, 2], data: QuestionData(leftCount: 16, rightCount: 16, comparisonType: 'equal'),
      hint: 'เช็คความเท่ากัน', encouragement: 'สุดยอด! 16 = 16 ถูกต้อง! 🎯'),

    // Stage 3: เปรียบเทียบ 21-28
    QuestionTemplate(level: 3, recommendedAge: 7, question: 'ข้างไหนมีมากกว่า?', questionShort: '21 vs 25',
      correctAnswer: 0, wrongAnswers: [1, 2], data: QuestionData(leftCount: 21, rightCount: 25, comparisonType: 'moreOrLess'),
      hint: 'เปรียบเทียบให้ดี', encouragement: 'เยี่ยม! 21 < 25 ถูกต้อง! 🎉'),
    QuestionTemplate(level: 3, recommendedAge: 7, question: 'ข้างไหนมีมากกว่า?', questionShort: '28 vs 22',
      correctAnswer: 2, wrongAnswers: [0, 1], data: QuestionData(leftCount: 28, rightCount: 22, comparisonType: 'moreOrLess'),
      hint: 'นับให้ครบ', encouragement: 'ยอดเยี่ยม! 28 > 22 ถูกต้อง! ⭐'),
    QuestionTemplate(level: 3, recommendedAge: 7, question: 'เท่ากันไหม?', questionShort: '24 vs 24',
      correctAnswer: 1, wrongAnswers: [0, 2], data: QuestionData(leftCount: 24, rightCount: 24, comparisonType: 'equal'),
      hint: 'เช็คความเท่ากัน', encouragement: 'เจ๋ง! 24 = 24 ถูกต้อง! 🎯'),
    QuestionTemplate(level: 3, recommendedAge: 7, question: 'ข้างไหนมีน้อยกว่า?', questionShort: '27 vs 21',
      correctAnswer: 0, wrongAnswers: [1, 2], data: QuestionData(leftCount: 27, rightCount: 21, comparisonType: 'less'),
      hint: 'หาข้างที่น้อยกว่า', encouragement: 'สุดยอด! ขวาน้อยกว่า! 👏'),
    QuestionTemplate(level: 3, recommendedAge: 7, question: 'ข้างไหนมีมากกว่า?', questionShort: '23 vs 26',
      correctAnswer: 0, wrongAnswers: [1, 2], data: QuestionData(leftCount: 23, rightCount: 26, comparisonType: 'moreOrLess'),
      hint: 'เปรียบเทียบทั้งสองข้าง', encouragement: 'เก่ง! 23 < 26 ถูกต้อง! 🌟'),
    QuestionTemplate(level: 3, recommendedAge: 7, question: 'เท่ากันไหม?', questionShort: '25 vs 25',
      correctAnswer: 1, wrongAnswers: [0, 2], data: QuestionData(leftCount: 25, rightCount: 25, comparisonType: 'equal'),
      hint: 'ดูว่าเท่ากันไหม', encouragement: 'ว้าว! 25 = 25 ถูกต้อง! 🎊'),
    QuestionTemplate(level: 3, recommendedAge: 7, question: 'ข้างไหนมีมากกว่า?', questionShort: '26 vs 22',
      correctAnswer: 2, wrongAnswers: [0, 1], data: QuestionData(leftCount: 26, rightCount: 22, comparisonType: 'moreOrLess'),
      hint: 'นับแล้วเทียบ', encouragement: 'เยี่ยม! 26 > 22 ถูกต้อง! 🏆'),
    QuestionTemplate(level: 3, recommendedAge: 7, question: 'ข้างไหนมีน้อยกว่า?', questionShort: '28 vs 24',
      correctAnswer: 0, wrongAnswers: [1, 2], data: QuestionData(leftCount: 28, rightCount: 24, comparisonType: 'less'),
      hint: 'หาข้างที่น้อยกว่า', encouragement: 'ดีมาก! ขวาน้อยกว่า! 🎈'),
    QuestionTemplate(level: 3, recommendedAge: 7, question: 'ข้างไหนมีมากกว่า?', questionShort: '22 vs 27',
      correctAnswer: 0, wrongAnswers: [1, 2], data: QuestionData(leftCount: 22, rightCount: 27, comparisonType: 'moreOrLess'),
      hint: 'เปรียบเทียบให้ดี', encouragement: 'เจ๋งมาก! 22 < 27 ถูกต้อง! 💫'),
    QuestionTemplate(level: 3, recommendedAge: 7, question: 'เท่ากันไหม?', questionShort: '28 vs 28',
      correctAnswer: 1, wrongAnswers: [0, 2], data: QuestionData(leftCount: 28, rightCount: 28, comparisonType: 'equal'),
      hint: 'เช็คความเท่ากัน', encouragement: 'สุดยอด! 28 = 28 ถูกต้อง! 🎯'),

    // Stage 4: เปรียบเทียบ 29-35
    QuestionTemplate(level: 4, recommendedAge: 8, question: 'ข้างไหนมีมากกว่า?', questionShort: '29 vs 33',
      correctAnswer: 0, wrongAnswers: [1, 2], data: QuestionData(leftCount: 29, rightCount: 33, comparisonType: 'moreOrLess'),
      hint: 'เปรียบเทียบให้ดี', encouragement: 'เยี่ยม! 29 < 33 ถูกต้อง! 🎉'),
    QuestionTemplate(level: 4, recommendedAge: 8, question: 'ข้างไหนมีมากกว่า?', questionShort: '35 vs 30',
      correctAnswer: 2, wrongAnswers: [0, 1], data: QuestionData(leftCount: 35, rightCount: 30, comparisonType: 'moreOrLess'),
      hint: 'นับให้ครบ', encouragement: 'ยอดเยี่ยม! 35 > 30 ถูกต้อง! ⭐'),
    QuestionTemplate(level: 4, recommendedAge: 8, question: 'เท่ากันไหม?', questionShort: '32 vs 32',
      correctAnswer: 1, wrongAnswers: [0, 2], data: QuestionData(leftCount: 32, rightCount: 32, comparisonType: 'equal'),
      hint: 'เช็คความเท่ากัน', encouragement: 'เจ๋ง! 32 = 32 ถูกต้อง! 🎯'),
    QuestionTemplate(level: 4, recommendedAge: 8, question: 'ข้างไหนมีน้อยกว่า?', questionShort: '34 vs 29',
      correctAnswer: 0, wrongAnswers: [1, 2], data: QuestionData(leftCount: 34, rightCount: 29, comparisonType: 'less'),
      hint: 'หาข้างที่น้อยกว่า', encouragement: 'สุดยอด! ขวาน้อยกว่า! 👏'),
    QuestionTemplate(level: 4, recommendedAge: 8, question: 'ข้างไหนมีมากกว่า?', questionShort: '30 vs 35',
      correctAnswer: 0, wrongAnswers: [1, 2], data: QuestionData(leftCount: 30, rightCount: 35, comparisonType: 'moreOrLess'),
      hint: 'เปรียบเทียบทั้งสองข้าง', encouragement: 'เก่ง! 30 < 35 ถูกต้อง! 🌟'),
    QuestionTemplate(level: 4, recommendedAge: 8, question: 'เท่ากันไหม?', questionShort: '31 vs 31',
      correctAnswer: 1, wrongAnswers: [0, 2], data: QuestionData(leftCount: 31, rightCount: 31, comparisonType: 'equal'),
      hint: 'ดูว่าเท่ากันไหม', encouragement: 'ว้าว! 31 = 31 ถูกต้อง! 🎊'),
    QuestionTemplate(level: 4, recommendedAge: 8, question: 'ข้างไหนมีมากกว่า?', questionShort: '33 vs 29',
      correctAnswer: 2, wrongAnswers: [0, 1], data: QuestionData(leftCount: 33, rightCount: 29, comparisonType: 'moreOrLess'),
      hint: 'นับแล้วเทียบ', encouragement: 'เยี่ยม! 33 > 29 ถูกต้อง! 🏆'),
    QuestionTemplate(level: 4, recommendedAge: 8, question: 'ข้างไหนมีน้อยกว่า?', questionShort: '35 vs 32',
      correctAnswer: 0, wrongAnswers: [1, 2], data: QuestionData(leftCount: 35, rightCount: 32, comparisonType: 'less'),
      hint: 'หาข้างที่น้อยกว่า', encouragement: 'ดีมาก! ขวาน้อยกว่า! 🎈'),
    QuestionTemplate(level: 4, recommendedAge: 8, question: 'ข้างไหนมีมากกว่า?', questionShort: '31 vs 34',
      correctAnswer: 0, wrongAnswers: [1, 2], data: QuestionData(leftCount: 31, rightCount: 34, comparisonType: 'moreOrLess'),
      hint: 'เปรียบเทียบให้ดี', encouragement: 'เจ๋งมาก! 31 < 34 ถูกต้อง! 💫'),
    QuestionTemplate(level: 4, recommendedAge: 8, question: 'เท่ากันไหม?', questionShort: '35 vs 35',
      correctAnswer: 1, wrongAnswers: [0, 2], data: QuestionData(leftCount: 35, rightCount: 35, comparisonType: 'equal'),
      hint: 'เช็คความเท่ากัน', encouragement: 'สุดยอด! 35 = 35 ถูกต้อง! 🎯'),

    // Stage 5: เปรียบเทียบ 36-40 (โหดสุด!)
    QuestionTemplate(level: 5, recommendedAge: 9, question: 'ข้างไหนมีมากกว่า?', questionShort: '36 vs 39',
      correctAnswer: 0, wrongAnswers: [1, 2], data: QuestionData(leftCount: 36, rightCount: 39, comparisonType: 'moreOrLess'),
      hint: 'เปรียบเทียบให้ดี', encouragement: 'เยี่ยม! 36 < 39 ถูกต้อง! 🎉'),
    QuestionTemplate(level: 5, recommendedAge: 9, question: 'ข้างไหนมีมากกว่า?', questionShort: '40 vs 37',
      correctAnswer: 2, wrongAnswers: [0, 1], data: QuestionData(leftCount: 40, rightCount: 37, comparisonType: 'moreOrLess'),
      hint: 'นับให้ครบ', encouragement: 'ยอดเยี่ยม! 40 > 37 ถูกต้อง! ⭐'),
    QuestionTemplate(level: 5, recommendedAge: 9, question: 'เท่ากันไหม?', questionShort: '38 vs 38',
      correctAnswer: 1, wrongAnswers: [0, 2], data: QuestionData(leftCount: 38, rightCount: 38, comparisonType: 'equal'),
      hint: 'เช็คความเท่ากัน', encouragement: 'เจ๋ง! 38 = 38 ถูกต้อง! 🎯'),
    QuestionTemplate(level: 5, recommendedAge: 9, question: 'ข้างไหนมีน้อยกว่า?', questionShort: '39 vs 36',
      correctAnswer: 0, wrongAnswers: [1, 2], data: QuestionData(leftCount: 39, rightCount: 36, comparisonType: 'less'),
      hint: 'หาข้างที่น้อยกว่า', encouragement: 'สุดยอด! ขวาน้อยกว่า! 👏'),
    QuestionTemplate(level: 5, recommendedAge: 9, question: 'ข้างไหนมีมากกว่า?', questionShort: '37 vs 40',
      correctAnswer: 0, wrongAnswers: [1, 2], data: QuestionData(leftCount: 37, rightCount: 40, comparisonType: 'moreOrLess'),
      hint: 'เปรียบเทียบทั้งสองข้าง', encouragement: 'เก่ง! 37 < 40 ถูกต้อง! 🌟'),
    QuestionTemplate(level: 5, recommendedAge: 9, question: 'เท่ากันไหม?', questionShort: '40 vs 40',
      correctAnswer: 1, wrongAnswers: [0, 2], data: QuestionData(leftCount: 40, rightCount: 40, comparisonType: 'equal'),
      hint: 'ดูว่าเท่ากันไหม', encouragement: 'ว้าว! 40 = 40 ถูกต้อง! 🎊'),
    QuestionTemplate(level: 5, recommendedAge: 9, question: 'ข้างไหนมีมากกว่า?', questionShort: '39 vs 36',
      correctAnswer: 2, wrongAnswers: [0, 1], data: QuestionData(leftCount: 39, rightCount: 36, comparisonType: 'moreOrLess'),
      hint: 'นับแล้วเทียบ', encouragement: 'เยี่ยม! 39 > 36 ถูกต้อง! 🏆'),
    QuestionTemplate(level: 5, recommendedAge: 9, question: 'ข้างไหนมีน้อยกว่า?', questionShort: '40 vs 38',
      correctAnswer: 0, wrongAnswers: [1, 2], data: QuestionData(leftCount: 40, rightCount: 38, comparisonType: 'less'),
      hint: 'หาข้างที่น้อยกว่า', encouragement: 'ดีมาก! ขวาน้อยกว่า! 🎈'),
    QuestionTemplate(level: 5, recommendedAge: 9, question: 'ข้างไหนมีมากกว่า?', questionShort: '36 vs 40',
      correctAnswer: 0, wrongAnswers: [1, 2], data: QuestionData(leftCount: 36, rightCount: 40, comparisonType: 'moreOrLess'),
      hint: 'เปรียบเทียบให้ดี', encouragement: 'เจ๋งมาก! 36 < 40 ถูกต้อง! 💫'),
    QuestionTemplate(level: 5, recommendedAge: 9, question: 'เท่ากันไหม?', questionShort: '39 vs 39',
      correctAnswer: 1, wrongAnswers: [0, 2], data: QuestionData(leftCount: 39, rightCount: 39, comparisonType: 'equal'),
      hint: 'เช็คความเท่ากัน', encouragement: 'เทพสุดๆ! 39 = 39 ถูกต้อง! 🎯'),
  ];

  static int get totalLevels => 5;

  static List<QuestionTemplate> getQuestionsByLevel(int level) {
    return bank.where((q) => q.level == level).toList();
  }

  static QuestionTemplate getQuestion(int index) {
    if (bank.isEmpty) return bank[0];
    final clampedIndex = index.clamp(0, bank.length - 1);
    return bank[clampedIndex];
  }
}
