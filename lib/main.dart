import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:waseembrayani/pages/auth/login_screen.dart';
import 'package:waseembrayani/pages/auth/signup_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://ywgpbgztiuzofgfavdxb.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inl3Z3BiZ3p0aXV6b2ZnZmF2ZHhiIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTI5MDExNDgsImV4cCI6MjA2ODQ3NzE0OH0.TZ0OL-i9MCdsgFxj8D6mnK36KdORK4gbqgRD-uBRj0U',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: LoginScreen(),
    );
  }
}
