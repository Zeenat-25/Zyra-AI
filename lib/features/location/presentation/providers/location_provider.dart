import 'dart:async';
import 'package:flutter/material.dart';
import 'package:zyra/core/errors/failures.dart';
import 'package:zyra/features/location/data/datasources/location_datasource.dart';
import 'package:zyra/features/location/data/repositories/location_repository_impl.dart';
import 'package:zyra/features/location/domain/entities/location_data.dart';

class LocationProvider extends ChangeNotifier {
  final LocationRepositoryImpl _repository;
  LocationData? _currentLocation;
  bool _isTracking = false;
  bool _isLoading = false;
  String? _error;
  StreamSubscription<LocationData>? _trackingSubscription;

  LocationProvider()
      : _repository = LocationRepositoryImpl(LocationDataSource());

  LocationData? get currentLocation => _currentLocation;
  bool get isTracking => _isTracking;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> getCurrentLocation() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _currentLocation = await _repository.getCurrentLocation();
    } on Failure catch (e) {
      _error = e.message;
    } catch (e) {
      _error = 'Failed to get location';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> startTracking() async {
    _isTracking = true;
    notifyListeners();

    _trackingSubscription = _repository.trackLocation().listen(
      (location) {
        _currentLocation = location;
        notifyListeners();
      },
      onError: (error) {
        _error = error.toString();
        _isTracking = false;
        notifyListeners();
      },
    );
  }

  Future<void> stopTracking() async {
    await _trackingSubscription?.cancel();
    _isTracking = false;
    notifyListeners();
  }

  Future<String> getAddress() async {
    if (_currentLocation == null) return 'Unknown';
    return _repository.getAddressFromCoordinates(
      _currentLocation!.latitude,
      _currentLocation!.longitude,
    );
  }

  @override
  void dispose() {
    _trackingSubscription?.cancel();
    super.dispose();
  }
}
