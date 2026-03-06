import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/game_type.dart';
import '../../providers/game_provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import 'widgets/counting_game_widget.dart';
import 'widgets/comparison_game_widget.dart';
import 'widgets/sequence_game_widget.dart';
import 'widgets/math_grid_game_widget.dart';
import 'game_loading_screen.dart';
import '../../services/audio/audio_manager.dart';
import '../../services/audio/audio_context.dart';
import '../../widgets/answer_feedback_overlay.dart';
import '../../widgets/confetti_animation.dart';
import '../../widgets/responsive_game_layout.dart';

class GameScreen extends StatefulWidget {
  final GameType gameType;
  final int stageNumber;

  const GameScreen({
    super.key,
    required this.gameType,
    this.stageNumber = 1,
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  bool _isLoading = true;
  bool _hasPlayedVictoryMusic = false;
  bool _isProcessingAnswer = false; // ป้องกันการตอบซ้ำ

  @override
  void initState() {
    super.initState();
    debugPrint('🎮 [GAME] initState() - Stage ${widget.stageNumber}');
    // รีเซ็ต flags สำหรับด่านใหม่
    _hasPlayedVictoryMusic = false;
    _isProcessingAnswer = false;

    // ตั้งค่า context = กำลังเล่นเกม → เพลง game จะเล่นอัตโนมัติ
    _initAudio();
    // Don't start game yet, wait for loading screen
  }

  Future<void> _initAudio() async {
    debugPrint('🎮 [GAME] _initAudio() - Setting context to inGame');
    await audioManager.setContext(AudioContext.inGame);
  }

  void _onLoadingComplete() {
    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });
    // หมายเหตุ: game_start.wav ซ้ำกับ correct.wav ปิดการใช้งานไว้ก่อน
    // audioManager.playGameStart();

    // Start game after loading
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<GameProvider>().startGame(
        widget.gameType,
        Difficulty.easy,
        stageNumber: widget.stageNumber,
      );
    });
  }

  @override
  void dispose() {
    debugPrint('🎮 [GAME] dispose() - Stage ${widget.stageNumber}');
    // รีเซ็ต flags เพื่อป้องกัน state เก่าค้าง
    _hasPlayedVictoryMusic = true; // บังคับให้ไม่เล่นเพลง victory ซ้ำ
    _isProcessingAnswer = false;
    super.dispose();
  }

  Future<void> _handleBackButton() async {
    debugPrint('🎮 [GAME] _handleBackButton() - User pressed back button');
    // หยุด game และเปลี่ยนเพลงก่อน pop
    await _exitGame();
    if (mounted) {
      Navigator.pop(context, true);
    }
  }

  Future<void> _exitGame() async {
    debugPrint('🎮 [GAME] _exitGame() - Cleaning up and changing music');
    // เปลี่ยนเพลงกลับเป็นเมนู
    await audioManager.setContext(AudioContext.mainMenu);
    // Reset game state
    if (mounted) {
      context.read<GameProvider>().reset();
    }
  }

  /// Get gradient for game type background
  Gradient _getBackgroundGradient() {
    switch (widget.gameType) {
      case GameType.counting:
        return AppColors.countingGameBackground;
      case GameType.comparison:
        return AppColors.comparisonGameBackground;
      case GameType.sequence:
        return AppColors.sequenceGameBackground;
      case GameType.mathGrid:
        return AppColors.mathGridGameBackground;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show loading screen first
    if (_isLoading) {
      return GameLoadingScreen(
        onLoadingComplete: _onLoadingComplete,
      );
    }

    // Show game screen after loading - ใช้ PopScope เพื่อจัดการปุ่มย้อนกลับ
    return PopScope(
      canPop: false, // ป้องกันการ pop อัตโนมัติ
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          // ถ้ายังไม่ได้ pop ให้จัดการเอง
          await _handleBackButton();
        }
      },
      child: Scaffold(
        body: Consumer<GameProvider>(
        builder: (context, game, _) {
          if (game.currentQuestion == null) {
            return Container(
              decoration: BoxDecoration(gradient: _getBackgroundGradient()),
              child: const Center(child: CircularProgressIndicator()),
            );
          }

          if (game.isGameOver) {
            return _buildGameOver(context, game);
          }

          // ใช้ ResponsiveGameLayout ใหม่
          return ResponsiveGameLayout(
            score: game.score,
            currentQuestion: game.currentQuestionNumber,
            totalQuestions: game.totalQuestions,
            gradient: _getBackgroundGradient(),
            questionWidget: _buildGameWidget(game),
            onBackPressed: _handleBackButton,
          );
        },
      ),
      ),
    );
  }

  Widget _buildGameWidget(GameProvider game) {
    // Common callback for answer handling
    void handleAnswer(int answer) {
      debugPrint('🎯 [GAME] handleAnswer called - _isProcessingAnswer: $_isProcessingAnswer');

      // ป้องกันการเรียกซ้ำ - ใช้ flag แทนเพราะ game.isCorrect อาจยังไม่อัพเดท
      if (_isProcessingAnswer) {
        debugPrint('⚠️ [GAME] Already processing answer, skipping duplicate call');
        return;
      }

      debugPrint('✅ [GAME] Processing answer...');
      setState(() {
        _isProcessingAnswer = true;
      });

      final isCorrect = answer == game.currentQuestion!.correctAnswer;

      // เล่นเสียงตามผลลัพธ์
      if (isCorrect) {
        audioManager.playCorrectSound();
      } else {
        audioManager.playWrongSound();
      }

      // แสดง feedback animation overlay
      showDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.transparent,
        builder: (context) => AnswerFeedbackOverlay(
          isCorrect: isCorrect,
          onComplete: () {
            Navigator.of(context).pop();
          },
        ),
      );

      game.checkAnswer(answer, widget.gameType, Difficulty.easy);

      // รอ 1.5 วินาทีก่อนอนุญาตให้ตอบคำถามใหม่ได้
      Future.delayed(const Duration(milliseconds: 1500), () {
        if (mounted) {
          setState(() {
            _isProcessingAnswer = false;
            debugPrint('🔓 [GAME] Answer processing unlocked');
          });
        }
      });
    }

    // Return appropriate game widget based on game type
    switch (widget.gameType) {
      case GameType.counting:
        return CountingGameWidget(
          question: game.currentQuestion!,
          gameType: widget.gameType,
          difficulty: Difficulty.easy,
          isCorrect: game.isCorrect,
          isProcessingAnswer: _isProcessingAnswer,
          onAnswer: handleAnswer,
        );

      case GameType.comparison:
        return ComparisonGameWidget(
          question: game.currentQuestion!,
          gameType: widget.gameType,
          difficulty: Difficulty.easy,
          isCorrect: game.isCorrect,
          isProcessingAnswer: _isProcessingAnswer,
          onAnswer: handleAnswer,
        );

      case GameType.sequence:
        return SequenceGameWidget(
          question: game.currentQuestion!,
          gameType: widget.gameType,
          difficulty: Difficulty.easy,
          isCorrect: game.isCorrect,
          isProcessingAnswer: _isProcessingAnswer,
          onAnswer: handleAnswer,
        );

      case GameType.mathGrid:
        return MathGridWidget(
          key: ValueKey(game.currentQuestionNumber),
          gridLayout: game.currentQuestion!.gridLayout ?? [],
          dragOptions: game.currentQuestion!.dragOptions ?? [],
          correctAnswers: game.currentQuestion!.options,
          onComplete: (isCorrect) {
            if (isCorrect) {
              handleAnswer(game.currentQuestion!.correctAnswer);
            }
          },
        );
    }
  }

  Widget _buildGameOver(BuildContext context, GameProvider game) {
    final stars = game.calculateStars();

    // เล่นเสียงชนะเมื่อเข้าหน้าจบเกม (เล่นครั้งเดียวเท่านั้น)
    if (!_hasPlayedVictoryMusic) {
      _hasPlayedVictoryMusic = true;
      debugPrint('🎮 [GAME] _buildGameOver() - Stage ${widget.stageNumber} - Playing victory music');

      WidgetsBinding.instance.addPostFrameCallback((_) async {
        // เช็คว่า widget ยัง mounted อยู่หรือไม่ (ป้องกัน instance เก่าที่ถูก pop แล้ว)
        if (!mounted) {
          debugPrint('⚠️ [GAME] Widget not mounted, skipping victory music');
          return;
        }

        // ตั้งค่า context = ชนะแล้ว → เพลง victory จะเล่นอัตโนมัติ
        await audioManager.setContext(AudioContext.gameVictory);

        // เล่นเสียงเก็บดาวทีละดาว
        for (int i = 0; i < stars; i++) {
          Future.delayed(Duration(milliseconds: 500 + (i * 400)), () {
            if (mounted) {
              audioManager.playStarCollect();
            }
          });
        }

        // ถ้าได้ 3 ดาวเล่นเสียง perfect
        if (stars == 3) {
          Future.delayed(const Duration(milliseconds: 1700), () {
            if (mounted) {
              audioManager.playPerfectSound();
            }
          });
        }
      });
    }

    return ConfettiAnimation(
      isPlaying: true,
      child: Container(
        decoration: BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '🎉',
                style: TextStyle(fontSize: 80),
              ),
              AppSpacing.verticalSpaceNormal,
              Text(
                'เยี่ยมมาก!',
                style: AppTypography.displayLarge,
              ),
              AppSpacing.verticalSpaceNormal,
              Text(
                'คะแนน: ${game.score}',
                style: AppTypography.heading2,
              ),
              AppSpacing.verticalSpaceNormal,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  3,
                  (index) => Icon(
                    index < stars ? Icons.star : Icons.star_border,
                    color: AppColors.gameStar,
                    size: 50,
                  ),
                ),
              ),
              AppSpacing.verticalSpaceLarge,
              ElevatedButton(
                onPressed: () async {
                  audioManager.playButtonClick();
                  // ออกจากเกมอย่างถูกต้อง
                  await _exitGame();
                  if (mounted) {
                    Navigator.pop(context, true);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryGreen,
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.buttonPaddingHorizontal,
                    vertical: AppSpacing.buttonPaddingVertical,
                ),
              ),
                child: Text(
                  'กลับเมนู',
                  style: AppTypography.buttonLarge,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}