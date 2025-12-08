
import '../entities/work_entry.dart';

abstract class WorkEntryRepository {
  Future<void> addWorkEntry(WorkEntry entry);
  Future<void> deleteWorkEntry(String id);

  Stream<List<WorkEntry>> watchEntriesByProject(String projectId);
  Stream<List<WorkEntry>> watchEntriesByWorker(String workerId);
}


