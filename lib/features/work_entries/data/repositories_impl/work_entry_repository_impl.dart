import 'package:construction_manager/data/local/app_database.dart' as db;
import 'package:construction_manager/data/mappers/work_entry_mapper.dart';
import 'package:drift/drift.dart';

import '../../domain/entities/work_entry.dart';
import '../../domain/repositories/work_entry_repository.dart';

class WorkEntryRepositoryImpl implements WorkEntryRepository {
  final db.AppDatabase _db;

  WorkEntryRepositoryImpl(this._db);

  @override
  Future<void> addWorkEntry(WorkEntry entry) async {
    await _db.into(_db.workEntries).insert(entry.toCompanion());
  }

  @override
  Future<void> deleteWorkEntry(String id) async {
    await (_db.delete(_db.workEntries)
          ..where(
            (tbl) => tbl.id.equals(id),
          ))
        .go();
  }

  @override
  Stream<List<WorkEntry>> watchEntriesByProject(String projectId) {
    return (_db.select(_db.workEntries)
          ..where((tbl) => tbl.projectId.equals(projectId))
          ..orderBy([
            (t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc)
          ]))
        .watch()
        .map((rows) => rows.map((row) => row.toDomain()).toList());
  }

  @override
  Stream<List<WorkEntry>> watchEntriesByWorker(String workerId) {
    return (_db.select(_db.workEntries)
          ..where((tbl) => tbl.id.equals(workerId))
          ..orderBy([
            (t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc)
          ]))
        .watch()
        .map(
          (rows) => rows.map((e) => e.toDomain()).toList(),
        );
  }


}
