import 'package:flutter/material.dart';
import 'package:waseembrayani/pages/auth/signup_screen.dart';
import 'package:waseembrayani/pages/screens/app_main_screen.dart';
import 'package:waseembrayani/service/auth_service.dart';
import 'package:waseembrayani/widgets/mybutton_widget.dart';
import 'package:waseembrayani/widgets/snackbar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  bool isLoading = false;
  bool isPasswordHidden = true;

  void _login() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    if (!mounted) return;
    setState(() {
      isLoading = true;
    });

    final result = await _authService.login(context, email, password);

    setState(() {
      isLoading = false;
    });

    if (result == null) {
      // success case
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AppMainScreen()),
      );
      showSnackBar(context, 'Login successful');
    } else {
      showSnackBar(context, 'Login failed: $result');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              Image.asset(
                'assets/images/loginIllustration.jpg',
                height: 400,
                width: double.maxFinite,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: passwordController,
                obscureText: isPasswordHidden,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    onPressed: () {
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
              const SizedBox(height: 20),
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : SizedBox(
                      width: double.maxFinite,
                      child: MybuttonWidget(onTap: _login, buttonText: 'Login'),
                    ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an account?",
                    style: TextStyle(fontSize: 18),
                  ),
                  GestureDetector(
                    onTap: () {
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
    );
  }
}
