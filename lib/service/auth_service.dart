import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:waseembrayani/core/models/user_model.dart';
import 'package:waseembrayani/pages/auth/login_screen.dart';
import 'package:waseembrayani/widgets/snackbar.dart';

class AuthService {
  final supabaseClient = Supabase.instance.client;

  //signup function
  Future signUp({
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
      }

      UserModel userModel = UserModel(
        name: name,
        email: email,
        userid: res.user!.id,
        profileImage: '',
        adress: adress,
        isAdmin: false,
      );
      await Supabase.instance.client.from('users').insert({
        'userid': res.user!.id,
        'email': email,
        'name': name,
        'adress': adress,
        'profileImage': '',
        'isAdmin': false,
      });
    } catch (e) {
      return showSnackBar(context, 'Something went wrong');
    }
  }

  // login function
  Future login(BuildContext context, String email, String password) async {
    try {
      final response = await supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (response.user != null) {
        return null;
      } else {
        showSnackBar(context, 'Invalid email or password');
      }
    } catch (e) {
      showSnackBar(context, 'Somehting went wrong');
    }
  }

  //logout function
  Future<void> logout(BuildContext context) async {
    try {
      await supabaseClient.auth.signOut();
      if (!context.mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } catch (e) {
      print('Logout error: ${e.toString()}');
    }
  }
}
