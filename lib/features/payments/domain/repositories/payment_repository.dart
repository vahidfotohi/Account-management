import '../entities/payment.dart';

abstract class PaymentRepository {
  Future<void> addPayment(Payment payment);
  Future<void> deletePayment(String id);
  Future<void> updatePayment(Payment payment);
  Stream<List<Payment>> watchPaymentsByWorker(String workerId);
}