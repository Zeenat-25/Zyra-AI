import 'package:zyra/core/errors/failures.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<User> register(String name, String email, String phone, String password);
  Future<User> login(String email, String password);
  Future<User> loginWithPhone(String phone, String password);
  Future<void> logout();
  Future<User?> getCurrentUser();
  Future<bool> isLoggedIn();
}
