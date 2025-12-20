import '../entities/worker.dart';
import '../repositories/worker_repository.dart';

class UpdateWorkerUseCase {
  final WorkerRepository _repository;

  UpdateWorkerUseCase(this._repository);

  Future<void> call(Worker worker) {
    return _repository.updateWorker(worker);
  }
}