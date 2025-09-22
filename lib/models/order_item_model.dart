class OrderItemModel {
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String categoryName;
  final bool isPopular;
  final bool isRecommended;
  final String orderId;
  final String userId;
  final String status;

  OrderItemModel({
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.categoryName,
    this.isPopular = false,
    this.isRecommended = false,
    required this.orderId,
    required this.userId,
    required this.status,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      imageUrl: json['imageUrl'] ?? '',
      categoryName: json['categoryName']?.toString() ?? '',
      isPopular: json['isPopular'] ?? false,
      isRecommended: json['isRecommended'] ?? false,
      orderId: json['orderId'] ?? '',
      userId: json['userId'] ?? '',
      status: json['status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'description': description,
    'price': price,
    'imageUrl': imageUrl,
    'categoryName': categoryName,
    'isPopular': isPopular,
    'isRecommended': isRecommended,
    'orderId': orderId,
    'userId': userId,
    'status': status,
  };
}
