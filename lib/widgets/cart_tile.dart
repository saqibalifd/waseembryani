import 'package:flutter/material.dart';

class CartTile extends StatelessWidget {
  final String imageUrl;
  final String productName;
  final String price;
  final String quantity;
  final Widget removeIcon;
  final Widget addIcon;

  const CartTile({
    super.key,
    required this.imageUrl,
    required this.productName,
    required this.price,
    required this.quantity,
    required this.removeIcon,
    required this.addIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 15, vertical: 5),
          child: Container(
            padding: EdgeInsets.all(10),
            width: double.infinity,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
            child: Row(
              children: [
                Container(
                  width: 110,
                  height: 90,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                      image: NetworkImage(imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsetsGeometry.only(right: 20),
                        child: Text(
                          productName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 17,
                          ),
                        ),
                      ),

                      Text(
                        "\$ $price",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.pink,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        Positioned(
          right: 20,
          top: 50,
          child: Row(
            children: [
              removeIcon,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(quantity),
              ),
              addIcon,
            ],
          ),
        ),
      ],
    );
  }
}
