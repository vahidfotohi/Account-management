import '../entities/receipt.dart';

abstract class ReceiptRepository {
  Future<void> addReceipt(Receipt receipt);
  Future<void> deleteReceipt(String id);
  Stream<List<Receipt>> watchReceiptsByProject(String projectId);
  Future<void> updateReceipt(Receipt receipt);
}