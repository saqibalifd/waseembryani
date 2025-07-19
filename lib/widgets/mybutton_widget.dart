import 'package:flutter/material.dart';

class MybuttonWidget extends StatelessWidget {
  final VoidCallback onTap;
  final String buttonText;
  final Color? color;
  const MybuttonWidget({
    super.key,
    required this.onTap,
    required this.buttonText,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        backgroundColor: color ?? Colors.blue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),

      onPressed: onTap,
      child: Text(
        buttonText,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }
}
