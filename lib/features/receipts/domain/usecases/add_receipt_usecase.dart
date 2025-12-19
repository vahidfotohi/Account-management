import '../entities/receipt.dart';
import '../repositories/receipt_repository.dart';

class AddReceiptUseCase {
  final ReceiptRepository _repository;
  AddReceiptUseCase(this._repository);
  Future<void> call(Receipt receipt) {
    return _repository.addReceipt(receipt);
  }
}
