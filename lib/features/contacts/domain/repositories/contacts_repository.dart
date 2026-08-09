import '../entities/contact.dart';

abstract class ContactsRepository {
  Future<List<Contact>> getContacts(int userId);
  Future<Contact> addContact(Contact contact);
  Future<void> updateContact(Contact contact);
  Future<void> deleteContact(int id);
  Future<List<Contact>> getEmergencyContacts(int userId);
}
