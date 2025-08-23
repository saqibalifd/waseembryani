import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:waseembrayani/core/models/cart_model.dart';
import 'package:waseembrayani/core/models/product_model.dart';
import 'package:waseembrayani/core/utils/consts.dart';
import 'package:waseembrayani/pages/screens/detail_screen.dart';
import 'package:waseembrayani/widgets/cart_tile.dart';
import 'package:waseembrayani/widgets/material_button_widget.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late Future<List<CartModel>> futureCartProducts = Future.value([]);
  late int grandTotal;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() {
    setState(() {
      futureCartProducts = fetchCartProducts();
    });
  }

  Future<List<CartModel>> fetchCartProducts() async {
    try {
      final userId = Supabase.instance.client.auth.currentUser?.id ?? '';
      if (userId.isEmpty) return [];

      final response = await Supabase.instance.client
          .from('cart')
          .select()
          .eq('cartUserId', userId);

      if (response is List) {
        return response.map((json) => CartModel.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      print('Error in fetching products: $e');
      return [];
    }
  }

  Future<void> increaseQuantity({
    required int cartId,
    required int currentQuantity,
  }) async {
    try {
      final updatedQuantity = currentQuantity + 1;

      await Supabase.instance.client
          .from('cart')
          .update({'quantity': updatedQuantity})
          .eq('cartId', cartId);

      print('Quantity increased to $updatedQuantity');
      _initializeData();
    } catch (e) {
      print('Error increasing quantity: $e');
    }
  }

  Future<void> decreaseQuantity({
    required int cartId,
    required int currentQuantity,
  }) async {
    try {
      if (currentQuantity > 1) {
        final updatedQuantity = currentQuantity - 1;

        await Supabase.instance.client
            .from('cart')
            .update({'quantity': updatedQuantity})
            .eq('cartId', cartId);

        print('Quantity decreased to $updatedQuantity');
        _initializeData();
      } else {
        print('Cannot decrease below 1');
      }
    } catch (e) {
      print('Error decreasing quantity: $e');
    }
  }

  Future placeOrder() async {
    try {
      //plasce order
    } catch (e) {
      print('Error in fetching user info : $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        forceMaterialTransparency: true,
        title: const Text(
          "Cart Screen",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder<List<CartModel>>(
        future: futureCartProducts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError ||
              !snapshot.hasData ||
              snapshot.data!.isEmpty) {
            return const Center(child: Text('Something went wrong'));
          }

          return Column(
            children: [
              SizedBox(
                height: 340,
                child: ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final data = snapshot.data![index];
                    final price = data.quantity * data.price;

                    return InkWell(
                      onTap: () {
                        final ProductModel productModel = ProductModel(
                          id: data.id,
                          name: data.name,
                          description: data.description,
                          price: data.price,
                          imageUrl: data.imageUrl,
                          categoryName: data.categoryName,
                        );

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                DetailScreen(productModel: productModel),
                          ),
                        );
                      },
                      child: CartTile(
                        imageUrl: data.imageUrl,
                        productName: data.name,
                        price: price.toStringAsFixed(2),
                        quantity: data.quantity.toString(),
                        addIcon: InkWell(
                          onTap: () => increaseQuantity(
                            cartId: data.cartId ?? 0,
                            currentQuantity: data.quantity,
                          ),
                          child: const Icon(Icons.add),
                        ),
                        removeIcon: InkWell(
                          onTap: () => decreaseQuantity(
                            cartId: data.cartId ?? 0,
                            currentQuantity: data.quantity,
                          ),
                          child: const Icon(Icons.remove),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: paymentDetail(
                  onSubmitTap: () => placeOrder(),
                  snapshot.data!
                      .fold<double>(
                        0,
                        (sum, item) => sum + (item.quantity * item.price),
                      )
                      .toStringAsFixed(2),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

Widget paymentDetail(
  String total, {
  String shippingCharges = '0',
  String discount = '0',
  Function()? onSubmitTap,
}) {
  return SizedBox(
    height: 220,
    width: double.maxFinite,
    child: Column(
      children: [
        _buildRow('Total', total),
        const SizedBox(height: 10),
        _buildRow('Shipping Charge', shippingCharges),
        const SizedBox(height: 10),
        _buildRow('Discount', discount),
        const SizedBox(height: 10),
        const Divider(),
        const SizedBox(height: 10),
        _buildRow('Grand Total', total, isGrand: true),
        SizedBox(height: 20),
        MaterialButtonWidget(
          width: 200,
          onTap: () => onSubmitTap,
          title: 'Place Order',
        ),
      ],
    ),
  );
}

Widget _buildRow(String title, String value, {bool isGrand = false}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        title,
        style: TextStyle(
          fontSize: isGrand ? 18 : 16,
          fontWeight: FontWeight.w500,
          color: isGrand ? red : null,
        ),
      ),
      Text(
        '\$$value',
        style: TextStyle(
          fontSize: isGrand ? 18 : 16,
          fontWeight: FontWeight.w500,
          color: isGrand ? red : null,
        ),
      ),
    ],
  );
}
