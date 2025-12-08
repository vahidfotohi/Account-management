
import '../repositories/work_entry_repository.dart';

class DeleteWorkEntryUseCase {
  final WorkEntryRepository _repository;
  DeleteWorkEntryUseCase(this._repository);

  Future<void> call(String id) => _repository.deleteWorkEntry(id);
}