import 'package:flutter/material.dart';
import 'package:zyra/features/contacts/data/datasources/contacts_local_datasource.dart';
import 'package:zyra/features/contacts/data/repositories/contacts_repository_impl.dart';
import 'package:zyra/features/contacts/domain/entities/contact.dart';
import 'package:zyra/features/contacts/domain/usecases/add_contact_usecase.dart';
import 'package:zyra/features/contacts/domain/usecases/get_contacts_usecase.dart';
import 'package:zyra/features/contacts/domain/usecases/delete_contact_usecase.dart';

class ContactsProvider extends ChangeNotifier {
  final ContactsRepositoryImpl _repository;
  final GetContactsUseCase _getContactsUseCase;
  final AddContactUseCase _addContactUseCase;
  final DeleteContactUseCase _deleteContactUseCase;

  List<Contact> _contacts = [];
  List<Contact> _emergencyContacts = [];
  bool _isLoading = false;

  ContactsProvider()
      : _repository = ContactsRepositoryImpl(ContactsLocalDataSource()),
        _getContactsUseCase = GetContactsUseCase(
          ContactsRepositoryImpl(ContactsLocalDataSource()),
        ),
        _addContactUseCase = AddContactUseCase(
          ContactsRepositoryImpl(ContactsLocalDataSource()),
        ),
        _deleteContactUseCase = DeleteContactUseCase(
          ContactsRepositoryImpl(ContactsLocalDataSource()),
        );

  List<Contact> get contacts => _contacts;
  List<Contact> get emergencyContacts => _emergencyContacts;
  bool get isLoading => _isLoading;

  Future<void> loadContacts(int userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _contacts = await _getContactsUseCase(userId);
      _emergencyContacts = await _repository.getEmergencyContacts(userId);
    } catch (e) {
      _contacts = [];
      _emergencyContacts = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addContact(Contact contact) async {
    await _addContactUseCase(contact);
    await loadContacts(contact.userId);
  }

  Future<void> deleteContact(int id, int userId) async {
    await _deleteContactUseCase(id);
    await loadContacts(userId);
  }

  Future<void> toggleEmergencyStatus(Contact contact) async {
    final updated = contact.copyWith(
      isEmergencyContact: !contact.isEmergencyContact,
    );
    await _repository.updateContact(updated);
    await loadContacts(contact.userId);
  }
}
