import 'package:sqflite/sqflite.dart';
import 'package:zyra/core/services/database_service.dart';
import 'package:zyra/core/services/preferences_service.dart';
import 'package:zyra/core/constants/app_constants.dart';
import '../models/user_model.dart';

class AuthLocalDataSource {
  Future<int> insertUser(UserModel user) async {
    final db = await DatabaseService.database;
    return db.insert('users', user.toMap());
  }

  Future<UserModel?> getUserByEmail(String email) async {
    final db = await DatabaseService.database;
    final maps = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    if (maps.isEmpty) return null;
    return UserModel.fromMap(maps.first);
  }

  Future<UserModel?> getUserByPhone(String phone) async {
    final db = await DatabaseService.database;
    final maps = await db.query(
      'users',
      where: 'phone = ?',
      whereArgs: [phone],
    );
    if (maps.isEmpty) return null;
    return UserModel.fromMap(maps.first);
  }

  Future<UserModel?> getUserById(int id) async {
    final db = await DatabaseService.database;
    final maps = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) return null;
    return UserModel.fromMap(maps.first);
  }

  Future<void> saveUserSession(UserModel user) async {
    await PreferencesService.setString(
      AppConstants.prefKeyUser,
      user.toJson().toString(),
    );
  }

  Future<UserModel?> getSavedUser() async {
    final userStr = await PreferencesService.getString(AppConstants.prefKeyUser);
    if (userStr == null) return null;
    // Note: Using simplified JSON parsing
    return null;
  }

  Future<void> clearSession() async {
    await PreferencesService.remove(AppConstants.prefKeyUser);
  }

  Future<bool> hasSession() async {
    return PreferencesService.containsKey(AppConstants.prefKeyUser);
  }
}
