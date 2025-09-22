import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:waseembrayani/utils/failure.dart';
import 'package:waseembrayani/pages/auth/forgot_password_screen.dart';
import 'package:waseembrayani/pages/auth/signup_screen.dart';
import 'package:waseembrayani/pages/user/app_main_screen.dart';
import 'package:waseembrayani/service/auth_service.dart';
import 'package:waseembrayani/widgets/auth_button_widget.dart';
import 'package:waseembrayani/utils/snackbar.dart';

/// Login Screen
/// ✅ Allows user to login with email and password.
/// ✅ Uses AuthService for authentication.
/// ✅ Displays error messages using custom Snackbar.
/// ✅ Shows loading animation while login request is in progress.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  /// --- Step 1: Define Form Key ---
  /// This key will be used for validating the login form.
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  /// --- Step 2: Define Text Controllers ---
  /// These controllers hold the text entered in email & password fields.
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  /// --- Step 3: Initialize AuthService ---
  /// AuthService will handle the actual login request to Supabase/Auth API.
  final AuthService _authService = AuthService();

  /// --- Step 4: Track Password Visibility ---
  /// Used for showing/hiding password in the input field.
  bool isPasswordHidden = true;

  /// --- Step 5: Define Login Method ---
  /// 1. Validates input
  /// 2. Shows loading animation
  /// 3. Calls AuthService to log user in
  /// 4. On success → Navigate to AppMainScreen
  /// 5. On failure → Show error message
  void _login() async {
    // --- Extract text values from controllers ---
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    try {
      // --- Step 5.1: Show loading animation ---
      EasyLoading.show(
        maskType: EasyLoadingMaskType.black, // Prevents taps outside
        indicator: LoadingAnimationWidget.stretchedDots(
          size: 30,
          color: Colors.white,
        ),
      );

      // --- Step 5.2: Call login function from AuthService ---
      await _authService.login(context, email, password);

      // --- Step 5.3: Prevent crash if widget is disposed ---
      if (!mounted) return;

      // --- Step 5.4: Navigate to Main App Screen ---
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AppMainScreen()),
      );
    } catch (e) {
      // --- Step 5.5: Handle error cases ---
      if (!mounted) return;

      if (e is Failure) {
        // Custom Failure error → Show message from Failure class
        showSnackBar(context, e.message.toString());
      } else {
        // Any other exception → Show generic message
        showSnackBar(context, 'Unexpected error');
      }
    } finally {
      // --- Step 5.6: Hide loading animation ---
      EasyLoading.dismiss();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      /// --- Step 6: Wrap Body in SingleChildScrollView ---
      /// Prevents overflow when keyboard appears on smaller devices.
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Form(
            key: _formKey, // Attach form validation key here
            child: Column(
              children: [
                const SizedBox(height: 20),

                /// --- Step 7: Display Illustration Image ---
                Image.asset(
                  'assets/images/loginIllustration.png',
                  height: 300,
                  width: double.maxFinite,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 20),

                /// --- Step 8: Email Input Field ---
                /// Includes validation for empty value & proper email format.
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

                /// --- Step 9: Password Input Field ---
                /// Includes validation for minimum length & toggle visibility.
                TextFormField(
                  controller: passwordController,
                  obscureText: isPasswordHidden, // Toggle hide/show
                  keyboardType: TextInputType.visiblePassword,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters long';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      onPressed: () {
                        // Toggle visibility when eye icon tapped
                        setState(() {
                          isPasswordHidden = !isPasswordHidden;
                        });
                      },
                      icon: Icon(
                        isPasswordHidden
                            ? Icons.visibility_off_sharp
                            : Icons.visibility,
                      ),
                    ),
                  ),
                ),

                /// --- Step 10: Forgot Password Link ---
                SizedBox(height: 5),
                Align(
                  alignment: AlignmentGeometry.centerRight,
                  child: InkWell(
                    onTap: () {
                      // Navigate to ForgotPassword screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ForgotPasswordScreen(),
                        ),
                      );
                    },
                    child: Text(
                      'Forgot password?',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                /// --- Step 11: Login Button ---
                SizedBox(
                  width: double.maxFinite,
                  child: AuthButtonWidget(
                    onTap: () {
                      // Validate form before login
                      if (_formKey.currentState!.validate()) {
                        _login();
                      }
                    },
                    buttonText: 'Login',
                  ),
                ),
                const SizedBox(height: 20),

                /// --- Step 12: Navigate to Signup Screen ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account?",
                      style: TextStyle(fontSize: 18),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Navigate to Signup screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignupScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        ' Signup here',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                          letterSpacing: -1,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
