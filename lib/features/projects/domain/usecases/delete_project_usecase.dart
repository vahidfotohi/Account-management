import '../repositories/project_repository.dart';

class DeleteProjectUseCase {
  final ProjectRepository _repository;

  DeleteProjectUseCase(this._repository);

  Future<void> call(String projectId) {
    return _repository.deleteProject(projectId);
  }
}