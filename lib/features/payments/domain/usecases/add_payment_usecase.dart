import '../entities/payment.dart';
import '../repositories/payment_repository.dart';

class AddPaymentUseCase {
  final PaymentRepository _repo;
  AddPaymentUseCase(this._repo);
  Future<void> call(Payment payment) => _repo.addPayment(payment);
}