import 'package:flutter/material.dart';
import 'package:waseembrayani/pages/auth/login_screen.dart';
import 'package:waseembrayani/service/auth_service.dart';
import 'package:waseembrayani/widgets/mybutton_widget.dart';
import 'package:waseembrayani/widgets/snackbar.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  bool isLoading = false;
  bool isPasswordHindden = true;
  void _login() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    if (!email.contains('.com')) {
      showSnackBar(context, 'Invalid Email,It must contain .com');
    }
    setState(() {
      isLoading = true;
    });
    final result = await _authService.login(email, password);
    if (result == null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SignupScreen()),
      );
      //success case
      setState(() {
        isLoading = false;
      });
      showSnackBar(context, 'signup successfull');
    } else {
      setState(() {
        isLoading = false;
      });
      showSnackBar(context, 'Signup failed : $result');
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
                'assets/images/signupIllustration.jpg',
                height: 400,
                width: double.maxFinite,
                fit: BoxFit.cover,
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: passwordController,
                obscureText: isPasswordHindden,
                decoration: InputDecoration(
                  labelText: 'Password',

                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        isPasswordHindden = !isPasswordHindden;
                      });
                    },
                    icon: Icon(
                      isPasswordHindden
                          ? Icons.visibility_off_sharp
                          : Icons.visibility,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              isLoading
                  ? Center(child: CircularProgressIndicator())
                  : SizedBox(
                      width: double.maxFinite,
                      child: MybuttonWidget(
                        onTap: _login,
                        buttonText: 'Signup',
                      ),
                    ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account?",
                    style: TextStyle(fontSize: 18),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Login here',
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
