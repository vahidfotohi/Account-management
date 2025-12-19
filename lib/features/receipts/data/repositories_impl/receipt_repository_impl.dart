import 'package:drift/drift.dart';
import 'package:construction_manager/data/local/app_database.dart' as db;
import 'package:construction_manager/features/receipts/domain/entities/receipt.dart';
import 'package:construction_manager/features/receipts/domain/repositories/receipt_repository.dart';
import 'package:construction_manager/data/mappers/receipt_mapper.dart';

class ReceiptRepositoryImpl implements ReceiptRepository {
  final db.AppDatabase _db;

  ReceiptRepositoryImpl(this._db);

  @override
  Future<void> addReceipt(Receipt receipt) async {
    await _db.into(_db.receipts).insert(receipt.toCompanion());
  }

  @override
  Future<void> deleteReceipt(String id) async {
    await (_db.delete(_db.receipts)..where((tbl) => tbl.id.equals(id))).go();
  }

  @override
  Stream<List<Receipt>> watchReceiptsByProject(String projectId) {
    return (_db.select(_db.receipts)
      ..where((tbl) => tbl.projectId.equals(projectId))
      ..orderBy([(t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc)]))
        .watch()
        .map((rows) => rows.map((row) => row.toDomain()).toList());
  }

  @override
  Future<void> updateReceipt(Receipt receipt) async {
    await _db.update(_db.receipts).replace(receipt.toCompanion());
  }
}