import '../entities/worker.dart';
import '../repositories/worker_repository.dart';

class AddWorkerUseCase {
  final WorkerRepository _repository;

  AddWorkerUseCase(this._repository);

  Future<void> call(Worker worker) {
    if (worker.name.isEmpty) throw Exception('Name cannot be empty');
    return _repository.addWorker(worker);
  }
}