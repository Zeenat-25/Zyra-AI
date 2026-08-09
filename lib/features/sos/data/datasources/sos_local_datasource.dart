import 'package:sqflite/sqflite.dart';
import 'package:zyra/core/services/database_service.dart';
import '../models/sos_alert_model.dart';

class SosLocalDataSource {
  Future<int> insertAlert(SosAlertModel alert) async {
    final db = await DatabaseService.database;
    return db.insert('sos_alerts', alert.toMap());
  }

  Future<void> updateAlertStatus(int id, String status, String? resolvedAt) async {
    final db = await DatabaseService.database;
    await db.update(
      'sos_alerts',
      {
        'status': status,
        if (resolvedAt != null) 'resolvedAt': resolvedAt,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<SosAlertModel>> getAlertsByUserId(int userId) async {
    final db = await DatabaseService.database;
    final maps = await db.query(
      'sos_alerts',
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'createdAt DESC',
    );
    return maps.map((m) => SosAlertModel.fromMap(m)).toList();
  }
}
