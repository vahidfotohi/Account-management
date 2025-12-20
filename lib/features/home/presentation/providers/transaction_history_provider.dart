import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:construction_manager/core/di/dependency_injection.dart';
import 'package:rxdart/rxdart.dart';

import '../../../payments/domain/entities/payment.dart';
import '../../../receipts/domain/entities/receipt.dart'; // برای ترکیب استریم‌ها (flutter pub add rxdart)

part 'transaction_history_provider.g.dart';

enum TransactionType { income, expense }

class FinancialTransaction {
  final String id;
  final double amount;
  final DateTime date;
  final String title;
  final String? description;
  final TransactionType type;
  final dynamic originalEntity;

  FinancialTransaction({
    required this.id,
    required this.amount,
    required this.date,
    required this.title,
    this.description,
    required this.type,
    required this.originalEntity,
  });
}

@riverpod
Stream<List<FinancialTransaction>> transactionHistoryList(Ref ref) {
  final db = ref.watch(appDatabaseProvider);

  // ۱. استریم پرداخت‌ها (به همراه نام کارگر)
  final paymentsStream = db.select(db.payments).join([
    innerJoin(db.workers, db.workers.id.equalsExp(db.payments.workerId)),
  ]).watch().map((rows) {
    return rows.map((row) {
      final paymentRow = row.readTable(db.payments); // This is the Drift Data Class
      final workerRow = row.readTable(db.workers);

      // Manually map to Domain Entity to avoid 'toDomain' issues
      // OR ensure payment_mapper.dart is imported.
      // Let's pass the raw Drift object's data to a new Domain Entity:
      final paymentEntity = Payment(
        id: paymentRow.id,
        workerId: paymentRow.workerId,
        amount: paymentRow.amount,
        date: paymentRow.date,
        description: paymentRow.description,
      );

      return FinancialTransaction(
        id: paymentRow.id,
        amount: paymentRow.amount,
        date: paymentRow.date,
        title: workerRow.name,
        description: paymentRow.description,
        type: TransactionType.expense,
        originalEntity: paymentEntity, // Pass the clean Domain Entity
      );
    }).toList();
  });

  // ۲. استریم دریافتی‌ها (به همراه نام پروژه)
  // 2. Receipts
  final receiptsStream = db.select(db.receipts).join([
    innerJoin(db.projects, db.projects.id.equalsExp(db.receipts.projectId)),
  ]).watch().map((rows) {
    return rows.map((row) {
      final receiptRow = row.readTable(db.receipts);
      final projectRow = row.readTable(db.projects);

      final receiptEntity = Receipt(
        id: receiptRow.id,
        projectId: receiptRow.projectId,
        amount: receiptRow.amount,
        date: receiptRow.date,
        description: receiptRow.description,
      );

      return FinancialTransaction(
        id: receiptRow.id,
        amount: receiptRow.amount,
        date: receiptRow.date,
        title: projectRow.name,
        description: receiptRow.description,
        type: TransactionType.income,
        originalEntity: receiptEntity, // Pass the clean Domain Entity
      );
    }).toList();
  });

  // ۳. ترکیب دو لیست و مرتب‌سازی
  return Rx.combineLatest2(paymentsStream, receiptsStream,
          (List<FinancialTransaction> expenses, List<FinancialTransaction> incomes) {
        final all = [...expenses, ...incomes];
        // مرتب‌سازی بر اساس تاریخ (جدیدترین بالا)
        all.sort((a, b) => b.date.compareTo(a.date));
        return all;
      }
  );
}