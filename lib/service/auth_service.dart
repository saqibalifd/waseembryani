import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:waseembrayani/core/utils/failure.dart';
import 'package:waseembrayani/service/user_services.dart';
import 'package:waseembrayani/widgets/snackbar.dart';

class AuthService {
  final supabaseClient = Supabase.instance.client;
  UserServices userServices = UserServices();
  //signup function
  Future<void> signUp({
    required BuildContext context,
    required String email,
    required String password,
    required String name,
    required String adress,
  }) async {
    try {
      final AuthResponse res = await Supabase.instance.client.auth.signUp(
        email: email,
        password: password,
      );
      if (res.user == null) {
        return showSnackBar(context, 'User registration failed');
      } else {
        await userServices.storeUserInfo(
          email: email,
          name: name,
          adress: adress,
          res: res,
          context: context,
        );
      }
    } catch (e) {
      throw SupabaseExceptionHandler.handle(e);
    }
  }

  // login function
  Future<void> login(
    BuildContext context,
    String email,
    String password,
  ) async {
    try {
      final response = await supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw Failure('Login Failed', code: "NO_USER");
      }
    } catch (e) {
      throw SupabaseExceptionHandler.handle(e);
    }
  }

  //logout function
  Future<void> logout(BuildContext context) async {
    try {
      await supabaseClient.auth.signOut();
      if (!context.mounted) return;
    } catch (e) {
      throw SupabaseExceptionHandler.handle(e);
    }
  }
}
