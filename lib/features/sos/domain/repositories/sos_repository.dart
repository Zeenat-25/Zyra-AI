import '../entities/sos_alert.dart';

abstract class SosRepository {
  Future<SosAlert> triggerSos(int userId, double? latitude, double? longitude, String triggerType);
  Future<void> resolveSos(int alertId);
  Future<List<SosAlert>> getAlertHistory(int userId);
}
