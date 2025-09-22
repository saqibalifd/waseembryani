class OrderModel {
  final String username;
  final String email;
  final String adress;
  final String status;
  final String userId;
  final double totalPrice;
  final int quantity;
  final String orderId;

  OrderModel({
    required this.username,
    required this.email,
    required this.adress,
    required this.status,
    required this.userId,
    required this.totalPrice,
    required this.quantity,
    required this.orderId,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      adress: json['adress'] ?? '',
      status: json['status'] ?? '',
      userId: json['userId'] ?? '',
      totalPrice: (json['totalPrice'] != null)
          ? (json['totalPrice'] as num).toDouble()
          : 0.0,
      quantity: json['quantity'] ?? 0,
      orderId: json['orderId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'username': username,
    'email': email,
    'adress': adress,
    'status': status,
    'userId': userId,
    'totalPrice': totalPrice,
    'quantity': quantity,
    'orderId': orderId,
  };
}
