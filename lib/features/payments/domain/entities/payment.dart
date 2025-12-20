import 'package:freezed_annotation/freezed_annotation.dart';
part 'payment.freezed.dart';

@freezed
class Payment with _$Payment {
  const factory Payment({
    required String id,
    required String workerId,
    required double amount,
    required DateTime date,
    String? description,
  }) = _Payment;
}