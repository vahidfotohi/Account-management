


import '../entities/work_entry.dart';
import '../repositories/work_entry_repository.dart';

class AddWorkEntryUseCase {
  final WorkEntryRepository _repository;
  AddWorkEntryUseCase(this._repository);

Future<void> call(WorkEntry entry) => _repository.addWorkEntry(entry);
}