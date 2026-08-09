import 'package:zyra/core/errors/failures.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository _repository;

  RegisterUseCase(this._repository);

  Future<User> call(String name, String email, String phone, String password) async {
    final user = await _repository.register(name, email, phone, password);
    return user;
  }
}
