import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:waseembrayani/core/models/product_model.dart';
import 'package:waseembrayani/core/utils/consts.dart';
import 'package:waseembrayani/widgets/snackbar.dart';

class DetailScreen extends StatefulWidget {
  final ProductModel productModel;

  const DetailScreen({super.key, required this.productModel});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  int quantity = 1;
  bool isLoading = false;

  Future<void> addToCart() async {
    final session = Supabase.instance.client.auth.currentSession;
    if (session == null) {
      showSnackBar(context, 'Please log in first');
      return;
    }

    setState(() => isLoading = true);

    try {
      final String userId = session.user.id;

      // Make sure these column names match your Supabase 'cart' table
      final cartData = {
        'cartId': 7,
        'cartUserId': userId,
        'quantity': quantity,
        'id': widget.productModel.id,
        'name': widget.productModel.name,
        'description': widget.productModel.description,
        'price': 500,
        'imageUrl': widget.productModel.imageUrl,
        'categoryName': widget.productModel.categoryName,
        'isPopular': widget.productModel.isPopular,
        'isRecommended': widget.productModel.isRecommended,
      };

      final response = await Supabase.instance.client
          .from('cart')
          .insert(cartData);

      if (response.error != null) {
        print('Error inserting: ${response.error!.message}');
        showSnackBar(context, 'Failed: ${response.error!.message}');
      } else {
        showSnackBar(context, 'Added to cart successfully');
      }
    } catch (e) {
      showSnackBar(context, 'Failed to add to cart: $e');
      print(e.toString());
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Background
          Container(
            height: size.height,
            width: size.width,
            color: imageBackground,
          ),

          // Top Bar
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
                      child: const Center(
                        child: Icon(Icons.arrow_back_ios_new, size: 18),
                      ),
                    ),
                  ),
                  // More Icon
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: const Center(
                      child: Icon(Icons.more_horiz_outlined, size: 18),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Product Info Sheet
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

                    // Quantity Selector
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
                            child: const Icon(
                              Icons.remove,
                              color: Colors.white,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              quantity.toString(),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          // Increase Quantity
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

                    // Product Name & Price
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Name & Category
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
                        // Price
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

                    // Description
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

          // Product Image
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
                    const Icon(Icons.fastfood, size: 200),
              ),
            ),
          ),
        ],
      ),

      // Add to Cart Button
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: MaterialButton(
          onPressed: () {
            addToCart();
          },
          color: red,
          height: 60,
          minWidth: double.infinity,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          child: isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text(
                  'Add to Cart',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
        ),
      ),
    );
  }
}
