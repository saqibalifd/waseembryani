import 'package:flutter/material.dart';
import 'package:waseembrayani/core/utils/consts.dart';

class MaterialButtonWidget extends StatelessWidget {
  final Function()? onTap;
  final double? height;
  final double? width;
  final String title;
  final Color? color;
  const MaterialButtonWidget({
    super.key,
    this.onTap,
    this.height,
    this.width,
    required this.title,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onTap,

      color: color ?? red,
      height: height ?? 45,
      minWidth: width ?? 110,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      child: Text(
        title,
        //'Order Now',
        style: TextStyle(fontSize: 14, color: Colors.white),
      ),
    );
  }
}
