import 'package:flutter/material.dart';
import 'package:zyra/core/errors/failures.dart';
import 'package:zyra/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:zyra/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:zyra/features/auth/domain/entities/user.dart';
import 'package:zyra/features/auth/domain/usecases/login_usecase.dart';
import 'package:zyra/features/auth/domain/usecases/register_usecase.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepositoryImpl _authRepository;
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;

  User? _currentUser;
  bool _isLoading = false;
  String? _error;

  AuthProvider()
      : _authRepository = AuthRepositoryImpl(AuthLocalDataSource()),
        _loginUseCase = LoginUseCase(
          AuthRepositoryImpl(AuthLocalDataSource()),
        ),
        _registerUseCase = RegisterUseCase(
          AuthRepositoryImpl(AuthLocalDataSource()),
        );

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLoggedIn => _currentUser != null;

  Future<void> checkAuth() async {
    final loggedIn = await _authRepository.isLoggedIn();
    if (loggedIn) {
      _currentUser = await _authRepository.getCurrentUser();
    }
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _currentUser = await _loginUseCase(email, password);
      _isLoading = false;
      notifyListeners();
      return true;
    } on Failure catch (e) {
      _error = e.message;
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _error = 'An unexpected error occurred';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(
    String name,
    String email,
    String phone,
    String password,
  ) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _currentUser = await _registerUseCase(name, email, phone, password);
      _isLoading = false;
      notifyListeners();
      return true;
    } on Failure catch (e) {
      _error = e.message;
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _error = 'An unexpected error occurred';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await _authRepository.logout();
    _currentUser = null;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
