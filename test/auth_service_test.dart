import 'package:flutter_test/flutter_test.dart';
import 'package:code/data/auth_service.dart';
import 'package:code/data/app_database.dart';
import 'test_bootstrap.dart';

void main() {
  setUpAll(() async {
    await initSqfliteForTests();
    await AppDatabase.instance.database;
  });

  setUp(() async {
    final db = await AppDatabase.instance.database;
    await db.delete('users');
  });

  group('AuthService.register/login', () {
    test('register успішний → потім login успішний', () async {
      final auth = AuthService();

      final reg = await auth.register(
        nick: 'user1',
        email: 'user1@mail.com',
        fullName: 'Test User',
        password: 'secret',
      );
      expect(reg.ok, isTrue);

      final login = await auth.login(login: 'user1', password: 'secret');
      expect(login.ok, isTrue);
      expect(login.user, isNotNull);
    });

    test('register: повторний nick → ok=false', () async {
      final auth = AuthService();

      final r1 = await auth.register(
        nick: 'nick',
        email: 'a@mail.com',
        fullName: 'A',
        password: '111',
      );
      expect(r1.ok, isTrue);

      final r2 = await auth.register(
        nick: 'nick',
        email: 'b@mail.com',
        fullName: 'B',
        password: '222',
      );
      expect(r2.ok, isFalse);
      expect(r2.error, equals('Нікнейм уже зайнято'));
    });

    test('login: користувача не знайдено → ok=false', () async {
      final auth = AuthService();
      final res = await auth.login(login: 'none', password: 'x');

      expect(res.ok, isFalse);
      expect(res.error, equals('Користувача не знайдено'));
    });

    test('login: невірний пароль → ok=false', () async {
      final auth = AuthService();

      await auth.register(
        nick: 'nick2',
        email: 'nick2@mail.com',
        fullName: 'User',
        password: 'right',
      );

      final bad = await auth.login(login: 'nick2', password: 'wrong');
      expect(bad.ok, isFalse);
      expect(bad.error, equals('Невірний пароль'));
    });
  });
}
