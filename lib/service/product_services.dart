import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:waseembrayani/core/models/product_model.dart';

class ProductServices {
  final supabaseClient = Supabase.instance.client;
  Future<List<ProductModel>> fetchFoodProducts(String categoryName) async {
    try {
      final response = await supabaseClient
          .from('products')
          .select()
          .eq('categoryName', categoryName);
      return (response as List)
          .map((json) => ProductModel.fromJson(json))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<ProductModel>> fetchPopularProducts(String categoryName) async {
    try {
      final response = await supabaseClient
          .from('products')
          .select()
          .eq('isPopular', true)
          .eq('categoryName', categoryName);
      return (response as List)
          .map((json) => ProductModel.fromJson(json))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<ProductModel>> fetcAllProducts() async {
    try {
      final response = await supabaseClient.from('products').select();
      return (response as List)
          .map((json) => ProductModel.fromJson(json))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<ProductModel>> uploadProduct() async {
    try {
      //there we code for upload product
      return [];
    } catch (e) {
      return [];
    }
  }
}
