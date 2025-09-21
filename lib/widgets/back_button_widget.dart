import 'package:flutter/material.dart';
import 'package:waseembrayani/core/utils/consts.dart';

class BackButtonWidget extends StatelessWidget {
  final VoidCallback onTap;
  const BackButtonWidget({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: red.withValues(alpha: .1),
        ),
        child: const Center(child: Icon(Icons.arrow_back_ios_new, size: 18)),
      ),
    );
  }
}
