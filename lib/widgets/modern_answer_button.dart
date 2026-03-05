import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';
import '../core/theme/app_sizes.dart';
import '../data/models/game_type.dart';

class ModernAnswerButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final Gradient? gradient;
  final Color? backgroundColor;
  final double size;
  final bool isCorrect;
  final bool isWrong;
  final bool showRotation;
  final String? emoji;

  const ModernAnswerButton({
    super.key,
    required this.text,
    this.onPressed,
    this.gradient,
    this.backgroundColor,
    this.size = 100.0,
    this.isCorrect = false,
    this.isWrong = false,
    this.showRotation = false,
    this.emoji,
  });

  @override
  State<ModernAnswerButton> createState() => _ModernAnswerButtonState();
}

class _ModernAnswerButtonState extends State<ModernAnswerButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _rotationAnimation = Tween<double>(begin: 0, end: 2 * math.pi).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _controller.reverse();
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
    _controller.reverse();
  }

  Gradient _getGradient() {
    if (widget.isCorrect) return AppColors.successGradient;
    if (widget.isWrong) return AppColors.errorGradient;
    if (widget.gradient != null) return widget.gradient!;
    return AppColors.blueGradient;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: widget.onPressed != null ? _handleTapDown : null,
      onTapUp: widget.onPressed != null
          ? (details) {
              _handleTapUp(details);
              widget.onPressed?.call();
            }
          : null,
      onTapCancel: _handleTapCancel,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Transform.rotate(
              angle: widget.showRotation ? _rotationAnimation.value : 0,
              child: Container(
                width: widget.size,
                height: widget.size,
                decoration: BoxDecoration(
                  gradient: _getGradient(),
                  borderRadius: BorderRadius.circular(widget.size * 0.25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withValues(alpha: 0.5),
                      offset: const Offset(-2, -2),
                      blurRadius: 4,
                    ),
                    BoxShadow(
                      color: Colors.black.withValues(alpha: _isPressed ? 0.1 : 0.3),
                      offset: Offset(
                        _isPressed ? 2 : 4,
                        _isPressed ? 2 : 6,
                      ),
                      blurRadius: _isPressed ? 4 : 12,
                      spreadRadius: _isPressed ? 0 : 2,
                    ),
                  ],
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(widget.size * 0.25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        offset: const Offset(0, 2),
                        blurRadius: 4,
                        spreadRadius: -2,
                      ),
                    ],
                  ),
                  child: Center(
                    child: widget.emoji != null
                        ? Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                widget.emoji!,
                                style: TextStyle(fontSize: widget.size * 0.4),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                widget.text,
                                style: TextStyle(
                                  fontSize: widget.size * 0.35,
                                  fontWeight: AppTypography.weightBold,
                                  color: AppColors.textLight,
                                ),
                              ),
                            ],
                          )
                        : Text(
                            widget.text,
                            style: TextStyle(
                              fontSize: widget.size * 0.45,
                              fontWeight: AppTypography.weightBold,
                              color: AppColors.textLight,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withValues(alpha: 0.3),
                                  offset: const Offset(0, 2),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                          ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class ModernAnswerButtonGrid extends StatelessWidget {
  final List<int> options;
  final int correctAnswer;
  final bool? isCorrect;
  final bool isProcessing;
  final Function(int) onAnswer;
  final String Function(int)? displayTextBuilder;
  final List<Gradient>? buttonGradients;
  final GameType? gameType;

  const ModernAnswerButtonGrid({
    super.key,
    required this.options,
    required this.correctAnswer,
    this.isCorrect,
    required this.isProcessing,
    required this.onAnswer,
    this.displayTextBuilder,
    this.buttonGradients,
    this.gameType,
  });

  String? _getEmojiForOption(int option, int index) {
    if (gameType == null) return null;
    
    final emojis = {
      GameType.counting: ['🍎', '🍊', '🍋', '🍇'],
      GameType.addition: ['⭐', '🌟', '✨', '💫'],
      GameType.subtraction: ['🎯', '🎪', '🎨', '🎭'],
      GameType.comparison: ['❤️', '💙', '💚', '💛'],
      GameType.sequence: ['🔢', '🔡', '🔠', '0️⃣'],
      GameType.mathGrid: ['🟦', '🟧', '🟩', '🟥'],
    };
    
    return emojis[gameType]?[index % 4];
  }

  Gradient _getGradientForIndex(int index) {
    if (buttonGradients != null && index < buttonGradients!.length) {
      return buttonGradients![index];
    }

    final gradients = [
      AppColors.blueGradient,
      AppColors.pinkGradient,
      AppColors.greenGradient,
      AppColors.yellowGradient,
      AppColors.orangeGradient,
      AppColors.purpleGradient,
    ];

    return gradients[index % gradients.length];
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final scaleFactor = AppSizes.getScaleFactor(context);

    final totalPadding = 32.0 * scaleFactor;
    final totalSpacing = 16.0 * scaleFactor;
    final buttonSize = ((screenWidth - totalPadding - totalSpacing) / 4).clamp(42.0, 60.0);
    final spacing = 8.0 * scaleFactor;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 20 * scaleFactor,
        vertical: 12 * scaleFactor,
      ),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: spacing,
        runSpacing: spacing,
        children: options.asMap().entries.map((entry) {
          final index = entry.key;
          final option = entry.value;

          bool isThisCorrect = option == correctAnswer;
          bool isThisWrong = isCorrect == false && !isThisCorrect;
          final emoji = _getEmojiForOption(option, index);

          return AnimatedButtonWrapper(
            delay: index * 0.1,
            child: ModernAnswerButton(
              text: displayTextBuilder?.call(option) ?? '$option',
              emoji: emoji,
              size: buttonSize,
              gradient: isCorrect == null
                  ? _getGradientForIndex(index)
                  : (isThisCorrect
                      ? AppColors.successGradient
                      : AppColors.errorGradient),
              onPressed: (isCorrect == null && !isProcessing)
                  ? () => onAnswer(option)
                  : null,
              isCorrect: isThisCorrect && isCorrect == true,
              isWrong: isThisWrong,
            ),
          );
        }).toList(),
      ),
    );
  }
}

class AnimatedButtonWrapper extends StatefulWidget {
  final Widget child;
  final double delay;

  const AnimatedButtonWrapper({
    super.key,
    required this.child,
    this.delay = 0,
  });

  @override
  State<AnimatedButtonWrapper> createState() => _AnimatedButtonWrapperState();
}

class _AnimatedButtonWrapperState extends State<AnimatedButtonWrapper>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _bounceAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _bounceAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticOut,
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    Future.delayed(Duration(milliseconds: (widget.delay * 1000).toInt()), () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _bounceAnimation.value,
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: widget.child,
          ),
        );
      },
    );
  }
}
