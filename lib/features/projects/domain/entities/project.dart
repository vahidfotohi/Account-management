
import 'package:freezed_annotation/freezed_annotation.dart';
part 'project.freezed.dart';
@freezed
class Project with _$Project {
  const factory Project({
    required String id,
    required String name,
    String? location,
    String? employerName,
    required bool isCompleted,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Project;

}