import 'package:flutter_test/flutter_test.dart';
import 'package:code/utils/hash_util.dart';

void main() {
  group('HashUtil', () {
    test('hashNewPassword повертає salt+hash і hash відповідає hashWithSalt', () {
      const password = 'P@ssw0rd!';
      final pair = HashUtil.hashNewPassword(password);

      expect(pair.salt.isNotEmpty, isTrue);
      expect(pair.hash.isNotEmpty, isTrue);

      final recomputed = HashUtil.hashWithSalt(password, pair.salt);
      expect(recomputed, equals(pair.hash));
    });

    test('два виклики hashNewPassword дають різні salt і hash', () {
      const password = 'same-password';
      final p1 = HashUtil.hashNewPassword(password);
      final p2 = HashUtil.hashNewPassword(password);

      expect(p1.salt, isNot(equals(p2.salt)));
      expect(p1.hash, isNot(equals(p2.hash)));
    });

    test('hashWithSalt детермінований', () {
      const password = '123';
      const salt = 'test_salt';
      expect(HashUtil.hashWithSalt(password, salt),
          equals(HashUtil.hashWithSalt(password, salt)));
    });
  });
}
