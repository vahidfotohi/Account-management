import 'package:drift/drift.dart' as drift;

import '../local/app_database.dart' as db;
import 'package:construction_manager/features/workers/domain/entities/worker.dart';
extension WorkerMapper on db.Worker {
  Worker toDomain() {
    return Worker(
      id: id,
      name: name,
      jobTitle: jobTitle,
      wageType: WageType.values[wageType], // Simple int to enum
      baseWage: baseWage,
      isActive: isActive,
      phoneNumber: phoneNumber,
      cardNumber: cardNumber,
      initialDebt: initialDebt,
      shebaNumber: shebaNumber,
      notes: notes,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

extension WorkerDomainMapper on Worker {
  db.WorkersCompanion toCompanion() {
    return db.WorkersCompanion.insert(
      id: id,
      name: name,
      jobTitle: drift.Value(jobTitle),
      wageType: wageType.index,
      baseWage: baseWage,
      isActive: drift.Value(isActive),
      phoneNumber: drift.Value(phoneNumber),
      shebaNumber: drift.Value(shebaNumber),
      cardNumber: drift.Value(cardNumber),
      initialDebt: drift.Value(initialDebt ?? 0),
      notes: drift.Value(notes),
      createdAt: drift.Value(createdAt),
      updatedAt: drift.Value(updatedAt),
    );
  }
}
