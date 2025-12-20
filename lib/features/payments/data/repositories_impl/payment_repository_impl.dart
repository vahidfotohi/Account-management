import 'package:construction_manager/data/local/app_database.dart' as db;
import 'package:construction_manager/features/payments/domain/entities/payment.dart';
import 'package:construction_manager/features/payments/domain/repositories/payment_repository.dart';
import 'package:construction_manager/data/mappers/payment_mapper.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  final db.AppDatabase _db;
  PaymentRepositoryImpl(this._db);

  @override
  Future<void> addPayment(Payment payment) async {
    await _db.into(_db.payments).insert(payment.toCompanion());
  }

  @override
  Future<void> deletePayment(String id) async {
    await (_db.delete(_db.payments)..where((t) => t.id.equals(id))).go();
  }

  @override
  Stream<List<Payment>> watchPaymentsByWorker(String workerId) {
    return (_db.select(_db.payments)..where((t) => t.workerId.equals(workerId)))
        .watch()
        .map((rows) => rows.map((row) => row.toDomain()).toList());
  }

  @override
  Future<void> updatePayment(Payment payment) async {
    await _db.update(_db.payments).replace(payment.toCompanion());
  }
}