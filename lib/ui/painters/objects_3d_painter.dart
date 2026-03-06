import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/assets/game_emojis.dart';

class Objects3DPainter extends StatelessWidget {
  final int count;
  final int? selectedAnswer;
  final int? correctAnswer;
  final bool showFeedback;
  final double rotationX;
  final double rotationY;

  const Objects3DPainter({
    super.key,
    required this.count,
    this.selectedAnswer,
    this.correctAnswer,
    this.showFeedback = false,
    this.rotationX = 0,
    this.rotationY = 0,
  });

  @override
  Widget build(BuildContext context) {
    final random = Random(count * 42);
    final emoji = GameEmojis.counting.getByIndex(count);
    
    final emojis = <_EmojiData>[];
    
    for (int i = 0; i < count; i++) {
      double x, y;
      int attempts = 0;
      
      do {
        x = 30 + random.nextDouble() * 240;
        y = 30 + random.nextDouble() * 200;
        attempts++;
      } while (_isOverlapping(x, y, emojis, 50) && attempts < 50);
      
      emojis.add(_EmojiData(
        emoji: emoji,
        x: x,
        y: y,
        size: 45 + random.nextDouble() * 20,
        layerDepth: random.nextDouble(),
        floatOffset: random.nextDouble() * 2 * pi,
      ));
    }
    
    if (showFeedback && selectedAnswer != null && correctAnswer != null) {
      if (selectedAnswer! < correctAnswer!) {
        final missing = correctAnswer! - count;
        for (int i = 0; i < missing; i++) {
          double x, y;
          int attempts = 0;
          
          do {
            x = 30 + random.nextDouble() * 240;
            y = 30 + random.nextDouble() * 200;
            attempts++;
          } while (_isOverlapping(x, y, emojis, 50) && attempts < 30);
          
          emojis.add(_EmojiData(
            emoji: emoji,
            x: x,
            y: y,
            size: 35,
            layerDepth: 0.9,
            floatOffset: random.nextDouble() * 2 * pi,
            isGhost: true,
          ));
        }
      }
    }
    
    return Stack(
      children: [
        for (int i = 0; i < emojis.length; i++)
          _buildEmojiLayer(emojis[i], i, emojis.length),
      ],
    );
  }

  Widget _buildEmojiLayer(_EmojiData data, int index, int total) {
    return _FloatingEmoji(
      emoji: data.emoji,
      size: data.size,
      x: data.x,
      y: data.y,
      layerDepth: data.layerDepth,
      floatOffset: data.floatOffset,
      rotationX: rotationX,
      rotationY: rotationY,
      isGhost: data.isGhost,
    );
  }

  bool _isOverlapping(double x, double y, List<_EmojiData> items, double minDistance) {
    for (final item in items) {
      final dx = x - item.x;
      final dy = y - item.y;
      if (sqrt(dx * dx + dy * dy) < minDistance) {
        return true;
      }
    }
    return false;
  }
}

class _EmojiData {
  final String emoji;
  final double x;
  final double y;
  final double size;
  final double layerDepth;
  final double floatOffset;
  final bool isGhost;

  _EmojiData({
    required this.emoji,
    required this.x,
    required this.y,
    required this.size,
    required this.layerDepth,
    required this.floatOffset,
    this.isGhost = false,
  });
}

class _FloatingEmoji extends StatefulWidget {
  final String emoji;
  final double size;
  final double x;
  final double y;
  final double layerDepth;
  final double floatOffset;
  final double rotationX;
  final double rotationY;
  final bool isGhost;

  const _FloatingEmoji({
    required this.emoji,
    required this.size,
    required this.x,
    required this.y,
    required this.layerDepth,
    required this.floatOffset,
    required this.rotationX,
    required this.rotationY,
    this.isGhost = false,
  });

  @override
  State<_FloatingEmoji> createState() => _FloatingEmojiState();
}

class _FloatingEmojiState extends State<_FloatingEmoji>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 3000 + (widget.layerDepth * 1000).toInt()),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final offsetX = widget.rotationY * widget.layerDepth * 60;
    final offsetY = widget.rotationX * widget.layerDepth * 60;
    final scale = 0.5 + (widget.layerDepth * 0.5);
    final opacity = 0.3 + (widget.layerDepth * 0.7);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final floatY = sin(_controller.value * pi * 2 + widget.floatOffset) * 8;
        
        return Positioned(
          left: widget.x + offsetX,
          top: widget.y + offsetY + floatY,
          child: Transform.scale(
            scale: scale,
            child: Opacity(
              opacity: opacity,
              child: widget.isGhost
                  ? Stack(
                      children: [
                        Text(
                          widget.emoji,
                          style: TextStyle(
                            fontSize: widget.size,
                            color: Colors.black54,
                          ),
                        ),
                        Positioned.fill(
                          child: Icon(
                            Icons.close,
                            color: Colors.red,
                            size: widget.size * 0.6,
                          ),
                        ),
                      ],
                    )
                  : Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Text(
                        widget.emoji,
                        style: TextStyle(
                          fontSize: widget.size,
                        ),
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }
}

class Mascot3D extends StatefulWidget {
  final String mascot;
  final double x;
  final double y;
  final double rotationY;
  final double size;

  const Mascot3D({
    super.key,
    required this.mascot,
    required this.x,
    required this.y,
    this.rotationY = 0,
    this.size = 50.0,
  });

  @override
  State<Mascot3D> createState() => _Mascot3DState();
}

class _Mascot3DState extends State<Mascot3D>
    with SingleTickerProviderStateMixin {
  late AnimationController _bounceController;

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _bounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final offsetX = widget.rotationY * 30;
    final bounceAmplitude = widget.size * 0.1;

    return AnimatedBuilder(
      animation: _bounceController,
      builder: (context, child) {
        final bounceY = sin(_bounceController.value * pi) * bounceAmplitude;
        
        return Positioned(
          left: widget.x + offsetX,
          top: widget.y + bounceY,
          child: Transform.scale(
            scale: 1 + (_bounceController.value * 0.1),
            child: Text(
              widget.mascot,
              style: TextStyle(fontSize: widget.size),
            ),
          ),
        );
      },
    );
  }
}
