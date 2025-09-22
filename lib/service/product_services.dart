import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:waseembrayani/models/product_model.dart';

class ProductServices {
  // Supabase client instance for database operations
  final supabaseClient = Supabase.instance.client;

  // ========================= FETCH FOOD PRODUCTS =========================
  // Function to fetch products from 'products' table by category name
  Future<List<ProductModel>> fetchFoodProducts(String categoryName) async {
    try {
      // Step 1: Query Supabase 'products' table where categoryName = provided category
      final response = await supabaseClient
          .from('products')
          .select()
          .eq('categoryName', categoryName);

      // Step 2: Convert the response into a List<ProductModel>
      return (response as List)
          .map((json) => ProductModel.fromJson(json))
          .toList();
    } catch (e) {
      // Step 3: If error occurs, return empty list
      return [];
    }
  }

  // ========================= FETCH POPULAR PRODUCTS =========================
  // Function to fetch popular products from 'products' table by category name
  Future<List<ProductModel>> fetchPopularProducts(String categoryName) async {
    try {
      // Step 1: Query Supabase 'products' where isPopular = true and categoryName = provided category
      final response = await supabaseClient
          .from('products')
          .select()
          .eq('isPopular', true)
          .eq('categoryName', categoryName);

      // Step 2: Convert response to List<ProductModel>
      return (response as List)
          .map((json) => ProductModel.fromJson(json))
          .toList();
    } catch (e) {
      // Step 3: On error, return empty list
      return [];
    }
  }

  // ========================= FETCH ALL PRODUCTS =========================
  // Function to fetch all products from 'products' table
  Future<List<ProductModel>> fetcAllProducts() async {
    try {
      // Step 1: Query Supabase 'products' to get all rows
      final response = await supabaseClient.from('products').select();

      // Step 2: Convert result into list of ProductModel
      return (response as List)
          .map((json) => ProductModel.fromJson(json))
          .toList();
    } catch (e) {
      // Step 3: On failure, return empty list
      return [];
    }
  }

  // ========================= UPLOAD PRODUCT =========================
  // Function to upload (insert) a new product into 'products' table (currently placeholder)
  Future<List<ProductModel>> uploadProduct() async {
    try {
      // Step 1: Logic for inserting a new product into Supabase will go here
      // Example: supabaseClient.from('products').insert(productData);

      // Step 2: For now, return an empty list
      return [];
    } catch (e) {
      // Step 3: On error, return empty list
      return [];
    }
  }
}
