
import '../entities/project.dart';

abstract class ProjectRepository {
  Future<void> addProject(Project project);
  Stream<List<Project>> watchProjects();
  Future<Project?> getProjectById(String id);
  Future<void> updateProject(Project project);
  Future<void> deleteProject(String id);
}
