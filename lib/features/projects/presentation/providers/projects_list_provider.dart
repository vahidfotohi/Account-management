import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:construction_manager/features/projects/domain/entities/project.dart';
import 'package:construction_manager/core/di/dependency_injection.dart';

part 'projects_list_provider.g.dart';

@riverpod
Stream<List<Project>> projectsList(Ref ref) {
  final useCase = ref.watch(watchProjectsUseCaseProvider);
  return useCase();
}