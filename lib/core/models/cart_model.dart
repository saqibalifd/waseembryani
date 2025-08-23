class CartModel {
  final int? cartId;
  final String cartUserId;
  final int quantity;
  final int id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String categoryName;
  final bool isPopular;
  final bool isRecommended;

  CartModel({
    this.cartId,
    required this.cartUserId,
    required this.quantity,
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.categoryName,
    this.isPopular = false,
    this.isRecommended = false,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      cartId: json['cartId'] != null ? json['cartId'] as int : null,
      cartUserId: json['cartUserId'] ?? '',
      quantity: json['quantity'] ?? 0,
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      imageUrl: json['imageUrl'] ?? '',
      categoryName: json['categoryName']?.toString() ?? '',
      isPopular: json['isPopular'] ?? false,
      isRecommended: json['isRecommended'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'cartId': cartId,
    'cartUserId': cartUserId,
    'quantity': quantity,
    'id': id,
    'name': name,
    'description': description,
    'price': price,
    'imageUrl': imageUrl,
    'categoryName': categoryName,
    'isPopular': isPopular,
    'isRecommended': isRecommended,
  };
}
