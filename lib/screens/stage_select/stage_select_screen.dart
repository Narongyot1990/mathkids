import 'package:flutter/material.dart';
import '../../data/models/game_type.dart';
import '../../data/models/stage_progress.dart';
import '../../services/progress_service.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_sizes.dart';
import '../../core/theme/app_typography.dart';
import '../game/game_screen.dart';
import '../../services/audio/audio_manager.dart';

class StageSelectScreen extends StatefulWidget {
  final GameType gameType;

  const StageSelectScreen({super.key, required this.gameType});

  @override
  State<StageSelectScreen> createState() => _StageSelectScreenState();
}

class _StageSelectScreenState extends State<StageSelectScreen> {
  final ProgressService _progressService = ProgressService();
  List<StageProgress> _stages = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final stages = await _progressService.getAllStageProgress(widget.gameType);
    if (!mounted) return;
    setState(() {
      _stages = stages;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Responsive design
    final isSmallScreen = AppSizes.isSmallScreen(context);
    final screenWidth = MediaQuery.of(context).size.width;

    // Calculate responsive grid
    int crossAxisCount = 3;
    if (screenWidth < 400) {
      crossAxisCount = 2;
    } else if (screenWidth > 800) {
      crossAxisCount = 4;
    }

    return Scaffold(
      appBar: AppBar(
        title: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text('${widget.gameType.emoji} ${widget.gameType.displayName}'),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  SizedBox(height: isSmallScreen ? AppSpacing.sm : AppSpacing.lg),
                  Padding(
                    padding: AppSpacing.paddingHorizontalNormal,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        'เลือกด่าน',
                        style: isSmallScreen
                          ? AppTypography.heading2
                          : AppTypography.heading1,
                      ),
                    ),
                  ),
                  SizedBox(height: isSmallScreen ? AppSpacing.md : AppSpacing.xl),
                  Expanded(
                    child: GridView.builder(
                      padding: EdgeInsets.all(isSmallScreen ? AppSpacing.sm : AppSpacing.lg),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: isSmallScreen ? AppSpacing.sm : AppSpacing.lg,
                        mainAxisSpacing: isSmallScreen ? AppSpacing.sm : AppSpacing.lg,
                        childAspectRatio: 0.8,
                      ),
                      itemCount: _stages.length,
                      itemBuilder: (context, index) {
                        return _buildStageCard(_stages[index], isSmallScreen);
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildStageCard(StageProgress stage, bool isSmallScreen) {
    final isLocked = !stage.isUnlocked;

    // Responsive sizes
    final iconSize = isSmallScreen ? 40.0 : 50.0;
    final circleSize = isSmallScreen ? 50.0 : 70.0;
    final numberSize = isSmallScreen ? 28.0 : 36.0;
    final starSize = isSmallScreen ? 18.0 : 24.0;
    final spacing = isSmallScreen ? AppSpacing.xs : AppSpacing.md;

    return GestureDetector(
      onTap: isLocked
          ? null
          : () {
              audioManager.playButtonClick();
              _startStage(stage.stageNumber);
            },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isLocked ? AppColors.grey300 : AppColors.surface,
          borderRadius: isSmallScreen ? AppSizes.borderRadiusMd : AppSizes.borderRadiusXl,
          border: Border.all(
            color: isLocked ? AppColors.grey400 : AppTheme.primaryBlue,
            width: isSmallScreen ? AppSizes.borderWidthNormal : AppSizes.borderWidthThick,
          ),
          boxShadow: isLocked ? [] : AppSizes.shadowMd,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isSmallScreen ? 4.0 : 8.0,
            vertical: isSmallScreen ? 8.0 : 12.0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Lock Icon หรือ Stage Number
              if (isLocked)
                Icon(
                  Icons.lock,
                  size: iconSize,
                  color: AppColors.grey500,
                )
              else
                Container(
                  width: circleSize,
                  height: circleSize,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryBlue,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '${stage.stageNumber}',
                          style: TextStyle(
                            fontSize: numberSize,
                            fontWeight: AppTypography.weightBold,
                            color: AppColors.textLight,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

              SizedBox(height: spacing),

              // ดาว (ถ้าปลดล็อคแล้ว)
              if (!isLocked)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(
                    3,
                    (starIndex) => Icon(
                      starIndex < stage.stars ? Icons.star : Icons.star_border,
                      color: AppColors.gameStar,
                      size: starSize,
                    ),
                  ),
                )
              else
                SizedBox(height: starSize),

              SizedBox(height: isSmallScreen ? 4 : 6),

              // คะแนนสูงสุด (ถ้าเคยเล่น) - ใช้ Flexible แก้ overflow
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      !isLocked && stage.isCompleted
                          ? 'คะแนน: ${stage.score}'
                          : !isLocked
                              ? 'ยังไม่ผ่าน'
                              : '',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 10 : 12,
                        color: !isLocked && stage.isCompleted
                            ? AppColors.grey700
                            : AppColors.grey600,
                        fontWeight: !isLocked && stage.isCompleted
                            ? AppTypography.weightBold
                            : AppTypography.weightRegular,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _startStage(int stageNumber) async {
    // ไปหน้าเกม
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GameScreen(
          gameType: widget.gameType,
          stageNumber: stageNumber,
        ),
      ),
    );

    // ✅ กลับมาจากเกม ให้โหลดความคืบหน้าใหม่ทุกครั้ง
    // (ไม่ว่าจะกด "กลับเมนู" หรือกลับด้วยวิธีไหน)
    if (mounted) {
      _loadProgress();
    }
  }
}
