import '../entities/contact.dart';
import '../repositories/contacts_repository.dart';

class AddContactUseCase {
  final ContactsRepository _repository;

  AddContactUseCase(this._repository);

  Future<Contact> call(Contact contact) {
    return _repository.addContact(contact);
  }
}
