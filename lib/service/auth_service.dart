import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:waseembrayani/utils/failure.dart';
import 'package:waseembrayani/service/user_services.dart';
import 'package:waseembrayani/utils/snackbar.dart';

class AuthService {
  // Create Supabase client instance for authentication
  final supabaseClient = Supabase.instance.client;

  // Service class to handle storing/deleting user info in database
  UserServices userServices = UserServices();

  // ========================= SIGN UP =========================
  // Function to sign up a new user with email, password, name, and address
  Future<void> signUp({
    required BuildContext context,
    required String email,
    required String password,
    required String name,
    required String adress,
  }) async {
    try {
      // Step 1: Call Supabase signup API with email & password
      final AuthResponse res = await Supabase.instance.client.auth.signUp(
        email: email,
        password: password,
      );

      // Step 2: If user is not created successfully, show a failure message
      if (res.user == null) {
        return showSnackBar(context, 'User registration failed');
      } else {
        // Step 3: If user is created, store additional user info (name, address) in database
        await userServices.storeUserInfo(
          email: email,
          name: name,
          adress: adress,
          res: res,
          context: context,
        );
      }
    } catch (e) {
      // Step 4: Handle any Supabase errors using custom exception handler
      throw SupabaseExceptionHandler.handle(e);
    }
  }

  // ========================= LOGIN =========================
  // Function to login an existing user with email and password
  Future<void> login(
    BuildContext context,
    String email,
    String password,
  ) async {
    try {
      // Step 1: Attempt login with email and password
      final response = await supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );

      // Step 2: If user does not exist, throw custom Failure
      if (response.user == null) {
        throw Failure('Login Failed', code: "NO_USER");
      }
    } catch (e) {
      // Step 3: Handle Supabase exceptions
      throw SupabaseExceptionHandler.handle(e);
    }
  }

  // ========================= FORGOT PASSWORD =========================
  // Function to send a password reset email to user
  Future<void> forgotPassword(BuildContext context, String email) async {
    try {
      // Step 1: Request Supabase to send password reset email
      await supabaseClient.auth.resetPasswordForEmail(
        email,
        // redirectTo: 'https://your-app-url.com/reset-password', // optional custom redirect
      );
    } catch (e) {
      // Step 2: Handle exceptions if reset fails
      throw SupabaseExceptionHandler.handle(e);
    }
  }

  // ========================= LOGOUT =========================
  // Function to log out the current user
  Future<void> logout(BuildContext context) async {
    try {
      // Step 1: Call Supabase signOut
      await supabaseClient.auth.signOut();

      // Step 2: Check if context is still mounted before navigation/snackbar
      if (!context.mounted) return;
    } catch (e) {
      // Step 3: Handle logout errors
      throw SupabaseExceptionHandler.handle(e);
    }
  }

  // ========================= DELETE USER =========================
  // Function to delete user account (requires service_role key)
  Future<void> deleteUser() async {
    try {
      // Step 1: Create admin Supabase client with service_role key
      // ⚠️ WARNING: Do not expose service_role key in production client
      final adminClient = SupabaseClient(
        'https://ywgpbgztiuzofgfavdxb.supabase.co', // Project URL from Supabase settings
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inl3Z3BiZ3p0aXV6b2ZnZmF2ZHhiIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc1MjkwMTE0OCwiZXhwIjoyMDY4NDc3MTQ4fQ.WrrBMU465Mg_hLmyq4nOHCddIYWPMfx_6723tnLV1pc', // Service role API key
      );

      // Step 2: Get the current logged-in user's ID
      final String userId = Supabase.instance.client.auth.currentUser!.id
          .toString();

      // Step 3: Delete the user from Supabase Auth using admin client
      await adminClient.auth.admin.deleteUser(userId);

      // Step 4: Also delete the user's stored info from your database
      await userServices.deleteUserInfo();
    } catch (e) {
      // Step 5: Handle any errors during deletion
      throw SupabaseExceptionHandler.handle(e);
    }
  }
}
