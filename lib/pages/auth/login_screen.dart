import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:waseembrayani/core/utils/consts.dart';
import 'package:waseembrayani/core/utils/failure.dart';
import 'package:waseembrayani/pages/auth/forgot_password_screen.dart';
import 'package:waseembrayani/pages/auth/signup_screen.dart';
import 'package:waseembrayani/pages/screens/app_main_screen.dart';
import 'package:waseembrayani/service/auth_service.dart';
import 'package:waseembrayani/widgets/mybutton_widget.dart';
import 'package:waseembrayani/widgets/snackbar.dart';

/// Login Screen
/// Allows user to login with email and password.
/// Uses AuthService for authentication and shows error messages with snackbar.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  /// --- Form key for validation ---
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  /// --- Controllers for text fields ---
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  /// --- Auth service instance ---
  final AuthService _authService = AuthService();

  /// --- To toggle password visibility ---
  bool isPasswordHidden = true;

  /// Login method
  /// 1. Validates form
  /// 2. Shows loading animation
  /// 3. Calls AuthService to log user in
  /// 4. On success → Navigate to AppMainScreen
  /// 5. On failure → Show error message
  void _login() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    try {
      // Show loading indicator while login request is in progress
      EasyLoading.show(
        maskType: EasyLoadingMaskType.black, // dim background
        indicator: LoadingAnimationWidget.stretchedDots(
          size: 30,
          color: Colors.white,
        ),
      );

      // Call login API
      await _authService.login(context, email, password);

      // Prevent further UI updates if widget is disposed
      if (!mounted) return;

      // Navigate to main app screen on successful login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AppMainScreen()),
      );
    } catch (e) {
      if (!mounted) return;

      // Handle custom Failure exceptions
      if (e is Failure) {
        showSnackBar(context, e.message.toString());
      } else {
        // Generic error handling
        showSnackBar(context, 'Unexpected error');
      }
    } finally {
      // Hide loading indicator regardless of success or error
      EasyLoading.dismiss();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      /// Page body is scrollable to avoid overflow on small screens
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Form(
            key: _formKey, // attach form key for validation
            child: Column(
              children: [
                const SizedBox(height: 20),

                /// --- Top illustration image ---
                Image.asset(
                  'assets/images/loginIllustration.png',
                  height: 300,
                  width: double.maxFinite,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 20),

                /// --- Email input field ---
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter email';
                    }

                    // Regex for email format
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

                /// --- Password input field ---
                TextFormField(
                  controller: passwordController,
                  obscureText: isPasswordHidden, // toggle hide/show password
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
                        setState(() {
                          // Toggle password visibility
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
                SizedBox(height: 5),
                Align(
                  alignment: AlignmentGeometry.centerRight,
                  child: InkWell(
                    onTap: () {
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

                /// --- Login button ---
                SizedBox(
                  width: double.maxFinite,
                  child: MybuttonWidget(
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

                /// --- Signup navigation text ---
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
