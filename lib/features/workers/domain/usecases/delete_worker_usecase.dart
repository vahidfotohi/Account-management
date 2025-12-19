import '../repositories/worker_repository.dart';

class DeleteWorkerUseCase {
  final WorkerRepository _repository;

  DeleteWorkerUseCase(this._repository);

  Future<void> call(String workerId) {
    return _repository.deleteWorker(workerId);
  }
}