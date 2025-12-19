import 'package:freezed_annotation/freezed_annotation.dart';

part 'work_entry.freezed.dart';

@freezed
class WorkEntry with _$WorkEntry {
  const factory WorkEntry({
    required String id,
    required String workerId,
    required String projectId,
    required DateTime date,
    required double amount,
    String? description,
    required double wageAtTime,
    required DateTime createdAt,
  }) = _WorkEntry;
}
