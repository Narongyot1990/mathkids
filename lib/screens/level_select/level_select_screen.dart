import 'package:flutter/material.dart';
import '../../data/models/game_type.dart';
import '../../data/models/kid_stats.dart';
import '../../data/repositories/stats_repository.dart';
import '../../widgets/game_card_carousel.dart';
import '../../widgets/compact_stats_widget.dart';
import '../../widgets/playful_background.dart';
import '../../widgets/playful_app_bar.dart';
import '../../core/theme/app_colors.dart';

/// Level Select Screen
/// แสดง Carousel เลือกเกม + สถิติพัฒนาการด้านล่าง
class LevelSelectScreen extends StatefulWidget {
  const LevelSelectScreen({super.key});

  @override
  State<LevelSelectScreen> createState() => _LevelSelectScreenState();
}

class _LevelSelectScreenState extends State<LevelSelectScreen> {
  final StatsRepository _statsRepository = StatsRepository();
  KidStats _stats = KidStats.empty();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    final stats = await _statsRepository.loadStats();
    if (!mounted) return;
    setState(() {
      _stats = stats;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final games = GameType.values;

    return Scaffold(
      appBar: const PlayfulAppBar(
        title: 'เลือกเกม',
        emoji: '🎮',
        gradient: AppColors.pinkGradient,
      ),
      body: PlayfulBackground(
        gradient: AppColors.rainbowBackground,
        showFloatingEmojis: true,
        child: Column(
          children: [
            // Carousel (ด้านบน)
            Expanded(
              flex: 3,
              child: Center(
                child: GameCardCarousel(games: games),
              ),
            ),

            // Stats (ด้านล่าง)
            if (_isLoading)
              const Padding(
                padding: EdgeInsets.all(16),
                child: SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              )
            else
              CompactStatsWidget(stats: _stats),
          ],
        ),
      ),
    );
  }
}
