import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:waseembrayani/core/utils/failure.dart';
import 'package:waseembrayani/service/auth_service.dart';
import 'package:waseembrayani/widgets/auth_button_widget.dart';
import 'package:waseembrayani/utils/snackbar.dart';
import 'package:waseembrayani/pages/auth/login_screen.dart';

/// Signup Screen
/// Allows user to create a new account with:
/// - Name
/// - Email
/// - Address
/// - Password
/// Uses AuthService for backend signup and redirects to LoginScreen on success.
class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  /// --- Form key for validation ---
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  /// --- Controllers for input fields ---
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  /// --- AuthService instance ---
  final AuthService _authService = AuthService();

  /// --- To toggle password visibility ---
  bool isPasswordHidden = true;

  /// Signup function
  /// 1. Validates form inputs
  /// 2. Shows loading animation
  /// 3. Calls AuthService.signUp
  /// 4. On success → Navigate to LoginScreen
  /// 5. On error → Show snackbar with error message
  Future<void> _signUp() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final name = nameController.text.trim();
    final address = addressController.text.trim();

    try {
      // Show loading spinner while signup request is running
      EasyLoading.show(
        maskType: EasyLoadingMaskType.black,
        indicator: LoadingAnimationWidget.stretchedDots(
          size: 30,
          color: Colors.white,
        ),
      );

      // Call signup API
      await _authService.signUp(
        context: context,
        email: email,
        password: password,
        name: name,
        adress: address,
      );

      if (!mounted) return;

      // Navigate to LoginScreen on successful signup
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } catch (e) {
      // Handle custom failure error
      if (e is Failure) {
        showSnackBar(context, e.message.toString());
      } else {
        // Fallback error
        showSnackBar(context, 'Unexpected error');
      }
    } finally {
      // Always dismiss loader after process ends
      EasyLoading.dismiss();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      /// Scrollable layout → prevents overflow on small screens
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                /// --- Top illustration image ---
                Image.asset(
                  'assets/images/signupIllustration.png',
                  height: 250,
                  width: double.maxFinite,
                  fit: BoxFit.scaleDown,
                ),
                const SizedBox(height: 20),

                /// --- Name field ---
                TextFormField(
                  controller: nameController,
                  keyboardType: TextInputType.name,
                  validator: (value) {
                    if (value == '' || value!.isEmpty) {
                      return 'Please enter name';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),

                /// --- Email field ---
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == '' || value!.isEmpty) {
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

                /// --- Address field ---
                TextFormField(
                  controller: addressController,
                  keyboardType: TextInputType.streetAddress,
                  validator: (value) {
                    if (value == '' || value!.isEmpty) {
                      return 'Please enter adress';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Address',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),

                /// --- Password field ---
                TextFormField(
                  controller: passwordController,
                  obscureText: isPasswordHidden,
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
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                /// --- Signup button ---
                SizedBox(
                  width: double.maxFinite,
                  child: AuthButtonWidget(
                    onTap: () {
                      // Validate form before calling signup
                      if (_formKey.currentState!.validate()) {
                        _signUp();
                      }
                    },
                    buttonText: 'Signup',
                  ),
                ),

                const SizedBox(height: 20),

                /// --- Redirect to login ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already have an account?",
                      style: TextStyle(fontSize: 18),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Navigate to login screen
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        ' Login here',
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
