import 'package:construction_manager/data/mappers/worker_mapper.dart';

// 1. ایمپورت دیتابیس با نام مستعار db
import 'package:construction_manager/data/local/app_database.dart' as db;

// 2. ایمپورت Worker دامین
import 'package:construction_manager/features/workers/domain/entities/worker.dart';
import 'package:construction_manager/features/workers/domain/repositories/worker_repository.dart';

class WorkerRepositoryImpl implements WorkerRepository {
  // استفاده از db.AppDatabase
  final db.AppDatabase _db;

  WorkerRepositoryImpl(this._db);

  @override
  Future<void> addWorker(Worker worker) async {
    // تبدیل worker دامین به companion دیتابیس
    await _db.into(_db.workers).insert(worker.toCompanion());
  }

  @override
  Stream<List<Worker>> watchWorkers() {
    return _db.select(_db.workers).watch().map(
      // تبدیل لیست دیتابیسی (db.Worker) به لیست دامین (Worker)
          (rows) => rows.map((row) => row.toDomain()).toList(),
    );
  }

  @override
  Future<List<Worker>> getWorkers() async {
    final rows = await _db.select(_db.workers).get();
    return rows.map((row) => row.toDomain()).toList();
  }

  @override
  Future<Worker?> getWorkerById(String id) async {
    final row = await (_db.select(_db.workers)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
    return row?.toDomain();
  }

  @override
  Future<void> updateWorker(Worker worker) async {
    await _db.update(_db.workers).replace(worker.toCompanion());
  }

  @override
  Future<void> deleteWorker(String id) async {
    await _db.transaction(() async {
      // ۱. حذف تمام کارکردهای این کارگر
      await (_db.delete(_db.workEntries)..where((tbl) => tbl.workerId.equals(id))).go();

      // ۲. حذف تمام پرداختی‌های این کارگر
      await (_db.delete(_db.payments)..where((tbl) => tbl.workerId.equals(id))).go();

      // ۳. حذف خود کارگر
      await (_db.delete(_db.workers)..where((tbl) => tbl.id.equals(id))).go();
    });
  }
}