import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:waseembrayani/core/utils/failure.dart';

class OrderService {
  Future<void> placeOrder({
    required String username,
    required String email,
    required String address,
    required List<Map<String, dynamic>> cartItems,
  }) async {
    final response = await Supabase.instance.client.from('myorders').insert({
      'username': username,
      'email': email,
      'address': address,
      'products': cartItems,
      'status': 'pending',
      'created_at': DateTime.now().toIso8601String(),
    }).select();

    if (response == null) {
      throw Failure('Order placement failed');
    }
  }
}
