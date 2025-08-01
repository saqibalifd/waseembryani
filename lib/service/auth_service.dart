import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:waseembrayani/pages/auth/login_screen.dart';

class AuthService {
  final supabase = Supabase.instance.client;
  //signup function
  Future<String?> signup(String email, String password) async {
    try {
      final response = await supabase.auth.signUp(
        email: email,
        password: password,
      );
      if (response.user != null) {
        return null;
      } else {
        return "An Unknown error occured";
      }
    } on AuthException catch (e) {
      return e.message;
    } catch (e) {
      return 'Erro : ${e.toString()}';
    }
  }

  // login function
  Future<String?> login(String email, String password) async {
    try {
      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (response.user != null) {
        return null;
      } else {
        return "Invalid email or password";
      }
    } on AuthException catch (e) {
      return e.message;
    } catch (e) {
      return 'Erro : ${e.toString()}';
    }
  }

  //logout function
  Future<void> logout(BuildContext context) async {
    try {
      await supabase.auth.signOut();
      if (context.mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } catch (e) {
      print('Logout error : ${e.toString()}');
    }
  }
}
