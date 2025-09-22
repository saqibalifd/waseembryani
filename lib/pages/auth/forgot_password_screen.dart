import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:waseembrayani/service/auth_service.dart';
import 'package:waseembrayani/utils/failure.dart';
import 'package:waseembrayani/widgets/back_button_widget.dart';
import 'package:waseembrayani/widgets/auth_button_widget.dart';
import 'package:waseembrayani/utils/snackbar.dart';

/// Forgot Password Screen
/// ✅ Allows user to request a password reset link
/// ✅ Uses AuthService for sending reset link
/// ✅ Displays error messages using custom Snackbar
/// ✅ Shows loading animation while request is in progress
class ForgotPasswordScreen extends StatefulWidget {
  final String? email; // optional pre-filled email passed from login
  const ForgotPasswordScreen({super.key, this.email});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  /// --- Step 1: Define Form Key ---
  /// Used for validating the reset password form
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  /// --- Step 2: Define Controllers ---
  /// emailController → captures email entered by the user
  /// passwordController → not needed here but kept (can be removed)
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  /// --- Step 3: Initialize AuthService ---
  final AuthService _authService = AuthService();

  /// --- Step 4: Password visibility (unused here) ---
  bool isPasswordHidden = true;

  /// --- Step 5: Forgot Password Function ---
  /// 1. Validates input
  /// 2. Shows loading animation
  /// 3. Calls AuthService to send reset link
  /// 4. On success → show snackbar and pop back
  /// 5. On failure → show error message
  void _forgotPassword() async {
    String email = emailController.text.trim();

    try {
      // --- Step 5.1: Show loading animation ---
      EasyLoading.show(
        maskType: EasyLoadingMaskType.black, // dims background
        indicator: LoadingAnimationWidget.stretchedDots(
          size: 30,
          color: Colors.white,
        ),
      );

      // --- Step 5.2: Call forgot password API ---
      await _authService.forgotPassword(context, email);

      if (!mounted) return;

      // --- Step 5.3: Close screen and show success message ---
      Navigator.pop(context);
      showSnackBar(context, 'Password reset link sent to your email');
    } catch (e) {
      // --- Step 5.4: Handle errors ---
      if (!mounted) return;

      if (e is Failure) {
        showSnackBar(context, e.message.toString());
      } else {
        showSnackBar(context, 'Unexpected error');
      }
    } finally {
      // --- Step 5.5: Hide loading ---
      EasyLoading.dismiss();
    }
  }

  @override
  void initState() {
    super.initState();
    // --- Step 6: Pre-fill email if passed from Login screen ---
    emailController.text = widget.email ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      /// --- Step 7: Make screen scrollable ---
      /// Prevents overflow on small screens
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Form(
            key: _formKey, // attach form key for validation
            child: Column(
              children: [
                const SizedBox(height: 20),

                /// --- Step 8: Back Button ---
                Align(
                  alignment: AlignmentGeometry.centerLeft,
                  child: BackButtonWidget(onTap: () => Navigator.pop(context)),
                ),
                const SizedBox(height: 20),

                /// --- Step 9: Illustration Image ---
                Image.asset(
                  'assets/images/loginIllustration.png',
                  height: 300,
                  width: double.maxFinite,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 20),

                /// --- Step 10: Email Input Field ---
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter email';
                    }

                    // Regex validation for email format
                    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                    if (!emailRegex.hasMatch(value)) {
                      return 'Please enter a valid email';
                    }

                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),

                /// --- Step 11: Reset Password Button ---
                SizedBox(
                  width: double.maxFinite,
                  child: AuthButtonWidget(
                    onTap: () {
                      // Validate form before calling API
                      if (_formKey.currentState!.validate()) {
                        _forgotPassword();
                      }
                    },
                    buttonText: emailController.text.isEmpty
                        ? 'Forgot Password'
                        : 'Reset Password',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
