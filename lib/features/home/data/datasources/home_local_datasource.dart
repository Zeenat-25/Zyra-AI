import 'package:sqflite/sqflite.dart';
import 'package:zyra/core/services/database_service.dart';
import 'package:zyra/core/services/preferences_service.dart';
import 'package:zyra/core/constants/app_constants.dart';

class HomeLocalDataSource {
  Future<int> getEmergencyContactsCount(int userId) async {
    final db = await DatabaseService.database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM contacts WHERE userId = ? AND isEmergencyContact = 1',
      [userId],
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<bool> isVoiceDetectionEnabled() async {
    return await PreferencesService.getBool(
          AppConstants.prefKeyVoiceDetection,
        ) ??
        false;
  }

  Future<String?> getLastLocation() async {
    return PreferencesService.getString('last_location');
  }
}
