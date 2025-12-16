import 'package:flutter/material.dart';
import 'widgets/app_input.dart';
import 'widgets/primary_button.dart';
import '../data/auth_service.dart';

class LoginScreen extends StatefulWidget {
  // ЗМІНЕНО: додаємо можливість підставити AuthService ззовні (для тестів)
  final AuthService auth;

  // ЗМІНЕНО: конструктор тепер приймає необов’язковий auth,
  // якщо не передали — використовуємо реальний AuthService()
  LoginScreen({super.key, AuthService? auth}) : auth = auth ?? AuthService();

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _loginCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  // ЗМІНЕНО: було final _auth = AuthService();
  // тепер беремо сервіс з widget.auth (щоб у тестах підміняти на Mock)
  late final AuthService _auth;

  @override
  void initState() {
    super.initState();
    // ЗМІНЕНО: ініціалізуємо _auth з widget.auth
    _auth = widget.auth;
  }

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

                  // ЗМІНЕНО: додали Key, щоб тести могли стабільно знаходити поле
                  AppInput(
                    key: const Key('login_login'),
                    hint: 'Нікнейм/email',
                    controller: _loginCtrl,
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Заповніть поле' : null,
                  ),

                  const SizedBox(height: 18),

                  // ЗМІНЕНО: додали Key
                  AppInput(
                    key: const Key('login_password'),
                    hint: 'Пароль',
                    controller: _passCtrl,
                    obscure: true,
                    validator: (v) =>
                    (v == null || v.length < 6) ? 'Мінімум 6 символів' : null,
                  ),

                  const SizedBox(height: 18),

                  // ЗМІНЕНО: додали Key
                  AppInput(
                    key: const Key('login_confirm'),
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
