import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:waseembrayani/core/utils/failure.dart';
import 'package:waseembrayani/service/auth_service.dart';
import 'package:waseembrayani/widgets/back_button_widget.dart';
import 'package:waseembrayani/widgets/auth_button_widget.dart';
import 'package:waseembrayani/utils/snackbar.dart';

class ForgotPasswordScreen extends StatefulWidget {
  final String? email;
  const ForgotPasswordScreen({super.key, this.email});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final AuthService _authService = AuthService();

  bool isPasswordHidden = true;

  void _forgotPassword() async {
    String email = emailController.text.trim();

    try {
      EasyLoading.show(
        maskType: EasyLoadingMaskType.black, // dim background
        indicator: LoadingAnimationWidget.stretchedDots(
          size: 30,
          color: Colors.white,
        ),
      );

      await _authService.forgotPassword(context, email);

      if (!mounted) return;

      Navigator.pop(context);
      showSnackBar(context, 'Password reset link sent to your email');
    } catch (e) {
      if (!mounted) return;

      if (e is Failure) {
        showSnackBar(context, e.message.toString());
      } else {
        showSnackBar(context, 'Unexpected error');
      }
    } finally {
      EasyLoading.dismiss();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    emailController.text = widget.email ?? "";
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
                Align(
                  alignment: AlignmentGeometry.centerLeft,
                  child: BackButtonWidget(onTap: () => Navigator.pop(context)),
                ),
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

                const SizedBox(height: 20),

                /// --- Login button ---
                SizedBox(
                  width: double.maxFinite,
                  child: AuthButtonWidget(
                    onTap: () {
                      // Validate form before login
                      if (_formKey.currentState!.validate()) {
                        _forgotPassword();
                      }
                    },
                    buttonText:
                        emailController.text == null ||
                            emailController.text == ''
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
