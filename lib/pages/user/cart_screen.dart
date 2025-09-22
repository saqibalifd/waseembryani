import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:iconsax/iconsax.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:persistent_shopping_cart/model/cart_model.dart';
import 'package:persistent_shopping_cart/persistent_shopping_cart.dart';
import 'package:waseembrayani/models/product_model.dart';
import 'package:waseembrayani/models/user_model.dart';
import 'package:waseembrayani/pages/user/app_main_screen.dart';
import 'package:waseembrayani/pages/user/detail_screen.dart';
import 'package:waseembrayani/service/orders_services.dart';
import 'package:waseembrayani/service/user_services.dart';
import 'package:waseembrayani/utils/consts.dart';
import 'package:waseembrayani/utils/failure.dart';
import 'package:waseembrayani/widgets/cart_tile.dart';
import 'package:waseembrayani/widgets/material_button_widget.dart';
import 'package:waseembrayani/utils/snackbar.dart';

// --------------------- CART SCREEN ---------------------
class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // Step 1: Local variables
  double totalPrice = PersistentShoppingCart().calculateTotalPrice();
  final int totalProduct = 0;
  final UserServices _userServices = UserServices();
  final OrderService _ordersServices = OrderService();

  // Step 2: Controllers for bottom sheet form fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _adressController = TextEditingController();
  final TextEditingController _additionlNotesController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    // Step 3: Load user info (name, email, address) from API
    _loadUserInfo();
  }

  // Step 4: Fetch user info and prefill form fields
  void _loadUserInfo() async {
    final List<UserModel> users = await _userServices.fetchUserInfo();
    if (users.isNotEmpty) {
      final userinfo = users.first;
      setState(() {
        _nameController.text = userinfo.name ?? "";
        _emailController.text = userinfo.email ?? "";
        _adressController.text = userinfo.adress ?? "";
      });
    }
  }

  // Step 5: Confirm order API call
  Future<void> _confirmOrder(
    List<PersistentShoppingCartItem> cartItems,
    int totalItems,
    double totalPrice,
  ) async {
    try {
      // Show loading animation
      EasyLoading.show(
        maskType: EasyLoadingMaskType.black,
        indicator: LoadingAnimationWidget.stretchedDots(
          size: 30,
          color: Colors.white,
        ),
      );

      // Call order API
      await _ordersServices.placeOrder(
        username: _nameController.text.trim(),
        email: _emailController.text.trim(),
        address: _adressController.text.trim(),
        cartitems: cartItems,
        quantityOrder: totalItems,
        totalPrice: totalPrice,
      );

      // Clear cart and redirect to Home
      Navigator.pop(context);
      PersistentShoppingCart().clearCart();
      setState(() {
        totalPrice = PersistentShoppingCart().calculateTotalPrice();
      });
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AppMainScreen(getIndex: 0)),
      );

      // Show success snackbar
      showSnackBar(context, '🎉 Order Placed Successfully!');
    } catch (e) {
      // Handle API or other errors
      if (e is Failure) {
        showSnackBar(context, e.message.toString());
      } else {
        showSnackBar(context, 'Unexpected error');
      }
    } finally {
      // Hide loading
      EasyLoading.dismiss();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // Step 6: AppBar
      appBar: AppBar(
        centerTitle: true,
        forceMaterialTransparency: true,
        automaticallyImplyLeading: false,
        title: const Text(
          "Cart Screen",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      // Step 7: Main UI body
      body: Column(
        children: [
          // Cart Items list (managed by persistent_shopping_cart package)
          PersistentShoppingCart().showCartItems(
            cartItemsBuilder:
                (
                  BuildContext context,
                  List<PersistentShoppingCartItem> cartItems,
                ) {
                  if (cartItems.isEmpty) {
                    return const SizedBox();
                  }
                  return Expanded(
                    child: ListView.builder(
                      itemCount: cartItems.length,
                      itemBuilder: (context, index) {
                        final item = cartItems[index];

                        // Step 8: Each cart item as a SwipeActionCell (delete supported)
                        return InkWell(
                          onTap: () {
                            // Navigate to product detail page on tap
                            final ProductModel productModel = ProductModel(
                              id: int.parse(item.productId),
                              name: item.productName,
                              description: item.productDescription.toString(),
                              price: item.unitPrice,
                              imageUrl: item.productImages.toString(),
                              categoryName: '',
                              isPopular: false,
                              isRecommended: false,
                            );
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    DetailScreen(productModel: productModel),
                              ),
                            );
                          },
                          child: SwipeActionCell(
                            // Delete option on swipe
                            trailingActions: <SwipeAction>[
                              SwipeAction(
                                color: Colors.transparent,
                                closeOnTap: true,
                                performsFirstActionWithFullSwipe: true,
                                icon: Icon(Icons.delete, color: red, size: 35),
                                onTap: (CompletionHandler handler) async {
                                  await PersistentShoppingCart().removeFromCart(
                                    item.productId,
                                  );
                                  setState(() {
                                    totalPrice = PersistentShoppingCart()
                                        .calculateTotalPrice();
                                  });
                                },
                              ),
                            ],
                            key: ObjectKey(item.productId),
                            // Step 9: CartTile widget (with quantity add/remove)
                            child: CartTile(
                              imageUrl: item.productThumbnail.toString(),
                              productName: item.productName,
                              price: item.unitPrice.toStringAsFixed(0),
                              quantity: item.quantity.toString(),
                              addIcon: InkWell(
                                onTap: () async {
                                  await PersistentShoppingCart()
                                      .incrementCartItemQuantity(
                                        item.productId,
                                      );
                                  setState(() {
                                    totalPrice = PersistentShoppingCart()
                                        .calculateTotalPrice();
                                  });
                                },
                                child: const Icon(Icons.add),
                              ),
                              removeIcon: InkWell(
                                onTap: () async {
                                  await PersistentShoppingCart()
                                      .decrementCartItemQuantity(
                                        item.productId,
                                      );
                                  setState(() {
                                    totalPrice = PersistentShoppingCart()
                                        .calculateTotalPrice();
                                  });
                                },
                                child: const Icon(Icons.remove),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
          ),

          // Step 10: Payment details & Place Order button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: paymentDetail(
              totalPrice.toString(),
              onSubmitTap: () async {
                final Map<String, dynamic> cartData = PersistentShoppingCart()
                    .getCartData();

                final List<PersistentShoppingCartItem> cartItems =
                    List<PersistentShoppingCartItem>.from(
                      cartData['cartItems'] ?? <PersistentShoppingCartItem>[],
                    );

                if (cartItems.isEmpty) {
                  showSnackBar(
                    context,
                    'Your cart is empty. Add items to place an order.',
                  );
                } else {
                  _showOrderBottomSheet(
                    context,
                    cartItems,
                    cartItems.length,
                    totalPrice,
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  // --------------------- Bottom Sheet ---------------------
  void _showOrderBottomSheet(
    BuildContext context,
    List<PersistentShoppingCartItem> cartItems,
    int totalItems,
    double totalPrice,
  ) {
    final _formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.8,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          builder: (_, controller) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: SingleChildScrollView(
                controller: controller,
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Handle bar at top of sheet
                      Center(
                        child: Container(
                          height: 5,
                          width: 50,
                          margin: const EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                      const Text(
                        "Place Your Order",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Step 11: Input fields
                      _buildField("Name", Iconsax.user, _nameController),
                      _buildField(
                        "Email",
                        Iconsax.sms,
                        _emailController,
                        keyboard: TextInputType.emailAddress,
                      ),
                      _buildField(
                        "Phone",
                        Iconsax.call,
                        _phoneController,
                        keyboard: TextInputType.phone,
                      ),
                      _buildField("Address", Iconsax.home, _adressController),
                      _buildField(
                        "Additional Notes",
                        Iconsax.note,
                        _additionlNotesController,
                      ),
                      const SizedBox(height: 30),
                      // Confirm Order button
                      MaterialButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            await _confirmOrder(
                              cartItems,
                              totalItems,
                              totalPrice,
                            );
                          }
                        },
                        color: red,
                        height: 60,
                        minWidth: double.infinity,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Text(
                          'Confirm Order',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // --------------------- Reusable Input Field ---------------------
  Widget _buildField(
    String hint,
    IconData icon,
    TextEditingController controller, {
    TextInputType keyboard = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboard,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Please enter $hint";
          }
          return null;
        },
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.black54),
          hintText: hint,
          filled: true,
          fillColor: Colors.grey[100],
          contentPadding: const EdgeInsets.symmetric(
            vertical: 18,
            horizontal: 15,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}

// --------------------- Payment Summary Widget ---------------------
Widget paymentDetail(
  String total, {
  String shippingCharges = '0',
  String discount = '0',
  Function()? onSubmitTap,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: SizedBox(
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
          const SizedBox(height: 20),
          MaterialButtonWidget(
            width: 200,
            onTap: onSubmitTap,
            title: 'Place Order',
          ),
        ],
      ),
    ),
  );
}

// --------------------- Helper Row Widget ---------------------
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
