import 'package:flutter/material.dart';
import '../data/models/game_type.dart';
import 'game_card.dart';
import '../services/audio/audio_manager.dart';

/// Game Card Carousel
/// Carousel ที่แสดงการ์ดเกม 3 อันต่อหน้า
/// การ์ดตรงกลางใหญ่สุด ปัดซ้าย-ขวาได้
class GameCardCarousel extends StatefulWidget {
  final List<GameType> games;

  const GameCardCarousel({
    super.key,
    required this.games,
  });

  @override
  State<GameCardCarousel> createState() => _GameCardCarouselState();
}

class _GameCardCarouselState extends State<GameCardCarousel> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      viewportFraction: 0.7, // แสดง 70% ของหน้าปัจจุบัน เห็นซ้าย-ขวา
      initialPage: 0,
    );

    // Listen to page changes
    _pageController.addListener(() {
      final page = _pageController.page?.round() ?? 0;
      if (page != _currentPage) {
        setState(() {
          _currentPage = page;
        });
        // เล่นเสียงเมื่อเปลี่ยนเกม
        audioManager.playPageTransition();
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Responsive sizing - mobile first
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;

    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate optimal carousel height based on available space
        final availableHeight = constraints.maxHeight;
        final bottomContentHeight = isSmallScreen ? 80.0 : 100.0; // indicator + hints
        final carouselHeight = (availableHeight - bottomContentHeight).clamp(250.0, 360.0);

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Carousel
            SizedBox(
              height: carouselHeight,
              child: PageView.builder(
                controller: _pageController,
                itemCount: widget.games.length,
                itemBuilder: (context, index) {
                  // Check if this card is centered
                  final isCenter = index == _currentPage;
                  final game = widget.games[index];

                  return Center(
                    child: GameCard(
                      gameType: game,
                      isCenter: isCenter,
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: isSmallScreen ? 8 : 12),

            // Page Indicator (จุดด้านล่าง)
            _buildPageIndicator(),

            SizedBox(height: isSmallScreen ? 8 : 12),

            // Navigation Hints (ลูกศร)
            _buildNavigationHints(),
          ],
        );
      },
    );
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        widget.games.length,
        (index) {
          final isActive = index == _currentPage;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: isActive ? 32 : 8,
            height: 8,
            decoration: BoxDecoration(
              color: isActive
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(4),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNavigationHints() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Left arrow
          if (_currentPage > 0)
            IconButton(
              icon: Icon(Icons.arrow_back_ios, size: isSmallScreen ? 24 : 32),
              color: Theme.of(context).colorScheme.primary,
              onPressed: () {
                audioManager.playButtonClick();
                _pageController.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
            )
          else
            SizedBox(width: isSmallScreen ? 40 : 48),

          SizedBox(width: isSmallScreen ? 8 : 40),

          // Swipe hint text
          Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                'ปัดซ้าย-ขวา',
                style: TextStyle(
                  fontSize: isSmallScreen ? 14 : 16,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),

          SizedBox(width: isSmallScreen ? 8 : 40),

          // Right arrow
          if (_currentPage < widget.games.length - 1)
            IconButton(
              icon: Icon(Icons.arrow_forward_ios, size: isSmallScreen ? 24 : 32),
              color: Theme.of(context).colorScheme.primary,
              onPressed: () {
                audioManager.playButtonClick();
                _pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
            )
          else
            SizedBox(width: isSmallScreen ? 40 : 48),
        ],
      ),
    );
  }
}
