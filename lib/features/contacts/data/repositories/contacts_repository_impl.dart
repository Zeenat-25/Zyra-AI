import 'package:zyra/features/contacts/domain/entities/contact.dart';
import 'package:zyra/features/contacts/domain/repositories/contacts_repository.dart';
import '../datasources/contacts_local_datasource.dart';
import '../models/contact_model.dart';

class ContactsRepositoryImpl implements ContactsRepository {
  final ContactsLocalDataSource _dataSource;

  ContactsRepositoryImpl(this._dataSource);

  @override
  Future<List<Contact>> getContacts(int userId) async {
    return _dataSource.getContactsByUserId(userId);
  }

  @override
  Future<Contact> addContact(Contact contact) async {
    final model = ContactModel(
      userId: contact.userId,
      name: contact.name,
      phone: contact.phone,
      email: contact.email,
      relationship: contact.relationship,
      isEmergencyContact: contact.isEmergencyContact,
      createdAt: contact.createdAt,
    );
    final id = await _dataSource.insertContact(model);
    return contact.copyWith(id: id);
  }

  @override
  Future<void> updateContact(Contact contact) async {
    final model = ContactModel(
      id: contact.id,
      userId: contact.userId,
      name: contact.name,
      phone: contact.phone,
      email: contact.email,
      relationship: contact.relationship,
      isEmergencyContact: contact.isEmergencyContact,
      createdAt: contact.createdAt,
    );
    await _dataSource.updateContact(model);
  }

  @override
  Future<void> deleteContact(int id) async {
    await _dataSource.deleteContact(id);
  }

  @override
  Future<List<Contact>> getEmergencyContacts(int userId) async {
    return _dataSource.getEmergencyContacts(userId);
  }
}
