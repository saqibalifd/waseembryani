import 'package:waseembrayani/core/models/product_model.dart';

class OrderModel {
  final String userId;
  final String status;
  final String username;
  final String email;
  final String address;
  final double totalPrice;
  final int quantityOrder;
  final List<ProductModel> products;
  final String createdAt;

  OrderModel({
    required this.userId,
    required this.status,
    required this.username,
    required this.email,
    required this.address,
    required this.totalPrice,
    required this.quantityOrder,
    required List<dynamic> products, // can accept ProductModel or Map
    required this.createdAt,
  }) : products = products.map((e) {
         if (e is ProductModel) return e;
         if (e is Map<String, dynamic>) return ProductModel.fromJson(e);
         throw Exception("Invalid product type: $e");
       }).toList();

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      userId: json['userId'] ?? '',
      status: json['status'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      address: json['address'] ?? '',
      totalPrice: json['totalPrice'] ?? 0.00,
      quantityOrder: json['quantityOrder'] ?? 0,
      products: (json['products'] as List<dynamic>? ?? []),
      createdAt: json['created_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'status': status,
    'username': username,
    'email': email,
    'address': address,
    'totalPrice': totalPrice,
    'products': products.map((e) => e.toJson()).toList(),
    'created_at': createdAt,
  };
}
