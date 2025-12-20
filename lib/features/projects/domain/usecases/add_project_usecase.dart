import '../entities/project.dart' ;
import '../repositories/project_repository.dart';

class AddProjectUseCase {
  final ProjectRepository _repository;
  AddProjectUseCase(this._repository);

  Future<void> call(Project project) => _repository.addProject(project);
}