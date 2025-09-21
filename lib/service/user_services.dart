import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:waseembrayani/core/models/user_model.dart';
import 'package:waseembrayani/core/utils/failure.dart';

class UserServices {
  final supabase = Supabase.instance.client.from('users');

  // this function will store user information on supabase
  Future<void> storeUserInfo({
    required String email,
    required String name,
    required String adress,
    required AuthResponse res,
    required BuildContext context,
  }) async {
    try {
      UserModel userModel = UserModel(
        name: name,
        email: email,
        userid: res.user!.id,
        profileImage: '',
        adress: adress,
        isAdmin: false,
      );

      await supabase.insert(userModel.toJson());
    } catch (e) {
      throw SupabaseExceptionHandler.handle(e);
    }
  }

  // this functio will fetch user information from supabase
  Future<List<UserModel>> fetchUserInfo() async {
    try {
      final String userId = Supabase.instance.client.auth.currentUser!.id
          .toString();
      final data =
          await Supabase.instance.client
                  .from('users')
                  .select()
                  .eq('userid', userId)
              as List<dynamic>;

      return data.map((json) => UserModel.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }

  // this function will update user information
  Future updateUserInfo(String name, String address) async {
    try {
      final String userId = Supabase.instance.client.auth.currentUser!.id
          .toString();
      await supabase
          .update({'name': name, 'adress': address})
          .eq('userid', userId);
    } catch (e) {
      throw SupabaseExceptionHandler.handle(e);
    }
  }

  // this function will delete user information
  Future deleteUserInfo() async {
    try {
      final String userId = Supabase.instance.client.auth.currentUser!.id
          .toString();
      await supabase.delete().eq('userid', userId);
    } catch (e) {
      throw SupabaseExceptionHandler.handle(e);
    }
  }
}
