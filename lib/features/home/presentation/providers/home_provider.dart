import 'package:flutter/material.dart';
import 'package:zyra/features/home/data/datasources/home_local_datasource.dart';
import 'package:zyra/features/home/data/repositories/home_repository_impl.dart';
import 'package:zyra/features/home/domain/entities/home_data.dart';
import 'package:zyra/features/home/domain/usecases/get_home_data_usecase.dart';

class HomeProvider extends ChangeNotifier {
  final HomeRepositoryImpl _repository;
  final GetHomeDataUseCase _getHomeDataUseCase;

  HomeData? _homeData;
  bool _isLoading = false;

  HomeProvider()
      : _repository = HomeRepositoryImpl(HomeLocalDataSource()),
        _getHomeDataUseCase = GetHomeDataUseCase(
          HomeRepositoryImpl(HomeLocalDataSource()),
        );

  HomeData? get homeData => _homeData;
  bool get isLoading => _isLoading;

  Future<void> loadHomeData(int userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _homeData = await _getHomeDataUseCase(userId);
    } catch (e) {
      _homeData = HomeData(greeting: 'Welcome');
    }

    _isLoading = false;
    notifyListeners();
  }

  void updateVoiceDetection(bool enabled) {
    if (_homeData != null) {
      _homeData = HomeData(
        greeting: _homeData!.greeting,
        emergencyContactsCount: _homeData!.emergencyContactsCount,
        voiceDetectionEnabled: enabled,
        lastLocation: _homeData!.lastLocation,
      );
      notifyListeners();
    }
  }
}
