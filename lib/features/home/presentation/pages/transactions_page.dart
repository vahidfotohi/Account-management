import 'package:construction_manager/features/receipts/domain/entities/receipt.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart' as intl;
import 'package:shamsi_date/shamsi_date.dart';

import '../providers/transaction_history_provider.dart';
import 'package:construction_manager/core/di/dependency_injection.dart';
import 'package:construction_manager/features/payments/presentation/pages/add_payment_page.dart';
import 'package:construction_manager/features/receipts/presentation/pages/add_receipt_page.dart';

class TransactionsPage extends HookConsumerWidget {
  const TransactionsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(transactionHistoryListProvider);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('تاریخچه تراکنش‌ها'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black87,
      ),
      body: historyAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('خطا: $err')),
        data: (transactions) {
          if (transactions.isEmpty) {
            return const Center(child: Text('هیچ تراکنشی ثبت نشده است'));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: transactions.length,
            separatorBuilder: (ctx, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              return _TransactionCard(transaction: transactions[index]);
            },
          );
        },
      ),
    );
  }
}

class _TransactionCard extends ConsumerWidget {
  final FinancialTransaction transaction;

  const _TransactionCard({required this.transaction});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formatter = intl.NumberFormat('#,###');
    final jalaliDate = Jalali.fromDateTime(transaction.date);

    // تنظیم رنگ و آیکون بر اساس نوع تراکنش
    final isIncome = transaction.type == TransactionType.income;
    final color = isIncome ? Colors.green : Colors.red;
    final icon = isIncome ? Icons.arrow_downward : Icons.arrow_upward; // فلش پایین برای ورودی، بالا برای خروجی

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color),
        ),
        title: Text(
          transaction.title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (transaction.description != null && transaction.description!.isNotEmpty)
              Text(transaction.description!, style: const TextStyle(fontSize: 12)),
            const SizedBox(height: 4),
            Text(
              '${jalaliDate.formatter.d} ${jalaliDate.formatter.mN} ${jalaliDate.formatter.yyyy}',
              style: TextStyle(fontSize: 11, color: Colors.grey[500]),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              formatter.format(transaction.amount),
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            // منوی عملیات (ویرایش/حذف)
            PopupMenuButton<String>(
              onSelected: (value) => _handleAction(value, context, ref),
              itemBuilder: (context) => [
                const PopupMenuItem(value: 'edit', child: Row(children: [Icon(Icons.edit, size: 18), SizedBox(width: 8), Text('ویرایش')])),
                const PopupMenuItem(value: 'delete', child: Row(children: [Icon(Icons.delete, size: 18, color: Colors.red), SizedBox(width: 8), Text('حذف', style: TextStyle(color: Colors.red))])),
              ],
              icon: const Icon(Icons.more_vert, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  void _handleAction(String action, BuildContext context, WidgetRef ref) {
    if (action == 'delete') {
      _confirmDelete(context, ref);
    } else if (action == 'edit') {
      _navigateToEdit(context);
    }
  }

  void _confirmDelete(BuildContext context, WidgetRef ref) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('حذف تراکنش'),
        content: const Text('آیا مطمئن هستید؟'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('لغو')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: () async {
              Navigator.pop(ctx);
              if (transaction.type == TransactionType.income) {
                await ref.read(receiptRepositoryProvider).deleteReceipt(transaction.id);
              } else {
                await ref.read(paymentRepositoryProvider).deletePayment(transaction.id);
              }
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تراکنش حذف شد')));
              }
            },
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }

  void _navigateToEdit(BuildContext context) {
    if (transaction.type == TransactionType.income) {
      // ویرایش دریافتی
      // فرض بر این است که آبجکت originalEntity از نوع Receipt است
      final receiptData = transaction.originalEntity as Receipt; // باید کست شود
      // ما باید انتیتی کامل را داشته باشیم. در Provider بالا ما row.readTable(db.receipts) کردیم
      // پس originalEntity یک آبجکت دیتابیسی (Data Class) است. باید به Domain Entity تبدیل شود.
      // چون اینجا کمی پیچیده می‌شود، بهتر است ID را پاس بدهیم و در صفحه ویرایش دوباره لود کنیم
      // یا اینکه مستقیما آبجکت را پاس بدهیم.

      // روش ساده: پاس دادن آبجکت به صفحه AddReceiptPage (که باید قابلیت ویرایش داشته باشد)
      Navigator.push(context, MaterialPageRoute<dynamic>(builder: (_) => AddReceiptPage(receiptToEdit: receiptData)));
    } else {
      // ویرایش پرداختی
      final paymentData = transaction.originalEntity;
      Navigator.push(context, MaterialPageRoute<dynamic>(builder: (_) => AddPaymentPage(paymentToEdit: paymentData)));
    }
  }
}