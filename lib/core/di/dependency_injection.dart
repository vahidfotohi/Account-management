import 'package:construction_manager/features/work_entries/domain/repositories/work_entry_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/local/app_database.dart';
// ایمپورت‌های پروژه و ورکر
import '../../features/projects/data/repositories_impl/project_repository_impl.dart';
import '../../features/projects/domain/repositories/project_repository.dart';
import '../../features/projects/domain/usecases/add_project_usecase.dart';
import '../../features/projects/domain/usecases/watch_projects_usecase.dart';
import '../../features/workers/data/repositories_impl/worker_repository_impl.dart';
import '../../features/workers/domain/repositories/worker_repository.dart'; // اینترفیس ورکر
import '../../features/workers/domain/usecases/add_worker_usecase.dart';
import '../../features/workers/domain/usecases/watch_workers_usecase.dart';

// ایمپورت‌های Work Entry (حتما اضافه شود)
import '../../features/work_entries/data/repositories_impl/work_entry_repository_impl.dart';
import '../../features/work_entries/domain/usecases/add_work_entry_usecase.dart';

part 'dependency_injection.g.dart';

// 1. Database Instance
@Riverpod(keepAlive: true)
AppDatabase appDatabase(Ref ref) {
  return AppDatabase();
}

// 2. Repository Instance
@riverpod
WorkerRepository workerRepository(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return WorkerRepositoryImpl(db);
}

// 3. UseCases
@riverpod
WatchWorkersUseCase watchWorkersUseCase(Ref ref) {
  return WatchWorkersUseCase(ref.watch(workerRepositoryProvider));
}

@riverpod
AddWorkerUseCase addWorkerUseCase(Ref ref) {
  return AddWorkerUseCase(ref.watch(workerRepositoryProvider));
}

// --- PROJECTS DI ---

@riverpod
ProjectRepository projectRepository(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return ProjectRepositoryImpl(db);
}

@riverpod
WatchProjectsUseCase watchProjectsUseCase(Ref ref) {
  return WatchProjectsUseCase(ref.watch(projectRepositoryProvider));
}

@riverpod
AddProjectUseCase addProjectUseCase(Ref ref) {
  return AddProjectUseCase(ref.watch(projectRepositoryProvider));
}


// --- WORK ENTRIES DI ---

@riverpod
WorkEntryRepository workEntryRepository(Ref ref){
  final db = ref.watch(appDatabaseProvider);
  return WorkEntryRepositoryImpl(db);
}

// *** اصلاح شده ***
@riverpod
AddWorkEntryUseCase addWorkEntryUseCase(Ref ref) {
  // اینجا باید repository مربوط به work entry پاس داده شود
  return AddWorkEntryUseCase(ref.watch(workEntryRepositoryProvider));
}