import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:persistent_shopping_cart/model/cart_model.dart';
import 'package:persistent_shopping_cart/persistent_shopping_cart.dart';
import 'package:readmore/readmore.dart';
import 'package:waseembrayani/models/product_model.dart';
import 'package:waseembrayani/pages/user/app_main_screen.dart';
import 'package:waseembrayani/utils/consts.dart';
import 'package:waseembrayani/widgets/back_button_widget.dart';
import 'package:waseembrayani/utils/snackbar.dart';

class DetailScreen extends StatefulWidget {
  final ProductModel productModel;

  const DetailScreen({super.key, required this.productModel});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  // keep track of product quantity
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size; // screen size

    return Scaffold(
      body: Stack(
        children: [
          // 🔹 Background container for the whole screen
          Container(
            height: size.height,
            width: size.width,
            color: imageBackground,
          ),

          // 🔹 Top bar with back button and cart icon
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // back button widget
                  BackButtonWidget(onTap: () => Navigator.pop(context)),

                  // cart icon with badge showing number of items
                  Stack(
                    children: [
                      GestureDetector(
                        onTap: () {
                          // navigate to cart screen inside AppMainScreen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AppMainScreen(getIndex: 3),
                            ),
                          );
                        },
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: red.withValues(alpha: .1),
                          ),
                          child: const Center(
                            child: Icon(Iconsax.shopping_cart),
                          ),
                        ),
                      ),
                      // badge that displays cart item count
                      Positioned(
                        right: 0,
                        top: 0,
                        child: PersistentShoppingCart().showCartItems(
                          cartItemsBuilder: (context, cartItems) {
                            if (cartItems.isEmpty) return SizedBox.shrink();
                            return CircleAvatar(
                              radius: 8,
                              backgroundColor: red,
                              child: Text(
                                cartItems.length.toString(),
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.white,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // 🔹 Bottom sheet with product details
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              width: double.infinity,
              height: 370,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 130),

                    // 🔹 Quantity selector (increment/decrement)
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
                          // decrease quantity
                          GestureDetector(
                            onTap: () {
                              if (quantity > 1) {
                                setState(() {
                                  quantity--;
                                });
                              }
                            },
                            child: const Icon(
                              Icons.remove,
                              color: Colors.white,
                            ),
                          ),
                          // display current quantity
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              quantity.toString(),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          // increase quantity
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                quantity++;
                              });
                            },
                            child: const Icon(Icons.add, color: Colors.white),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // 🔹 Product name, category, and price
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // left: product name + category
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.productModel.name,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.productModel.categoryName,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                        // right: product price
                        Text(
                          'Rs. ${widget.productModel.price}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    // 🔹 Product description with "Read more"
                    ReadMoreText(
                      widget.productModel.description,
                      trimLines: 3,
                      colorClickableText: red,
                      trimMode: TrimMode.Line,
                      trimCollapsedText: ' Read more',
                      trimExpandedText: ' Read less',
                      style: const TextStyle(fontSize: 12),
                      moreStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: red,
                      ),
                      lessStyle: const TextStyle(
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

          // 🔹 Product image (above the details sheet)
          Positioned(
            top: 130,
            left: 0,
            right: 0,
            child: Image.network(
              widget.productModel.imageUrl,
              width: 400,
              height: 200,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.fastfood, size: 200),
            ),
          ),
        ],
      ),

      // 🔹 Add to Cart button at bottom
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: SizedBox(
          width: double.infinity,
          height: 60,
          child: FloatingActionButton.extended(
            onPressed: () async {
              // add product with quantity to persistent cart
              await PersistentShoppingCart().addToCart(
                PersistentShoppingCartItem(
                  productId: widget.productModel.id.toString(),
                  productName: widget.productModel.name,
                  unitPrice: widget.productModel.price,
                  quantity: quantity,
                  productDescription: widget.productModel.description,
                  productThumbnail: widget.productModel.imageUrl,
                ),
              );
              // show snackbar after adding
              showSnackBar(context, 'Added to your cart!');
            },
            backgroundColor: red,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            label: const Text(
              'Add to Cart',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
