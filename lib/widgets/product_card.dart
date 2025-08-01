import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:waseembrayani/core/utils/consts.dart';

class ProductCard extends StatelessWidget {
  final Widget image;
  final String title;
  final String subtitle;
  final String price;
  final String? color;
  final bool? isFavourite;
  final Function()? onFavouriteTap;
  final Function()? onCardTap;
  const ProductCard({
    super.key,
    required this.image,
    required this.title,
    required this.subtitle,
    required this.price,
    this.color,
    this.isFavourite,
    this.onFavouriteTap,
    this.onCardTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: grey1,

      child: Stack(
        children: [
          GestureDetector(
            onTap: onCardTap,
            child: SizedBox(
              width: 200,
              child: Column(
                children: [
                  image,
                  SizedBox(height: 5),
                  Text(
                    title,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      subtitle,
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "\$",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: red,
                        ),
                      ),
                      SizedBox(width: 3),
                      Text(
                        price,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: onFavouriteTap,
            child: Positioned(
              top: 10,
              right: 10,
              child: isFavourite == true
                  ? Icon(Iconsax.heart5, color: red)
                  : Icon(Iconsax.heart),
            ),
          ),
        ],
      ),
    );
  }
}
