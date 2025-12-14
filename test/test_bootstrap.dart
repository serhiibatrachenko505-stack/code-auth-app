import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

Future<void> initSqfliteForTests() async {
  sqfliteFfiInit();
  sqflite.databaseFactory = databaseFactoryFfi;
}