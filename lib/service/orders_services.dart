import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:waseembrayani/core/models/order_model.dart';

import 'package:waseembrayani/core/utils/failure.dart';

class OrderService {
  final String userId = Supabase.instance.client.auth.currentUser!.id
      .toString();
  Future<void> placeOrder({
    required String username,
    required String email,
    required String address,
    required int quantityOrder,
    required double totalPrice,
    required List<Map<String, dynamic>> cartItems,
  }) async {
    final OrderModel orderModel = OrderModel(
      userId: userId,
      status: 'pending',
      username: username,
      email: email,
      address: address,
      products: cartItems, // cartItems = List<Map<String, dynamic>>
      quantityOrder: quantityOrder,
      totalPrice: totalPrice,
      createdAt: DateTime.now().toIso8601String(),
    );

    final response = await Supabase.instance.client
        .from('myorders')
        .insert(orderModel)
        .select();

    if (response == null) {
      throw Failure('Order placement failed');
    }
  }

  // this functio will fetch user information from supabase
  Future<List<OrderModel>> fetchOrders() async {
    try {
      final data =
          await Supabase.instance.client
                  .from('myorders')
                  .select()
                  .eq('userId', userId)
              as List<dynamic>;
      print('*********thhis is data *****************${data}');
      return data.map((json) => OrderModel.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }
}
