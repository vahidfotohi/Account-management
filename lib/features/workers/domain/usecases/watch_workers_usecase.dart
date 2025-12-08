import '../entities/worker.dart';
import '../repositories/worker_repository.dart';

class WatchWorkersUseCase {
  final WorkerRepository _repository;

  WatchWorkersUseCase(this._repository);

  Stream<List<Worker>> call() {
    return _repository.watchWorkers();
  }
}