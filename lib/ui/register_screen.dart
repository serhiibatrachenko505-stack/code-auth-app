import 'package:flutter/material.dart';
import 'widgets/app_input.dart';
import 'widgets/primary_button.dart';
import '../data/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  // ЗМІНЕНО: додаємо можливість підставити AuthService ззовні (для тестів)
  final AuthService auth;

  // ЗМІНЕНО: конструктор тепер приймає необов’язковий auth,
  // якщо не передали — використовуємо реальний AuthService()
  RegisterScreen({super.key, AuthService? auth}) : auth = auth ?? AuthService();

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nickCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _fullNameCtrl = TextEditingController();
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
    _nickCtrl.dispose();
    _emailCtrl.dispose();
    _fullNameCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (_passCtrl.text != _confirmCtrl.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Паролі не збігаються')),
      );
      return;
    }

    final res = await _auth.register(
      nick: _nickCtrl.text,
      email: _emailCtrl.text,
      fullName: _fullNameCtrl.text,
      password: _passCtrl.text,
    );

    if (!mounted) return;
    if (res.ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Реєстрація успішна')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(res.error ?? 'Помилка')),
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
                children: [
                  const SizedBox(height: 12),
                  const Text(
                    'Зареєструвати аккаунт',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // ЗМІНЕНО: додали Key
                  AppInput(
                    key: const Key('reg_nick'),
                    hint: 'Нікнейм',
                    controller: _nickCtrl,
                    validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Заповніть поле' : null,
                  ),
                  const SizedBox(height: 18),

                  // ЗМІНЕНО: додали Key
                  AppInput(
                    key: const Key('reg_email'),
                    hint: 'email',
                    controller: _emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Введіть email';
                      final ok = RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(v);
                      return ok ? null : 'Некоректний email';
                    },
                  ),
                  const SizedBox(height: 18),

                  // ЗМІНЕНО: додали Key
                  AppInput(
                    key: const Key('reg_fullname'),
                    hint: '*ПІБ',
                    controller: _fullNameCtrl,
                    validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Заповніть поле' : null,
                  ),
                  const SizedBox(height: 18),

                  // ЗМІНЕНО: додали Key
                  AppInput(
                    key: const Key('reg_password'),
                    hint: 'Пароль',
                    controller: _passCtrl,
                    obscure: true,
                    validator: (v) =>
                    (v == null || v.length < 6) ? 'Мінімум 6 символів' : null,
                  ),
                  const SizedBox(height: 18),

                  // ЗМІНЕНО: додали Key
                  AppInput(
                    key: const Key('reg_confirm'),
                    hint: 'Підтвердження паролю',
                    controller: _confirmCtrl,
                    obscure: true,
                    validator: (v) =>
                    (v == null || v.isEmpty) ? 'Підтвердіть пароль' : null,
                  ),
                  const SizedBox(height: 28),

                  PrimaryButton(text: 'Зареєструвати', onPressed: _submit),
                  const SizedBox(height: 18),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Вже є аккаунт? Увійти!',
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
