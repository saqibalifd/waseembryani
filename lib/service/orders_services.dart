import 'package:persistent_shopping_cart/model/cart_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:waseembrayani/models/order_item_model.dart';
import 'package:waseembrayani/models/order_model.dart';
import 'package:waseembrayani/utils/failure.dart';
import 'package:waseembrayani/utils/rendom_id_generator_util.dart';

class OrderService {
  // Store the logged-in user's ID from Supabase authentication
  final String userId = Supabase.instance.client.auth.currentUser!.id
      .toString();

  // ========================= PLACE ORDER =========================
  // Function to place a new order and save it in Supabase
  Future<void> placeOrder({
    required String username,
    required String email,
    required String address,
    required int quantityOrder,
    required double totalPrice,
    required List<PersistentShoppingCartItem> cartitems,
  }) async {
    // Step 1: Generate a unique order ID using utility function
    final String orderId = RendomIdGeneratorUtil.generateProductId();

    // Step 2: Create an OrderModel object with order details
    final OrderModel orderModel = OrderModel(
      username: username,
      email: email,
      adress: address,
      status: 'pending', // default status when placing order
      userId: userId,
      totalPrice: totalPrice,
      quantity: quantityOrder,
      orderId: orderId,
    );

    // Step 3: Insert order into 'orders' table in Supabase
    final response = await Supabase.instance.client
        .from('orders')
        .insert(orderModel)
        .select();

    // Step 4: For each cart item, create OrderItemModel and insert into 'order_items' table
    for (final item in cartitems) {
      final OrderItemModel orderItemModel = OrderItemModel(
        name: item.productName,
        description: item.productDetails.toString(),
        price: item.unitPrice,
        imageUrl: item.productThumbnail.toString(),
        categoryName: '', // category can be set if available
        orderId: orderId,
        userId: userId,
        status: 'pending', // item also starts as pending
      );

      // Insert order item into 'order_items' table
      await Supabase.instance.client.from('order_items').insert(orderItemModel);

      // Step 5: If order insertion fails, throw Failure
      if (response == null) {
        throw Failure('Order placement failed');
      }
    }
  }

  // ========================= FETCH ORDERS =========================
  // Function to fetch all orders for the current logged-in user
  Future<List<OrderItemModel>> fetchOrders() async {
    try {
      // Step 1: Fetch all rows from 'order_items' table where userId = current user
      final data =
          await Supabase.instance.client
                  .from('order_items')
                  .select()
                  .eq('userId', userId)
              as List<dynamic>;

      // Debug print to verify fetched data
      print('*********this is data *****************${data}');

      // Step 2: Convert fetched JSON into a list of OrderItemModel objects
      return data.map((json) => OrderItemModel.fromJson(json)).toList();
    } catch (e) {
      // Step 3: On failure, return empty list
      return [];
    }
  }
}
