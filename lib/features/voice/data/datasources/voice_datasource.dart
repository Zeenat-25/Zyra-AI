import 'package:sqflite/sqflite.dart';
import 'package:zyra/core/services/database_service.dart';
import '../models/voice_command_model.dart';

class VoiceDataSource {
  Future<int> insertCommand(VoiceCommandModel command) async {
    final db = await DatabaseService.database;
    return db.insert('voice_commands', command.toMap());
  }

  Future<List<VoiceCommandModel>> getActiveCommands() async {
    final db = await DatabaseService.database;
    final maps = await db.query(
      'voice_commands',
      where: 'isActive = ?',
      whereArgs: [1],
    );
    return maps.map((m) => VoiceCommandModel.fromMap(m)).toList();
  }

  Future<List<VoiceCommandModel>> getAllCommands() async {
    final db = await DatabaseService.database;
    final maps = await db.query('voice_commands', orderBy: 'createdAt DESC');
    return maps.map((m) => VoiceCommandModel.fromMap(m)).toList();
  }

  Future<void> updateCommandStatus(int id, bool isActive) async {
    final db = await DatabaseService.database;
    await db.update(
      'voice_commands',
      {'isActive': isActive ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteCommand(int id) async {
    final db = await DatabaseService.database;
    await db.delete('voice_commands', where: 'id = ?', whereArgs: [id]);
  }
}
