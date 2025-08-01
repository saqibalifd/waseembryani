import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final favouriteProvider = ChangeNotifierProvider<FavouriteProvider>(
  (ref) => FavouriteProvider(),
);

class FavouriteProvider extends ChangeNotifier {
  List<String> _favouriteIds = [];
  final SupabaseClient _supabaseClient = Supabase.instance.client;
  List<String> get favorite => _favouriteIds;
  String? get userId => _supabaseClient.auth.currentUser?.id;
  FavouriteProvider() {
    //load the favourite provider
  }

  void reset() {
    _favouriteIds = [];
    notifyListeners();
  }

  //toggle favourite state
  Future<void> toogleFavourite(String productId) async {
    if (_favouriteIds.contains(productId)) {
      _favouriteIds.remove(productId);
      //remove favourite
      _removeFavourite(productId);
    } else {
      _favouriteIds.add(productId);
      //add favourite
      _addFavourite(productId);
    }
    notifyListeners();
  }
  //check if product is favourite

  bool isExist(String productId) {
    return _favouriteIds.contains(productId);
  }
  //add favourite to supabase

  Future<void> _addFavourite(String productId) async {
    if (userId == null) return;
    try {
      await _supabaseClient.from("favourites").insert({
        "user_id": userId,
        "product_id": productId,
      });
    } catch (e) {
      print("Error found in adding to favourite $e");
    }
  }
  //remove favourite from supabase

  Future<void> _removeFavourite(String productId) async {
    if (userId == null) return;
    try {
      await _supabaseClient.from("favourites").delete().match({
        "user_id": userId!,
        "product_id": productId,
      });
    } catch (e) {
      print("Error found in adding to favourite $e");
    }
  }

  Future<void> loadFavourite() async {
    if (userId == null) return;
    try {
      final data = await _supabaseClient
          .from("favourites")
          .select("product_id")
          .eq("user_id", userId!);
      _favouriteIds = data
          .map<String>((row) => row['product_id'] as String)
          .toList();
    } catch (e) {
      print('Error is found in loading favourite : $e');
    }
    notifyListeners();
  }
}
