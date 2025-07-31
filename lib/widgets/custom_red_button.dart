import 'package:flutter/material.dart';

class CustomRedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const CustomRedButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all(Colors.white),
        backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (states.contains(MaterialState.hovered)) {
            return Color(0xFFCC1F4A);
          }
          return Color(0xFFA6193C);
        }),
        elevation: MaterialStateProperty.all(4),
        shadowColor: MaterialStateProperty.all(Colors.black26),
        padding: MaterialStateProperty.all(
          EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
      ),
      onPressed: onPressed,
      child: Text(text),
    );
  }
}
