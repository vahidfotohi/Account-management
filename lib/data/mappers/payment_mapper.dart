import 'package:drift/drift.dart' as drift;
import 'package:construction_manager/data/local/app_database.dart' as db;
import 'package:construction_manager/features/payments/domain/entities/payment.dart';

extension PaymentMapper on db.Payment {
  Payment toDomain() => Payment(
    id: id,
    workerId: workerId,
    amount: amount,
    date: date,
    description: description,
  );
}

extension PaymentDomainMapper on Payment {
  db.PaymentsCompanion toCompanion() => db.PaymentsCompanion.insert(
    id: id,
    workerId: workerId,
    amount: amount,
    date: date,
    description: drift.Value(description),
  );
}