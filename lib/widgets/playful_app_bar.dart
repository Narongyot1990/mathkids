import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';

/// Playful App Bar - แถบบนสดใสน่ารักสำหรับเด็ก
class PlayfulAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBackPressed;
  final List<Widget>? actions;
  final Gradient? gradient;
  final bool showBackButton;
  final String? emoji;

  const PlayfulAppBar({
    super.key,
    required this.title,
    this.onBackPressed,
    this.actions,
    this.gradient,
    this.showBackButton = true,
    this.emoji,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        // ใช้สีเดียวทั้งหมด - เทาอ่อนนุ่มนวล
        color: const Color(0xFFF5F5F5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            offset: const Offset(0, 1),
            blurRadius: 4,
          ),
        ],
      ),
      child: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: showBackButton
            ? _buildBackButton(context)
            : null,
        title: _buildTitle(),
        actions: actions,
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            offset: const Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF424242)),
        onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
        iconSize: 20,
        padding: EdgeInsets.zero,
      ),
    );
  }

  Widget _buildTitle() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (emoji != null) ...[
          Text(
            emoji!,
            style: const TextStyle(fontSize: 28),
          ),
          const SizedBox(width: 8),
        ],
        Flexible(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 22,
              fontWeight: AppTypography.weightBold,
              color: const Color(0xFF424242), // เปลี่ยนจากขาวเป็นเทาเข้ม
              shadows: [
                Shadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  offset: const Offset(0, 1),
                  blurRadius: 2,
                ),
              ],
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

/// Game-specific App Bars with unique gradients
class CountingAppBar extends PlayfulAppBar {
  const CountingAppBar({
    super.key,
    super.onBackPressed,
    super.actions,
  }) : super(
          title: 'นับเลข',
          emoji: '🔢',
          gradient: AppColors.countingCardGradient,
        );
}

class AdditionAppBar extends PlayfulAppBar {
  const AdditionAppBar({
    super.key,
    super.onBackPressed,
    super.actions,
  }) : super(
          title: 'บวก',
          emoji: '➕',
          gradient: AppColors.additionCardGradient,
        );
}

class SubtractionAppBar extends PlayfulAppBar {
  const SubtractionAppBar({
    super.key,
    super.onBackPressed,
    super.actions,
  }) : super(
          title: 'ลบ',
          emoji: '➖',
          gradient: AppColors.subtractionCardGradient,
        );
}

class ComparisonAppBar extends PlayfulAppBar {
  const ComparisonAppBar({
    super.key,
    super.onBackPressed,
    super.actions,
  }) : super(
          title: 'เปรียบเทียบ',
          emoji: '⚖️',
          gradient: AppColors.comparisonCardGradient,
        );
}

class SequenceAppBar extends PlayfulAppBar {
  const SequenceAppBar({
    super.key,
    super.onBackPressed,
    super.actions,
  }) : super(
          title: 'ลำดับ',
          emoji: '🔢',
          gradient: AppColors.sequenceCardGradient,
        );
}

class MathGridAppBar extends PlayfulAppBar {
  const MathGridAppBar({
    super.key,
    super.onBackPressed,
    super.actions,
  }) : super(
          title: 'กริด',
          emoji: '🎯',
          gradient: AppColors.mathGridCardGradient,
        );
}
