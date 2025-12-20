import 'package:freezed_annotation/freezed_annotation.dart';
part 'receipt.freezed.dart';

@freezed
class Receipt with _$Receipt {
  const factory Receipt({
    required String id,
    required String projectId,
    required double amount,
    required DateTime date,
    String? description,
  }) = _Receipt;
}