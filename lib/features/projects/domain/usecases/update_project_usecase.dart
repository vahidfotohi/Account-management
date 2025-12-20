import '../entities/project.dart';
import '../repositories/project_repository.dart';

class UpdateProjectUseCase {
  final ProjectRepository _repository;

  UpdateProjectUseCase(this._repository);

  Future<void> call(Project project) {
    return _repository.updateProject(project);
  }
}