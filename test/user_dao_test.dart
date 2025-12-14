import 'package:flutter_test/flutter_test.dart';
import 'package:code/data/app_database.dart';
import 'package:code/data/user_dao.dart';
import 'package:code/models/user.dart';
import 'package:code/utils/hash_util.dart';
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

  test('findByNickOrEmail знаходить по nick і по email', () async {
    final dao = UserDao();

    final pair = HashUtil.hashNewPassword('pass');
    final user = UserModel(
      nick: 'n',
      email: 'n@mail.com',
      fullName: 'Name',
      passwordHash: pair.hash,
      salt: pair.salt,
      createdAt: DateTime.now(),
    );

    await dao.insert(user);

    expect(await dao.findByNickOrEmail('n'), isNotNull);
    expect(await dao.findByNickOrEmail('n@mail.com'), isNotNull);
  });
}
