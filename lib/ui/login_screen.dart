import 'package:flutter/material.dart';
import 'widgets/app_input.dart';
import 'widgets/primary_button.dart';
import '../data/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _loginCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  final _auth = AuthService();

  @override
  void dispose() {
    _loginCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final res = await _auth.login(
      login: _loginCtrl.text,
      password: _passCtrl.text,
    );

    if (!mounted) return;
    if (res.ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Вітаю, ${res.user!.nick}!')),
      );
      // Navigator.pushReplacementNamed(context, '/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(res.error ?? 'Помилка входу')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 12),
                  const Text(
                    'Вхід до аккаунту',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 32),
                  AppInput(
                    hint: 'Нікнейм/email',
                    controller: _loginCtrl,
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Заповніть поле' : null,
                  ),
                  const SizedBox(height: 18),
                  AppInput(
                    hint: 'Пароль',
                    controller: _passCtrl,
                    obscure: true,
                    validator: (v) =>
                    (v == null || v.length < 6) ? 'Мінімум 6 символів' : null,
                  ),
                  const SizedBox(height: 18),
                  AppInput(
                    hint: 'Підтвердження паролю',
                    controller: _confirmCtrl,
                    obscure: true,
                    validator: (v) => null,
                  ),
                  const SizedBox(height: 28),
                  PrimaryButton(text: 'Вхід', onPressed: _submit),
                  const SizedBox(height: 18),
                  TextButton(
                    onPressed: () => Navigator.pushNamed(context, '/register'),
                    child: const Text(
                      'Ще немає аккаунту? Зареєструвати!',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
