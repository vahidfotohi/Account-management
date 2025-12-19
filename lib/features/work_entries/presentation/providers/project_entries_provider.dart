import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:construction_manager/features/work_entries/domain/entities/work_entry.dart';
import 'package:construction_manager/core/di/dependency_injection.dart';

part 'project_entries_provider.g.dart';

// این پرووایدر یک projectId می‌گیرد و استریم مربوط به آن را برمی‌گرداند
@riverpod
Stream<List<WorkEntry>> projectEntries(Ref ref, String projectId) {
  final repository = ref.watch(workEntryRepositoryProvider);
  return repository.watchEntriesByProject(projectId);
}