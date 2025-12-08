import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../domain/entities/worker.dart';

part 'workers_list_provider.g.dart';

@riverpod
class WorkersList extends _$WorkersList {
  @override
  Stream<List<Worker>> build() {
    final useCase = ref.watch(watchWorkersUseCaseProvider);
    return useCase();
  }

  // متد کمکی برای حذف (اختیاری، می‌تواند در کنترلی جدا باشد)
  Future<void> deleteWorker(String id) async {
    final repo = ref.read(workerRepositoryProvider);
    await repo.deleteWorker(id);
    // استریم خودکار آپدیت می‌شود
  }
}