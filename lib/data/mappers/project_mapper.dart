import 'package:drift/drift.dart' as drift;
import 'package:construction_manager/data/local/app_database.dart' as db;
import 'package:construction_manager/features/projects/domain/entities/project.dart';

extension ProjectMapper on db.Project {
  Project toDomain() {
    return Project(
      id: id,
      name: name,
      location: location,
      employerName: employerName,
      isCompleted: isCompleted,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

extension ProjectDomainMapper on Project {
  db.ProjectsCompanion toCompanion() {
    return db.ProjectsCompanion.insert(
      id: id,
      name: name,
      location: drift.Value(location),
      employerName: drift.Value(employerName),
      isCompleted: drift.Value(isCompleted),
      createdAt: drift.Value(createdAt),
      updatedAt: drift.Value(updatedAt),
    );
  }
}