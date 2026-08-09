import 'package:zyra/core/errors/failures.dart';
import 'package:zyra/features/sos/domain/entities/sos_alert.dart';
import 'package:zyra/features/sos/domain/repositories/sos_repository.dart';
import '../datasources/sos_local_datasource.dart';
import '../models/sos_alert_model.dart';

class SosRepositoryImpl implements SosRepository {
  final SosLocalDataSource _dataSource;

  SosRepositoryImpl(this._dataSource);

  @override
  Future<SosAlert> triggerSos(
    int userId,
    double? latitude,
    double? longitude,
    String triggerType,
  ) async {
    final now = DateTime.now().toIso8601String();
    final alert = SosAlertModel(
      userId: userId,
      latitude: latitude,
      longitude: longitude,
      triggerType: triggerType,
      createdAt: now,
    );

    final id = await _dataSource.insertAlert(alert);
    return SosAlert(
      id: id,
      userId: userId,
      latitude: latitude,
      longitude: longitude,
      triggerType: triggerType,
      createdAt: now,
    );
  }

  @override
  Future<void> resolveSos(int alertId) async {
    await _dataSource.updateAlertStatus(
      alertId,
      'resolved',
      DateTime.now().toIso8601String(),
    );
  }

  @override
  Future<List<SosAlert>> getAlertHistory(int userId) async {
    return _dataSource.getAlertsByUserId(userId);
  }
}
