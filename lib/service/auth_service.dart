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

  //forgot password
  Future<void> forgotPassword(BuildContext context, String email) async {
    try {
      await supabaseClient.auth.resetPasswordForEmail(
        email,
        // redirectTo: 'https://your-app-url.com/reset-password',
      );
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

  // delete user function (requires service_role key)
  Future<void> deleteUser() async {
    try {
      // Create a client using service_role key (⚠️ do not expose in production client)
      final adminClient = SupabaseClient(
        'https://ywgpbgztiuzofgfavdxb.supabase.co', //project -> setting ->data api ->project url
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inl3Z3BiZ3p0aXV6b2ZnZmF2ZHhiIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc1MjkwMTE0OCwiZXhwIjoyMDY4NDc3MTQ4fQ.WrrBMU465Mg_hLmyq4nOHCddIYWPMfx_6723tnLV1pc', //project -> setting ->api key ->service_role
      );
      final String userId = Supabase.instance.client.auth.currentUser!.id
          .toString();

      await adminClient.auth.admin.deleteUser(userId);
      await userServices.deleteUserInfo();
    } catch (e) {
      throw SupabaseExceptionHandler.handle(e);
    }
  }
}
