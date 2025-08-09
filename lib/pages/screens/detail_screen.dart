////////////////////////////////////////////////////////////////
///
///
///
library;

import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';
import 'package:waseembrayani/core/models/product_model.dart';
import 'package:waseembrayani/core/utils/consts.dart';
import 'package:waseembrayani/widgets/material_button_widget.dart'
    show MaterialButtonWidget;

class DetailScreen extends StatefulWidget {
  final ProductModel productModel;

  const DetailScreen({super.key, required this.productModel});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            height: size.height,
            width: size.width,
            color: imageBackground,
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back Button
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      child: Center(
                        child: Icon(Icons.arrow_back_ios_new, size: 18),
                      ),
                    ),
                  ),
                  // More Options Icon
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: Center(
                      child: Icon(Icons.more_horiz_outlined, size: 18),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Sheet
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              width: double.infinity,
              height: 370,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Quantity Selector
                    SizedBox(height: 130),
                    Container(
                      height: 50,
                      width: 100,
                      decoration: BoxDecoration(
                        color: red,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Decrease Quantity
                          GestureDetector(
                            onTap: () {
                              if (quantity > 1) {
                                setState(() {
                                  quantity--;
                                });
                              }
                            },
                            child: Icon(Icons.remove, color: Colors.white),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              quantity.toString(),
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          // Increase Quantity
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                quantity++;
                              });
                            },
                            child: Icon(Icons.add, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),

                    // Product Info
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Name and Category
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.productModel.name,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              widget.productModel.categoryName,
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                        // Price
                        Text(
                          'Rs. ${widget.productModel.price}',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 10),

                    // Product Description
                    ReadMoreText(
                      widget.productModel.description,
                      trimLines: 3,
                      colorClickableText: red,
                      trimMode: TrimMode.Line,
                      trimCollapsedText: ' Read more',
                      trimExpandedText: ' Read less',
                      style: TextStyle(fontSize: 12),
                      moreStyle: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: red,
                      ),
                      lessStyle: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Product Main Image in Front
          Positioned(
            top: 130,
            left: 0,
            right: 0,
            child: Hero(
              tag: widget.productModel.id.toString(),
              child: Image.network(
                widget.productModel.imageUrl,
                width: 400,
                height: 200,
                errorBuilder: (context, error, stackTrace) =>
                    Icon(Icons.fastfood, size: 200),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: MaterialButton(
          onPressed: () {
            // Handle add to cart
          },
          color: red,
          height: 60,
          minWidth: double.infinity,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text(
            'Add to Cart',
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
      ),
    );
  }
}









  //  MaterialButtonWidget(
  //                     onTap: () {},
  //                     title: 'Add to Cart',
  //                     height: 50,
  //                     width: 190,
  //                     color: red,
  //                   ),