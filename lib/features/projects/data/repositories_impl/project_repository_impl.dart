import 'package:construction_manager/data/local/app_database.dart' as db;
import 'package:construction_manager/features/projects/domain/entities/project.dart';
import 'package:construction_manager/features/projects/domain/repositories/project_repository.dart';
import 'package:construction_manager/data/mappers/project_mapper.dart';

class ProjectRepositoryImpl implements ProjectRepository {
  final db.AppDatabase _db;

  ProjectRepositoryImpl(this._db);

  @override
  Future<void> addProject(Project project) async {
    await _db.into(_db.projects).insert(project.toCompanion());
  }

  @override
  Stream<List<Project>> watchProjects() {
    return _db.select(_db.projects).watch().map(
          (rows) => rows.map((row) => row.toDomain()).toList(),
        );
  }

  @override
  Future<Project?> getProjectById(String id) async {
    final row = await (_db.select(_db.projects)
          ..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();
    return row?.toDomain();
  }

  @override
  Future<void> deleteProject(String id) async {
    await _db.transaction(() async {
      // ۱. حذف تمام کارکردهای این پروژه
      await (_db.delete(_db.workEntries)
            ..where((tbl) => tbl.projectId.equals(id)))
          .go();

      // ۲. حذف تمام رسیدهای (دریافتی‌های) این پروژه
      // (داخل try/catch می‌گذاریم چون شاید هنوز جدول receipts را نساخته باشید یا مایگریشن نکرده باشید)
      try {
        await (_db.delete(_db.receipts)
              ..where((tbl) => tbl.projectId.equals(id)))
            .go();
      } catch (e) {
        // نادیده گرفتن
      }

      // ۳. در نهایت، حذف خود پروژه
      await (_db.delete(_db.projects)..where((tbl) => tbl.id.equals(id))).go();
    });
  }

  @override
  Future<void> updateProject(Project project) async {
    await _db.update(_db.projects).replace(project.toCompanion());
  }
}
