import 'package:flutter/material.dart';

enum VisualChestStatus { opened, closed }

enum LogicChestStatus { unlocked, locked }

class ChestButton extends StatefulWidget {
  const ChestButton({
    super.key,
    required this.onPressed,
    required this.visualStatus,
    required this.logicStatus,
    this.scale = 1.0,
  });

  final VoidCallback onPressed;
  final VisualChestStatus visualStatus;
  final LogicChestStatus logicStatus;
  final double scale;

  @override
  State<ChestButton> createState() => _ChestButtonState();
}

class _ChestButtonState extends State<ChestButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  static const double _initialScaleFactor = 1.0;
  static const double _tappedScaleFactor = 0.9;
  static const Duration _animationDuration = Duration(milliseconds: 150);

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: _animationDuration,
    );

    _scaleAnimation = Tween<double>(
      begin: _initialScaleFactor,
      end: _tappedScaleFactor,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _handleTap() async {
    await _animationController.forward();
    await _animationController.reverse();
    widget.onPressed();
  }

  String _getChestImageName() {
    switch (widget.visualStatus) {
      case VisualChestStatus.closed:
        return 'closed_chest';
      case VisualChestStatus.opened:
        return 'opened_chest';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value * widget.scale,
            child: child,
          );
        },
        child: Image.asset(
          'assets/images/daily_bonus_screen/${_getChestImageName()}.png',
          errorBuilder: (context, error, stackTrace) {
            print(
                'Error loading image for ChestButton: assets/images/daily_bonus_screen/${_getChestImageName()}.png. Error: $error');
            return Container(
              width: 50 * widget.scale,
              height: 50 * widget.scale,
              color: Colors.grey,
              child: const Icon(Icons.broken_image, color: Colors.red),
            );
          },
        ),
      ),
    );
  }
}
