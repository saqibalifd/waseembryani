import 'package:waseembrayani/core/models/product_model.dart';

class OrderModel {
  final int id;
  final int userId;
  final String status;
  final String username;
  final String email;
  final String address;
  final List<ProductModel> products;
  final String createdAt;

  OrderModel({
    required this.id,
    required this.userId,
    required this.status,
    required this.username,
    required this.email,
    required this.address,
    required this.products,
    required this.createdAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] ?? 0,
      userId: json['userId'] ?? 0,
      status: json['status'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      address: json['address'] ?? '',
      products:
          (json['products'] as List<dynamic>?)
              ?.map((e) => ProductModel.fromJson(e))
              .toList() ??
          [],
      createdAt: json['created_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'status': status,
    'username': username,
    'email': email,
    'address': address,
    'products': products.map((e) => e.toJson()).toList(),
    'created_at': createdAt,
  };
}
