import 'package:flutter/material.dart';
import 'ui/login_screen.dart';
import 'ui/register_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const Color kBlue = Color(0xFF2B3BD1); // фон
  static const Color kTeal = Color(0xFF2ED3D3); // кнопка

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Auth UI',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: kBlue,
        textTheme: const TextTheme(
          headlineMedium: TextStyle(
              color: Colors.white, fontSize: 28, fontWeight: FontWeight.w600),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(16),
          ),
          hintStyle: TextStyle(color: Colors.grey),
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: kTeal,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            elevation: 0,
          ),
        ),
      ),
      routes: {
        '/': (_) => const LoginScreen(),
        '/register': (_) => const RegisterScreen(),
      },
    );
  }
}
