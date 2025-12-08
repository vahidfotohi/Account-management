import '../entities/project.dart';
import '../repositories/project_repository.dart';

class WatchProjectsUseCase {
  final ProjectRepository _repository;
  WatchProjectsUseCase(this._repository);

  Stream<List<Project>> call() => _repository.watchProjects();
}