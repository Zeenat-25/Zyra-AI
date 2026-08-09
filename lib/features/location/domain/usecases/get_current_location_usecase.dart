import '../entities/location_data.dart';
import '../repositories/location_repository.dart';

class GetCurrentLocationUseCase {
  final LocationRepository _repository;

  GetCurrentLocationUseCase(this._repository);

  Future<LocationData> call() {
    return _repository.getCurrentLocation();
  }
}
