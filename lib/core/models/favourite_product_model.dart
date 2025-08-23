import 'package:waseembrayani/core/models/product_model.dart';

class FavouriteProductModel {
  final String favUserId;
  final int id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String categoryName;
  final bool isPopular;
  final bool isRecommended;

  FavouriteProductModel({
    required this.favUserId,
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.categoryName,
    this.isPopular = false,
    this.isRecommended = false,
  });

  factory FavouriteProductModel.fromJson(Map<String, dynamic> json) {
    return FavouriteProductModel(
      favUserId: json['favUserId'] ?? '',
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
    'favUserId': favUserId,
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
