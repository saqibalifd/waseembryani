import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:persistent_shopping_cart/persistent_shopping_cart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:waseembrayani/pages/auth/login_screen.dart';
import 'package:waseembrayani/pages/user/app_main_screen.dart';

/// Entry point of the application
void main() async {
  // Ensures all Flutter bindings are initialized before runApp
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase with your project URL & Anon key
  await Supabase.initialize(
    url: 'https://ywgpbgztiuzofgfavdxb.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inl3Z3BiZ3p0aXV6b2ZnZmF2ZHgiLCJyb2xlIjoiYW5vbiIsImlhdCI6MTc1MjkwMTE0OCwiZXhwIjoyMDY4NDc3MTQ4fQ.TZ0OL-i9MCdsgFxj8D6mnK36KdORK4gbqgRD-uBRj0U',
  );

  // Initialize Persistent Shopping Cart (used to store cart items locally)
  await PersistentShoppingCart().init();

  // Start the app
  runApp(const MyApp());
}

/// Root widget of the app
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Removes debug banner
      title: 'Flutter Demo',
      theme: ThemeData(
        // Creates a color scheme from a seed color
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),

      // Handles authentication check on app launch
      home: AuthCheck(),

      // Initialize EasyLoading for showing loaders globally
      builder: EasyLoading.init(),
    );
  }
}

/// Widget to check authentication status
/// - If user is logged in → go to AppMainScreen
/// - If not logged in → go to LoginScreen
class AuthCheck extends StatelessWidget {
  // Supabase client instance
  final supabase = Supabase.instance.client;

  AuthCheck({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      // Listen to authentication state changes
      stream: supabase.auth.onAuthStateChange,
      builder: (context, snapshot) {
        // Get current session
        final session = supabase.auth.currentSession;

        // If session exists → user is logged in
        if (session != null) {
          return AppMainScreen();
        } else {
          // Otherwise → show login screen
          return LoginScreen();
        }
      },
    );
  }
}
