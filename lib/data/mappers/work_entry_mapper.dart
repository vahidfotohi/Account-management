import 'package:drift/drift.dart' as drift;
import 'package:construction_manager/data/local/app_database.dart' as db;
import 'package:construction_manager/features/work_entries/domain/entities/work_entry.dart';

extension WorkEntryMapper on db.WorkEntry {
  WorkEntry toDomain() {
    return WorkEntry(
        id: id,
        workerId: workerId,
        projectId: projectId,
        date: date,
        amount: amount,
        createdAt: createdAt,
        description: description);
  }
}

extension WorkEntryDomainMapper on WorkEntry{
  db.WorkEntriesCompanion toCompanion(){
    return db.WorkEntriesCompanion.insert(
      id:id,
      workerId:workerId,
      projectId:projectId,
      date:date,
      amount:amount,
      description:drift.Value(description),
      createdAt:drift.Value(createdAt),

    );
  }
}