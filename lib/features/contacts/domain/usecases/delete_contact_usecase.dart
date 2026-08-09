import '../repositories/contacts_repository.dart';

class DeleteContactUseCase {
  final ContactsRepository _repository;

  DeleteContactUseCase(this._repository);

  Future<void> call(int id) {
    return _repository.deleteContact(id);
  }
}
