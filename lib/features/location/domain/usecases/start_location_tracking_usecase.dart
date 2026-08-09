import '../entities/location_data.dart';
import '../repositories/location_repository.dart';

class StartLocationTrackingUseCase {
  final LocationRepository _repository;

  StartLocationTrackingUseCase(this._repository);

  Stream<LocationData> call({int intervalMs = 30000}) {
    return _repository.trackLocation(intervalMs: intervalMs);
  }
}
