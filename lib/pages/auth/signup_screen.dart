import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:waseembrayani/utils/failure.dart';
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
  /// Step 1: Form key for validating all input fields
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  /// Step 2: Text controllers to read user input
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  /// Step 3: Create instance of AuthService to handle signup logic
  final AuthService _authService = AuthService();

  /// Step 4: Flag to toggle password visibility (show/hide password)
  bool isPasswordHidden = true;

  /// Step 5: Signup method
  /// - Reads values from text controllers
  /// - Shows loading animation
  /// - Calls AuthService.signUp
  /// - On success → Navigates to LoginScreen
  /// - On error → Displays snackbar with error message
  Future<void> _signUp() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final name = nameController.text.trim();
    final address = addressController.text.trim();

    try {
      // Step 5.1: Show loading spinner while request is in progress
      EasyLoading.show(
        maskType: EasyLoadingMaskType.black,
        indicator: LoadingAnimationWidget.stretchedDots(
          size: 30,
          color: Colors.white,
        ),
      );

      // Step 5.2: Call AuthService to perform signup
      await _authService.signUp(
        context: context,
        email: email,
        password: password,
        name: name,
        adress: address,
      );

      // Step 5.3: If widget is still active, navigate to login screen
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } catch (e) {
      // Step 5.4: Handle errors
      if (e is Failure) {
        // Custom failure error message
        showSnackBar(context, e.message.toString());
      } else {
        // Fallback generic error message
        showSnackBar(context, 'Unexpected error');
      }
    } finally {
      // Step 5.5: Always dismiss loading animation
      EasyLoading.dismiss();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      /// Step 6: Use SingleChildScrollView to prevent overflow on smaller screens
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                /// Step 7: Show top illustration image
                Image.asset(
                  'assets/images/signupIllustration.png',
                  height: 250,
                  width: double.maxFinite,
                  fit: BoxFit.scaleDown,
                ),
                const SizedBox(height: 20),

                /// Step 8: Name input field with validation
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

                /// Step 9: Email input field with regex validation
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == '' || value!.isEmpty) {
                      return 'Please enter email';
                    }
                    // Simple regex for email format validation
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

                /// Step 10: Address input field
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

                /// Step 11: Password input field with show/hide toggle
                TextFormField(
                  controller: passwordController,
                  obscureText: isPasswordHidden, // toggle visibility
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
                        // Toggle visibility on eye icon tap
                        setState(() {
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

                /// Step 12: Signup button
                SizedBox(
                  width: double.maxFinite,
                  child: AuthButtonWidget(
                    onTap: () {
                      // Validate all fields before signup
                      if (_formKey.currentState!.validate()) {
                        _signUp();
                      }
                    },
                    buttonText: 'Signup',
                  ),
                ),

                const SizedBox(height: 20),

                /// Step 13: Redirect user to login screen if already registered
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already have an account?",
                      style: TextStyle(fontSize: 18),
                    ),
                    GestureDetector(
                      onTap: () {
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
