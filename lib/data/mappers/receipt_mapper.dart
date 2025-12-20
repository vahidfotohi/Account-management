import 'package:drift/drift.dart' as drift;
import 'package:construction_manager/data/local/app_database.dart' as db;
import 'package:construction_manager/features/receipts/domain/entities/receipt.dart';

extension ReceiptMapper on db.Receipt {
  Receipt toDomain() => Receipt(
    id: id,
    projectId: projectId,
    amount: amount,
    date: date,
    description: description,
  );
}

extension ReceiptDomainMapper on Receipt {
  db.ReceiptsCompanion toCompanion() => db.ReceiptsCompanion.insert(
    id: id,
    projectId: projectId,
    amount: amount,
    date: date,
    description: drift.Value(description),
  );
}