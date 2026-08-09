import 'package:zyra/core/errors/failures.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository _repository;

  LoginUseCase(this._repository);

  Future<User> call(String email, String password) async {
    final user = await _repository.login(email, password);
    return user;
  }
}

class LoginWithPhoneUseCase {
  final AuthRepository _repository;

  LoginWithPhoneUseCase(this._repository);

  Future<User> call(String phone, String password) async {
    final user = await _repository.loginWithPhone(phone, password);
    return user;
  }
}
