import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:waseembrayani/core/utils/failure.dart';

class OrderService {
  Future<void> placeOrder({
    required String username,
    required String email,
    required String address,
    required List<Map<String, dynamic>> cartItems,
  }) async {
    final String userId = Supabase.instance.client.auth.currentUser!.id;
    // final OrderModel orderModel = OrderModel(
    //   id: 38923434,
    //   userId: int.parse(userId),
    //   status: 'pending',
    //   username: username,
    //   email: email,
    //   address: address,
    //   products: ,
    //   createdAt: DateTime.now().toIso8601String(),
    // );

    final response = await Supabase.instance.client.from('myorders').insert({
      'username': username,
      'email': email,
      'address': address,
      'products': cartItems,
      'status': 'pending',
      'userId': userId,
      'created_at': DateTime.now().toIso8601String(),
    }).select();

    if (response == null) {
      throw Failure('Order placement failed');
    }
  }
}
