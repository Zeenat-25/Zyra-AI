import 'package:sqflite/sqflite.dart';
import 'package:zyra/core/services/database_service.dart';
import '../models/contact_model.dart';

class ContactsLocalDataSource {
  Future<int> insertContact(ContactModel contact) async {
    final db = await DatabaseService.database;
    return db.insert('contacts', contact.toMap());
  }

  Future<List<ContactModel>> getContactsByUserId(int userId) async {
    final db = await DatabaseService.database;
    final maps = await db.query(
      'contacts',
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'name ASC',
    );
    return maps.map((m) => ContactModel.fromMap(m)).toList();
  }

  Future<List<ContactModel>> getEmergencyContacts(int userId) async {
    final db = await DatabaseService.database;
    final maps = await db.query(
      'contacts',
      where: 'userId = ? AND isEmergencyContact = 1',
      whereArgs: [userId],
      orderBy: 'name ASC',
    );
    return maps.map((m) => ContactModel.fromMap(m)).toList();
  }

  Future<void> updateContact(ContactModel contact) async {
    final db = await DatabaseService.database;
    await db.update(
      'contacts',
      contact.toMap(),
      where: 'id = ?',
      whereArgs: [contact.id],
    );
  }

  Future<void> deleteContact(int id) async {
    final db = await DatabaseService.database;
    await db.delete('contacts', where: 'id = ?', whereArgs: [id]);
  }
}
