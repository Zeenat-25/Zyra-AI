import '../entities/sos_alert.dart';
import '../repositories/sos_repository.dart';

class TriggerSosUseCase {
  final SosRepository _repository;

  TriggerSosUseCase(this._repository);

  Future<SosAlert> call(int userId, double? latitude, double? longitude, String triggerType) {
    return _repository.triggerSos(userId, latitude, longitude, triggerType);
  }
}
