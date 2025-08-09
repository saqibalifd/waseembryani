import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:waseembrayani/core/models/product_model.dart';
import 'package:waseembrayani/core/utils/consts.dart';
import 'package:waseembrayani/pages/screens/detail_screen.dart';

class ProductCard extends ConsumerWidget {
  final ProductModel productModel;
  final bool? isFavourite;
  const ProductCard({super.key, required this.productModel, this.isFavourite});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      color: grey1,

      child: Stack(
        children: [
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              PageRouteBuilder(
                transitionDuration: Duration(seconds: 1),
                pageBuilder: (context, animation, secondaryAnimation) =>
                    DetailScreen(productModel: productModel),
              ),
            ),

            child: SizedBox(
              width: 200,
              child: Column(
                children: [
                  Hero(
                    tag: productModel.name,
                    child: Image.network(
                      productModel.imageUrl,
                      height: 160,
                      errorBuilder: (context, error, stackTrace) => Padding(
                        padding: const EdgeInsets.all(40.0),
                        child: Icon(Icons.fastfood, size: 80),
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    productModel.name,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      productModel.categoryName,
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
                        productModel.price.toString(),
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
            onTap: () {
              print('add to favourite tap');
            },
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
