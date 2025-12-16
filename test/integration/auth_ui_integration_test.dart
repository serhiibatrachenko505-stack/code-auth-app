import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:code/ui/login_screen.dart';
import 'package:code/ui/register_screen.dart';
import 'package:code/data/auth_service.dart';
import 'package:code/models/user.dart';

class MockAuthService extends Mock implements AuthService {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('RegisterScreen <-> AuthService: показує помилку якщо email зайнято', (tester) async {
    final auth = MockAuthService();

    // MOCK: підміняємо реальну реєстрацію і повертаємо помилку
    when(() => auth.register(
      nick: any(named: 'nick'),
      email: any(named: 'email'),
      fullName: any(named: 'fullName'),
      password: any(named: 'password'),
    )).thenAnswer((_) async => (ok: false, error: 'Email уже зайнято'));

    await tester.pumpWidget(MaterialApp(home: RegisterScreen(auth: auth)));

    await tester.enterText(find.byKey(const Key('reg_nick')), 'nick1');
    await tester.enterText(find.byKey(const Key('reg_email')), 'test@mail.com');
    await tester.enterText(find.byKey(const Key('reg_fullname')), 'Test User');
    await tester.enterText(find.byKey(const Key('reg_password')), '123456');
    await tester.enterText(find.byKey(const Key('reg_confirm')), '123456');

    await tester.tap(find.text('Зареєструвати'));
    await tester.pumpAndSettle();

    // SPY: перевіряємо, що метод register справді викликався 1 раз
    verify(() => auth.register(
      nick: any(named: 'nick'),
      email: any(named: 'email'),
      fullName: any(named: 'fullName'),
      password: any(named: 'password'),
    )).called(1);

    // Перевірка UI-реакції: з’явився текст помилки
    expect(find.text('Email уже зайнято'), findsOneWidget);
  });

  testWidgets('LoginScreen <-> AuthService: успішний вхід показує SnackBar з привітанням', (tester) async {
    final auth = MockAuthService();

    // Для успішного входу LoginScreen читає res.user!.nick, тому user має бути не null
    final fakeUser = UserModel(
      id: 1,
      nick: 'nick1',
      email: 'test@mail.com',
      fullName: 'Test User',
      passwordHash: 'hash',
      salt: 'salt',
      createdAt: DateTime(2025, 1, 1),
    );

    when(() => auth.login(
      login: any(named: 'login'),
      password: any(named: 'password'),
    )).thenAnswer((_) async => (ok: true, error: null, user: fakeUser));

    await tester.pumpWidget(MaterialApp(home: LoginScreen(auth: auth)));

    await tester.enterText(find.byKey(const Key('login_login')), 'nick1');
    await tester.enterText(find.byKey(const Key('login_password')), '123456');

    await tester.tap(find.text('Вхід'));
    await tester.pumpAndSettle();

    // SPY: перевіряємо виклик login
    verify(() => auth.login(
      login: any(named: 'login'),
      password: any(named: 'password'),
    )).called(1);

    // Перевіряємо повідомлення у SnackBar
    expect(find.text('Вітаю, nick1!'), findsOneWidget);
  });
}
