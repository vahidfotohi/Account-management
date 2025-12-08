import '../entities/worker.dart';

abstract class WorkerRepository {
  Future<List<Worker>> getWorkers();
  Future<Worker?> getWorkerById(String id);
  Stream<List<Worker>> watchWorkers();
  Future<void> addWorker(Worker worker);
  Future<void> updateWorker(Worker worker);
  Future<void> deleteWorker(String id);
}