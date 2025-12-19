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
}