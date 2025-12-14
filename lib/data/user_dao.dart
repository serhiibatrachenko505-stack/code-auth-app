import 'package:sqflite/sqflite.dart';
import '../models/user.dart';
import 'app_database.dart';

class UserDao {
  Future<int> insert(UserModel user) async {
    final db = await AppDatabase.instance.database;
    return await db.insert('users', user.toMap(),
        conflictAlgorithm: ConflictAlgorithm.abort);
  }

  Future<UserModel?> findByNickOrEmail(String login) async {
    final db = await AppDatabase.instance.database;
    final rows = await db.query(
      'users',
      where: 'nick = ? OR email = ?',
      whereArgs: [login, login],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return UserModel.fromMap(rows.first);
  }

  Future<bool> isNickTaken(String nick) async {
    final db = await AppDatabase.instance.database;
    final r = await db.query('users',
        columns: ['id'], where: 'nick = ?', whereArgs: [nick], limit: 1);
    return r.isNotEmpty;
  }

  Future<bool> isEmailTaken(String email) async {
    final db = await AppDatabase.instance.database;
    final r = await db.query('users',
        columns: ['id'], where: 'email = ?', whereArgs: [email], limit: 1);
    return r.isNotEmpty;
  }
}
