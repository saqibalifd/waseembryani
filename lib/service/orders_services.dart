import 'package:persistent_shopping_cart/model/cart_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:waseembrayani/core/models/order_item_model.dart';
import 'package:waseembrayani/core/models/order_model.dart';
import 'package:waseembrayani/core/models/product_model.dart';

import 'package:waseembrayani/core/utils/failure.dart';
import 'package:waseembrayani/core/utils/rendom_id_generator_util.dart';

class OrderService {
  final String userId = Supabase.instance.client.auth.currentUser!.id
      .toString();

  Future<void> placeOrder({
    required String username,
    required String email,
    required String address,
    required int quantityOrder,
    required double totalPrice,
    required List<PersistentShoppingCartItem> cartitems,
  }) async {
    final String orderId = RendomIdGeneratorUtil.generateProductId();
    final OrderModel orderModel = OrderModel(
      username: username,
      email: email,
      adress: address,
      status: 'pending',
      userId: userId,
      totalPrice: totalPrice,
      quantity: quantityOrder,
      orderId: orderId,
    );

    final response = await Supabase.instance.client
        .from('orders')
        .insert(orderModel)
        .select();

    for (final item in cartitems) {
      final OrderItemModel orderItemModel = OrderItemModel(
        name: item.productName,
        description: item.productDetails.toString(),
        price: item.unitPrice,
        imageUrl: item.productImages.toString(),
        categoryName: '',
        orderId: orderId,
      );
      await Supabase.instance.client.from('order_items').insert(orderItemModel);
      if (response == null) {
        throw Failure('Order placement failed');
      }
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
