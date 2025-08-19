import 'package:flutter/material.dart';

enum ButtonSize { small, medium, large }

enum ButtonColor { red, blue }

class CustomButton extends StatefulWidget {
  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.color,
    required this.size,
    required this.textSize,
    required this.topTextPadding,
    required this.scale
  });

  final String text;
  final VoidCallback onPressed;
  final ButtonColor color;
  final ButtonSize size;
  final double textSize;
  final double topTextPadding;
  final double scale;
  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> with SingleTickerProviderStateMixin {

  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  double _initialScale = 1;
  double _tappedScale = 0.9;
  Duration _animationDuration = const Duration(milliseconds: 200);


  @override
  void initState(){
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: _animationDuration,
    );

    _scaleAnimation = Tween<double>(
      begin: _initialScale,
      end: _tappedScale,
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

  Future<void> _handleTap() async{
    await _animationController.forward();
    await _animationController.reverse();
    widget.onPressed();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child){
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Image.asset(
                    'assets/images/general_buttons/${widget.color.name}_${widget.size.name}.png',
                    scale: widget.scale,
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: widget.topTextPadding),
                    child: Text(
                      widget.text,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: widget.textSize,
                        fontFamily: 'ProtestStrike',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      ),
    );
  }
}


