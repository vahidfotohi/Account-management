import 'package:freezed_annotation/freezed_annotation.dart';

part 'worker.freezed.dart';

enum WageType {
  daily,
  hourly,
  metri;

  String get label {
    switch (this) {
      case WageType.daily:
        return 'روزانه';
      case WageType.hourly:
        return 'ساعتی';
      case WageType.metri:
        return 'متری';
    }
  }
}

@freezed
class Worker with _$Worker {
  const factory Worker({
    required String id,
    required String name,
    String? jobTitle,
    required WageType wageType,
    required double baseWage,
    required bool isActive,
    String? phoneNumber,
    String? cardNumber,
    String? shebaNumber,
    double? initialDebt,
    String? notes,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Worker;
}
