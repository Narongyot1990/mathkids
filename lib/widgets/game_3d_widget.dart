import 'dart:math';
import 'package:flutter/material.dart';

class Game3DWidget extends StatefulWidget {
  final Widget child;
  final bool enableRotation;
  final bool autoRotate;
  final double autoRotateSpeed;
  final double maxRotationX;
  final double maxRotationY;
  final int layerCount;

  const Game3DWidget({
    super.key,
    required this.child,
    this.enableRotation = true,
    this.autoRotate = true,
    this.autoRotateSpeed = 0.015,
    this.maxRotationX = 0.25,
    this.maxRotationY = 0.4,
    this.layerCount = 3,
  });

  @override
  State<Game3DWidget> createState() => _Game3DWidgetState();
}

class _Game3DWidgetState extends State<Game3DWidget>
    with TickerProviderStateMixin {
  late AnimationController _autoRotateController;
  late AnimationController _hoverController;
  
  double _rotationX = 0;
  double _rotationY = 0;
  double _targetRotationX = 0;
  double _targetRotationY = 0;
  
  Offset _lastPanPosition = Offset.zero;
  bool _isDragging = false;
  Offset _mousePosition = Offset.zero;
  
  @override
  void initState() {
    super.initState();
    _autoRotateController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    );
    
    _hoverController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
    
    if (widget.autoRotate && widget.enableRotation) {
      _startAutoRotate();
    }
  }

  void _startAutoRotate() {
    _autoRotateController.repeat();
    _autoRotateController.addListener(_updateAutoRotation);
  }

  void _updateAutoRotation() {
    if (!_isDragging && widget.autoRotate && widget.enableRotation) {
      setState(() {
        final time = _autoRotateController.value * 2 * pi;
        _targetRotationY = sin(time) * widget.maxRotationY;
        _targetRotationX = sin(time * 0.7) * widget.maxRotationX;
        
        _rotationX += (_targetRotationX - _rotationX) * 0.03;
        _rotationY += (_targetRotationY - _rotationY) * 0.03;
      });
    }
  }

  @override
  void dispose() {
    _autoRotateController.dispose();
    _hoverController.dispose();
    super.dispose();
  }

  void _onPanStart(DragStartDetails details) {
    if (!widget.enableRotation) return;
    _isDragging = true;
    _lastPanPosition = details.localPosition;
    _autoRotateController.stop();
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (!widget.enableRotation) return;
    
    final delta = details.localPosition - _lastPanPosition;
    setState(() {
      _rotationY += delta.dx * 0.008;
      _rotationX += delta.dy * 0.008;
      
      _rotationX = _rotationX.clamp(-widget.maxRotationX * 2.5, widget.maxRotationX * 2.5);
      _rotationY = _rotationY.clamp(-widget.maxRotationY * 2.5, widget.maxRotationY * 2.5);
    });
    _lastPanPosition = details.localPosition;
  }

  void _onPanEnd(DragEndDetails details) {
    if (!widget.enableRotation) return;
    _isDragging = false;
    
    if (widget.autoRotate) {
      Future.delayed(const Duration(seconds: 2), () {
        if (!_isDragging && mounted) {
          _autoRotateController.repeat();
        }
      });
    }
  }

  void _onMouseMove(PointerEvent event) {
    if (!widget.enableRotation) return;
    final box = context.findRenderObject() as RenderBox?;
    if (box == null) return;
    
    final localPosition = box.globalToLocal(event.position);
    final center = Offset(box.size.width / 2, box.size.height / 2);
    final delta = localPosition - center;
    
    if (mounted) {
      setState(() {
        _targetRotationY = (delta.dx / box.size.width) * widget.maxRotationY * 2;
        _targetRotationX = (delta.dy / box.size.height) * widget.maxRotationX * 2;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerMove: _onMouseMove,
      child: GestureDetector(
        onPanStart: _onPanStart,
        onPanUpdate: _onPanUpdate,
        onPanEnd: _onPanEnd,
        child: AnimatedBuilder(
          animation: Listenable.merge([_autoRotateController, _hoverController]),
          builder: (context, child) {
            final hoverOffset = sin(_hoverController.value * pi) * 3;
            
            return Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..translate(0.0, hoverOffset, 0.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 25,
                      offset: Offset(0, 15 + hoverOffset.abs()),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: widget.child,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class Parallax3DItem extends StatelessWidget {
  final Widget child;
  final double depth;
  final double rotationX;
  final double rotationY;
  final double maxOffset;

  const Parallax3DItem({
    super.key,
    required this.child,
    required this.depth,
    required this.rotationX,
    required this.rotationY,
    this.maxOffset = 40.0,
  });

  @override
  Widget build(BuildContext context) {
    final offsetX = rotationY * depth * maxOffset;
    final offsetY = rotationX * depth * maxOffset;
    final scale = 0.7 + (depth * 0.3);
    final opacity = 0.5 + (depth * 0.5);

    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()
        ..translate(offsetX, offsetY, depth * 50)
        ..scale(scale),
      child: Opacity(
        opacity: opacity,
        child: child,
      ),
    );
  }
}

class FloatingEmoji3D extends StatefulWidget {
  final String emoji;
  final double size;
  final Offset position;
  final double layerDepth;
  final double rotationX;
  final double rotationY;

  const FloatingEmoji3D({
    super.key,
    required this.emoji,
    required this.size,
    required this.position,
    required this.layerDepth,
    required this.rotationX,
    required this.rotationY,
  });

  @override
  State<FloatingEmoji3D> createState() => _FloatingEmoji3DState();
}

class _FloatingEmoji3DState extends State<FloatingEmoji3D>
    with SingleTickerProviderStateMixin {
  late AnimationController _floatController;
  late Animation<double> _floatAnimation;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();
    final random = Random(widget.emoji.hashCode);
    
    _floatController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 3000 + random.nextInt(1000)),
    )..repeat(reverse: true);

    _floatAnimation = Tween<double>(
      begin: -8,
      end: 8,
    ).animate(CurvedAnimation(
      parent: _floatController,
      curve: Curves.easeInOut,
    ));

    _rotateAnimation = Tween<double>(
      begin: -0.1,
      end: 0.1,
    ).animate(CurvedAnimation(
      parent: _floatController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final offsetX = widget.rotationY * widget.layerDepth * 50;
    final offsetY = widget.rotationX * widget.layerDepth * 50;
    final scale = 0.6 + (widget.layerDepth * 0.4);
    final opacity = 0.4 + (widget.layerDepth * 0.6);

    return AnimatedBuilder(
      animation: _floatController,
      builder: (context, child) {
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..translate(
              widget.position.dx + offsetX,
              widget.position.dy + offsetY + _floatAnimation.value,
              widget.layerDepth * 80,
            )
            ..rotateZ(_rotateAnimation.value)
            ..scale(scale),
          child: Opacity(
            opacity: opacity,
            child: Text(
              widget.emoji,
              style: TextStyle(
                fontSize: widget.size,
              ),
            ),
          ),
        );
      },
    );
  }
}

class SparkleParticle extends StatefulWidget {
  final double size;
  final Offset position;
  final double layerDepth;
  final double rotationY;

  const SparkleParticle({
    super.key,
    required this.size,
    required this.position,
    required this.layerDepth,
    required this.rotationY,
  });

  @override
  State<SparkleParticle> createState() => _SparkleParticleState();
}

class _SparkleParticleState extends State<SparkleParticle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final offsetX = widget.rotationY * widget.layerDepth * 30;
    final opacity = sin(_controller.value * pi * 2) * 0.5 + 0.5;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(widget.position.dx + offsetX, widget.position.dy),
          child: Opacity(
            opacity: opacity * widget.layerDepth,
            child: Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Colors.white,
                    Colors.yellow.withValues(alpha: 0.5),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
