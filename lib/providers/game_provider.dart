import 'dart:async';
import 'package:flutter/foundation.dart';
import '../data/models/game_type.dart';
import '../data/models/question.dart';
import '../data/question_bank/question_bank.dart';
import '../services/progress_service.dart';
import '../data/repositories/stats_repository.dart';

class GameProvider with ChangeNotifier {
  final ProgressService _progressService = ProgressService();
  final StatsRepository _statsRepository = StatsRepository();

  Question? _currentQuestion;
  int _currentQuestionNumber = 1;
  final int _totalQuestions = 10;
  int _score = 0;
  int _correctAnswers = 0;  // นับข้อถูก
  bool? _isCorrect;
  bool _isGameOver = false;
  GameType? _currentGameType;
  int? _currentStageNumber;
  int? _lastSelectedAnswer;
  int? _currentLevel; // Level ปัจจุบัน (1-based)
  Timer? _pendingTimer;
  bool _disposed = false;

  // Getters
  Question? get currentQuestion => _currentQuestion;
  int get currentQuestionNumber => _currentQuestionNumber;
  int get totalQuestions => _totalQuestions;
  int get score => _score;
  bool? get isCorrect => _isCorrect;
  bool get isGameOver => _isGameOver;
  int? get lastSelectedAnswer => _lastSelectedAnswer;

  void startGame(GameType gameType, Difficulty difficulty, {int stageNumber = 1}) {
    _currentQuestionNumber = 1;
    _score = 0;
    _correctAnswers = 0;  // รีเซ็ต
    _isGameOver = false;
    _isCorrect = null;
    _currentGameType = gameType;
    _currentStageNumber = stageNumber;
    _currentLevel = stageNumber; // ใช้ stageNumber เป็น level
    _generateNextQuestion(gameType);
  }

  void _generateNextQuestion(GameType gameType) {
    // ใช้ QuestionBank แทน FixedQuestionGenerator
    // ดึงคำถามตาม level ที่เพิ่มขึ้นตามข้อที่ทำ
    final level = (_currentLevel ?? 1) + (_currentQuestionNumber - 1);
    _currentQuestion = QuestionBank.getQuestion(gameType, level);
    _isCorrect = null;
    _lastSelectedAnswer = null; // รีเซ็ตคำตอบที่เลือก
    notifyListeners();
  }

  void checkAnswer(int answer, GameType gameType, Difficulty difficulty) {
    if (_currentQuestion == null) return;

    _lastSelectedAnswer = answer; // บันทึกคำตอบที่เลือก
    _isCorrect = answer == _currentQuestion!.correctAnswer;
    if (_isCorrect!) {
      _score += 10;
      _correctAnswers++;  // นับข้อถูก
    }
    notifyListeners();

    // Delay ก่อนไปข้อถัดไป (ใช้ Timer เพื่อ cancel ได้ตอน dispose)
    _pendingTimer?.cancel();
    _pendingTimer = Timer(const Duration(milliseconds: 1500), () {
      if (!_disposed) _nextQuestion(gameType);
    });
  }

  void _nextQuestion(GameType gameType) async {
    if (_currentQuestionNumber >= _totalQuestions) {
      _isGameOver = true;

      // บันทึกความคืบหน้า และสถิติ
      if (_currentGameType != null && _currentStageNumber != null) {
        final stars = calculateStars();

        // บันทึกความคืบหน้า stage
        await _progressService.saveStageProgress(
          _currentGameType!,
          _currentStageNumber!,
          stars,
          _score,
        );

        // บันทึกสถิติเด็ก
        await _statsRepository.updateStatsAfterGame(
          gameType: _currentGameType!,
          score: _score,
          stars: stars,
          correctAnswers: _correctAnswers,
          totalQuestions: _totalQuestions,
        );
      }

      notifyListeners();
    } else {
      _currentQuestionNumber++;
      _generateNextQuestion(gameType);
    }
  }

  int calculateStars() {
    final percentage = (_score / (_totalQuestions * 10)) * 100;
    if (percentage >= 90) return 3;
    if (percentage >= 70) return 2;
    if (percentage >= 50) return 1;
    return 0;
  }

  void reset() {
    _pendingTimer?.cancel();
    _currentQuestion = null;
    _currentQuestionNumber = 1;
    _score = 0;
    _correctAnswers = 0;
    _isCorrect = null;
    _isGameOver = false;
    _lastSelectedAnswer = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    _pendingTimer?.cancel();
    super.dispose();
  }
}
