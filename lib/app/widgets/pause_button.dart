import 'package:flutter/material.dart';

class PauseButton extends StatefulWidget{
  const PauseButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  State<PauseButton> createState() => _PauseButtonState();
}

class _PauseButtonState extends State<PauseButton>{

  @override
  Widget build(BuildContext context){
    return GestureDetector(
      onTap: widget.onPressed,
      child: Image.asset('assets/images/game_screen/pause_icon.png'),
    );
  }
}