import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:waseembrayani/models/categories_model.dart';
import 'package:waseembrayani/utils/failure.dart';

class CategoriesServices {
  // ========================= FETCH CATEGORIES =========================
  // Function to fetch all categories from Supabase 'category_item' table
  Future<List<CategoryModel>> fetchCategories() async {
    try {
      // Step 1: Query Supabase to select all data from 'category_item' table
      final response = await Supabase.instance.client
          .from('category_item')
          .select();

      // Step 2: Convert the response (List of maps) into List<CategoryModel>
      return (response as List)
          .map((json) => CategoryModel.fromJson(json)) // convert JSON to model
          .toList(); // return as a list
    } catch (e) {
      // Step 3: Handle exceptions using custom SupabaseExceptionHandler
      throw SupabaseExceptionHandler.handle(e);
    }
  }

  // ========================= UPLOAD CATEGORY =========================
  // Function to upload a category (currently placeholder, returns empty list)
  Future<List<CategoryModel>> uploadCategory() async {
    try {
      // Step 1: This is where logic for uploading a category will go
      // Example: Insert category data into Supabase table

      // Step 2: Currently returns empty list as placeholder
      return [];
    } catch (e) {
      // Step 3: Handle exceptions during upload
      throw SupabaseExceptionHandler.handle(e);
    }
  }
}
