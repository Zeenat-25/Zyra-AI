import '../entities/contact.dart';
import '../repositories/contacts_repository.dart';

class GetContactsUseCase {
  final ContactsRepository _repository;

  GetContactsUseCase(this._repository);

  Future<List<Contact>> call(int userId) {
    return _repository.getContacts(userId);
  }
}
