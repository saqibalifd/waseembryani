import 'package:flutter/material.dart';
import 'package:waseembrayani/core/utils/consts.dart';

class BannerCard extends StatelessWidget {
  final double? height;
  final Color? color;
  final String? firstText;
  final String? secondText;
  final Color? firstTextColor;
  final Color? secondTextColor;
  final double? fontSize;
  final Widget? button;
  final Widget? image;

  const BannerCard({
    super.key,
    this.height,
    this.color,
    this.firstText,
    this.secondText,
    this.firstTextColor,
    this.secondTextColor,
    this.fontSize,
    this.button,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 150,
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: color ?? orange,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            SizedBox(
              width: 170,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: firstText ?? '',
                          //'The Fatest in Delivery',
                          style: TextStyle(
                            color: firstTextColor ?? Colors.black,
                            fontSize: fontSize ?? 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: secondText ?? '',
                          // ' Food',
                          style: TextStyle(
                            color: secondTextColor ?? red,
                            fontSize: fontSize ?? 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 5),
                  button ?? SizedBox(),
                ],
              ),
            ),
            image ?? SizedBox(),
          ],
        ),
      ),
    );
  }
}
