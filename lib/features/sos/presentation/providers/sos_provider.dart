import 'package:flutter/material.dart';
import 'package:zyra/core/services/location_service.dart';
import 'package:zyra/features/sos/data/datasources/sos_local_datasource.dart';
import 'package:zyra/features/sos/data/repositories/sos_repository_impl.dart';
import 'package:zyra/features/sos/domain/entities/sos_alert.dart';
import 'package:zyra/features/sos/domain/usecases/trigger_sos_usecase.dart';

class SosProvider extends ChangeNotifier {
  final SosRepositoryImpl _repository;
  final TriggerSosUseCase _triggerSosUseCase;

  SosAlert? _currentAlert;
  List<SosAlert> _alertHistory = [];
  bool _isLoading = false;
  bool _isTriggered = false;
  int _countdown = 0;

  SosProvider()
      : _repository = SosRepositoryImpl(SosLocalDataSource()),
        _triggerSosUseCase = TriggerSosUseCase(
          SosRepositoryImpl(SosLocalDataSource()),
        );

  SosAlert? get currentAlert => _currentAlert;
  List<SosAlert> get alertHistory => _alertHistory;
  bool get isLoading => _isLoading;
  bool get isTriggered => _isTriggered;
  int get countdown => _countdown;

  Future<void> triggerSos(int userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final position = await LocationService.getCurrentLocation();

      _currentAlert = await _triggerSosUseCase(
        userId,
        position.latitude,
        position.longitude,
        'manual_button',
      );

      _isTriggered = true;
      _startCountdown();
    } catch (e) {
      _currentAlert = await _triggerSosUseCase(
        userId,
        null,
        null,
        'manual_button',
      );
      _isTriggered = true;
      _startCountdown();
    }

    _isLoading = false;
    notifyListeners();
  }

  void _startCountdown() {
    _countdown = 10;
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (_countdown > 0) {
        _countdown--;
        notifyListeners();
        return true;
      }
      return false;
    });
  }

  Future<void> resolveSos() async {
    if (_currentAlert?.id != null) {
      await _repository.resolveSos(_currentAlert!.id!);
    }
    _isTriggered = false;
    _currentAlert = null;
    notifyListeners();
  }

  Future<void> loadAlertHistory(int userId) async {
    _alertHistory = await _repository.getAlertHistory(userId);
    notifyListeners();
  }

  Future<void> triggerVoiceSos(int userId, String keyword) async {
    _isLoading = true;
    notifyListeners();

    try {
      final position = await LocationService.getCurrentLocation();
      _currentAlert = await _triggerSosUseCase(
        userId,
        position.latitude,
        position.longitude,
        'voice_$keyword',
      );
    } catch (e) {
      _currentAlert = await _triggerSosUseCase(
        userId,
        null,
        null,
        'voice_$keyword',
      );
    }

    _isTriggered = true;
    _isLoading = false;
    _startCountdown();
    notifyListeners();
  }
}
