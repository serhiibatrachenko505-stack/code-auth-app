import '../models/user.dart';
import '../utils/hash_util.dart';
import 'user_dao.dart';

class AuthService {
  final _userDao = UserDao();

  Future<({bool ok, String? error})> register({
    required String nick,
    required String email,
    required String fullName,
    required String password,
  }) async {
    if (await _userDao.isNickTaken(nick)) {
      return (ok: false, error: 'Нікнейм уже зайнято');
    }
    if (await _userDao.isEmailTaken(email)) {
      return (ok: false, error: 'Email уже зайнято');
    }

    final pair = HashUtil.hashNewPassword(password);
    final user = UserModel(
      nick: nick.trim(),
      email: email.trim(),
      fullName: fullName.trim(),
      passwordHash: pair.hash,
      salt: pair.salt,
      createdAt: DateTime.now(),
    );

    try {
      await _userDao.insert(user);
      return (ok: true, error: null);
    } catch (e) {
      return (ok: false, error: 'Помилка збереження: $e');
    }
  }

  Future<({bool ok, String? error, UserModel? user})> login({
    required String login, // nick або email
    required String password,
  }) async {
    final user = await _userDao.findByNickOrEmail(login.trim());
    if (user == null) {
      return (ok: false, error: 'Користувача не знайдено', user: null);
    }
    final hash = HashUtil.hashWithSalt(password, user.salt);
    if (hash != user.passwordHash) {
      return (ok: false, error: 'Невірний пароль', user: null);
    }
    return (ok: true, error: null, user: user);
  }
}
