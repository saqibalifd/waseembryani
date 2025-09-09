import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:waseembrayani/core/models/categories_model.dart';
import 'package:waseembrayani/core/utils/failure.dart';

class CategoriesServices {
  Future<List<CategoryModel>> fetchCategories() async {
    try {
      final response = await Supabase.instance.client
          .from('category_item')
          .select();
      return (response as List)
          .map((json) => CategoryModel.fromJson(json))
          .toList();
    } catch (e) {
      throw SupabaseExceptionHandler.handle(e);
    }
  }

  Future<List<CategoryModel>> uploadCategory() async {
    try {
      // at there we upload category
      return [];
    } catch (e) {
      throw SupabaseExceptionHandler.handle(e);
    }
  }
}
