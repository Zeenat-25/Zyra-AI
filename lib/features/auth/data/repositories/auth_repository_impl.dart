import 'package:zyra/core/errors/failures.dart';
import 'package:zyra/features/auth/domain/entities/user.dart';
import 'package:zyra/features/auth/domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDataSource _localDataSource;

  AuthRepositoryImpl(this._localDataSource);

  @override
  Future<User> register(
    String name,
    String email,
    String phone,
    String password,
  ) async {
    final existingEmail = await _localDataSource.getUserByEmail(email);
    if (existingEmail != null) {
      throw const AuthFailure('Email already registered');
    }

    final existingPhone = await _localDataSource.getUserByPhone(phone);
    if (existingPhone != null) {
      throw const AuthFailure('Phone number already registered');
    }

    final now = DateTime.now().toIso8601String();
    final user = UserModel(
      name: name,
      email: email,
      phone: phone,
      createdAt: now,
    );

    final id = await _localDataSource.insertUser(user);
    final createdUser = user.copyWith(id: id);
    await _localDataSource.saveUserSession(
      UserModel(
        id: id,
        name: name,
        email: email,
        phone: phone,
        createdAt: now,
      ),
    );
    return createdUser;
  }

  @override
  Future<User> login(String email, String password) async {
    final user = await _localDataSource.getUserByEmail(email);
    if (user == null) {
      throw const AuthFailure('Invalid email or password');
    }
    await _localDataSource.saveUserSession(user);
    return user;
  }

  @override
  Future<User> loginWithPhone(String phone, String password) async {
    final user = await _localDataSource.getUserByPhone(phone);
    if (user == null) {
      throw const AuthFailure('Invalid phone or password');
    }
    await _localDataSource.saveUserSession(user);
    return user;
  }

  @override
  Future<void> logout() async {
    await _localDataSource.clearSession();
  }

  @override
  Future<User?> getCurrentUser() async {
    return _localDataSource.getSavedUser();
  }

  @override
  Future<bool> isLoggedIn() async {
    return _localDataSource.hasSession();
  }
}
