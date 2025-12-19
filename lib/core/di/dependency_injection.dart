import 'package:construction_manager/features/work_entries/domain/repositories/work_entry_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/local/app_database.dart';
// ایمپورت‌های پروژه و ورکر
import '../../features/payments/data/repositories_impl/payment_repository_impl.dart';
import '../../features/payments/domain/repositories/payment_repository.dart';
import '../../features/payments/domain/usecases/add_payment_usecase.dart';
import '../../features/projects/data/repositories_impl/project_repository_impl.dart';
import '../../features/projects/domain/repositories/project_repository.dart';
import '../../features/projects/domain/usecases/add_project_usecase.dart';
import '../../features/projects/domain/usecases/delete_project_usecase.dart';
import '../../features/projects/domain/usecases/update_project_usecase.dart';
import '../../features/projects/domain/usecases/watch_projects_usecase.dart';
import '../../features/receipts/data/repositories_impl/receipt_repository_impl.dart';
import '../../features/receipts/domain/repositories/receipt_repository.dart';
import '../../features/receipts/domain/usecases/add_receipt_usecase.dart';
import '../../features/settings/data/backup_repository.dart';
import '../../features/workers/data/repositories_impl/worker_repository_impl.dart';
import '../../features/workers/domain/repositories/worker_repository.dart'; // اینترفیس ورکر
import '../../features/workers/domain/usecases/add_worker_usecase.dart';
import '../../features/workers/domain/usecases/delete_worker_usecase.dart';
import '../../features/workers/domain/usecases/update_worker_usecase.dart';
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

@riverpod
WatchWorkersUseCase watchWorkersUseCase(Ref ref) {
  return WatchWorkersUseCase(ref.watch(workerRepositoryProvider));
}

@riverpod
AddWorkerUseCase addWorkerUseCase(Ref ref) {
  return AddWorkerUseCase(ref.watch(workerRepositoryProvider));
}

@riverpod
UpdateWorkerUseCase updateWorkerUseCase(Ref ref) {
  return UpdateWorkerUseCase(ref.watch(workerRepositoryProvider));
}

@riverpod
DeleteWorkerUseCase deleteWorkerUseCase(Ref ref) {
  return DeleteWorkerUseCase(ref.watch(workerRepositoryProvider));
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

@riverpod
UpdateProjectUseCase updateProjectUseCase(Ref ref) {
  return UpdateProjectUseCase(ref.watch(projectRepositoryProvider));
}

@riverpod
DeleteProjectUseCase deleteProjectUseCase(Ref ref) {
  return DeleteProjectUseCase(ref.watch(projectRepositoryProvider));
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

// --- PAYMENTS DI ---
@riverpod
PaymentRepository paymentRepository(Ref ref) {
  return PaymentRepositoryImpl(ref.watch(appDatabaseProvider));
}

@riverpod
AddPaymentUseCase addPaymentUseCase(Ref ref) {
  return AddPaymentUseCase(ref.watch(paymentRepositoryProvider));
}

// --- RECEIPTS DI ---
@riverpod
ReceiptRepository receiptRepository(Ref ref) {
  return ReceiptRepositoryImpl(ref.watch(appDatabaseProvider));
}

@riverpod
AddReceiptUseCase addReceiptUseCase(Ref ref) {
  return AddReceiptUseCase(ref.watch(receiptRepositoryProvider));
}

// --- SETTINGS & BACKUP DI ---

@riverpod
BackupRepository backupRepository(Ref ref) {
  return BackupRepository(ref.watch(appDatabaseProvider));
}

