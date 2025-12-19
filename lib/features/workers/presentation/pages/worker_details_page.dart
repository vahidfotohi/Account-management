import 'package:drift/drift.dart' show OrderingTerm, OrderingMode;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart' as intl;
import 'package:shamsi_date/shamsi_date.dart';

import '../../domain/entities/worker.dart';
import '../providers/worker_financials_provider.dart';
import 'package:construction_manager/core/di/dependency_injection.dart';

import '../providers/workers_list_provider.dart';
import 'edit_worker_page.dart'; // برای دسترسی به دیتابیس در لیست‌ها

class WorkerDetailsPage extends HookConsumerWidget {
  final Worker worker;

  const WorkerDetailsPage({super.key, required this.worker});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workersAsync = ref.watch(workersListProvider);
    final liveWorker = workersAsync.maybeWhen(
      data: (workers) => workers.firstWhere(
            (w) => w.id == worker.id,
        orElse: () => worker,
      ),
      orElse: () => worker,
    );
    final statsAsync = ref.watch(workerFinancialsProvider(liveWorker.id));

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: Text(liveWorker.name),
            actions: [
              // دکمه ویرایش
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                tooltip: 'ویرایش مشخصات',
                onPressed: () {
                  // هدایت به صفحه ویرایش
                  // چون این صفحه را در Router تعریف نکرده‌ایم، مستقیم پوش میکنیم (سریعتر)
                  // یا در Router تعریف کنید. اینجا روش مستقیم:
                  Navigator.of(context).push(
                      MaterialPageRoute<dynamic>(builder: (ctx) => EditWorkerPage(worker: liveWorker)),
                  );
                },
              ),
              // دکمه حذف
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                tooltip: 'حذف پرسنل',
                onPressed: () => _confirmDelete(context, ref),
              ),
            ],
          backgroundColor: Colors.white,
          elevation: 0,
          foregroundColor: Colors.black,
          bottom: const TabBar(
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.blue,
            tabs: [
              Tab(text: 'کارکردهـا (طلب)'),
              Tab(text: 'دریافتی‌هـا (بدهی)'),
            ],
          ),
        ),
        body: Column(
          children: [
            // --- کارت وضعیت حساب (بدهی ما) ---
            statsAsync.when(
              loading: () => const LinearProgressIndicator(),
              error: (e, s) => Text('خطا: $e'),
              data: (stats) => Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _DebtCard(debt: stats.remainingDebt),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(child: _InfoBox(title: 'کارکرد کل', value: stats.totalWorkValue, color: Colors.blueGrey, icon: Icons.handyman)),
                        const SizedBox(width: 10),
                        Expanded(child: _InfoBox(title: 'پرداختی کل', value: stats.totalPaid, color: Colors.green, icon: Icons.payments)),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // --- لیست‌ها (Tabs) ---
            Expanded(
              child: TabBarView(
                children: [
                  _WorkHistoryList(workerId: worker.id),
                  _PaymentHistoryList(workerId: worker.id),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  void _confirmDelete(BuildContext context, WidgetRef ref) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('حذف پرسنل', style: TextStyle(color: Colors.red)),
        content: Text(
          'آیا از حذف "${worker.name}" مطمئن هستید؟\n\n'
              'هشدار: تمام سوابق کاری و حساب‌های مالی این شخص کاملاً پاک خواهد شد.',
          style: const TextStyle(height: 1.5),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('انصراف', style: TextStyle(color: Colors.grey))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: () async {
              Navigator.pop(ctx);
              try {
                await ref.read(deleteWorkerUseCaseProvider).call(worker.id);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('پرسنل با موفقیت حذف شد')));
                  // دوبار پاپ می‌کنیم چون یک بار در دیالوگیم و باید برگردیم به لیست
                  // البته اینجا Navigator.pop(ctx) دیالوگ رو بسته. پس context.pop() کافیه برای برگشت به لیست
                  context.pop();
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('خطا: $e'), backgroundColor: Colors.red));
                }
              }
            },
            child: const Text('حذف کن'),
          ),
        ],
      ),
    );
  }

}

// --- ویجت‌های کمکی ---

class _DebtCard extends StatelessWidget {
  final double debt;
  const _DebtCard({required this.debt});

  @override
  Widget build(BuildContext context) {
    final formatter = intl.NumberFormat('#,###');
    final isEmployerIndebted = debt > 0; // اگر مثبت باشد یعنی ما بدهکاریم (طلب کارگر)

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isEmployerIndebted
              ? [Colors.red.shade400, Colors.red.shade600] // رنگ قرمز برای بدهی ما
              : [Colors.teal.shade400, Colors.teal.shade600], // رنگ سبز برای بی‌حسابی یا طلب ما
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: (isEmployerIndebted ? Colors.red : Colors.teal).withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            isEmployerIndebted ? 'مانده قابل پـرداخت' : 'اضافه پـرداخت (طلب شما)',
            style: const TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          FittedBox(
            child: Text(
              formatter.format(debt.abs()),
              style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: 1),
            ),
          ),
          const SizedBox(height: 4),
          const Text('تومان', style: TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }
}

class _InfoBox extends StatelessWidget {
  final String title;
  final double value;
  final Color color;
  final IconData icon;
  const _InfoBox({required this.title, required this.value, required this.color, required this.icon});

  @override
  Widget build(BuildContext context) {
    final formatter = intl.NumberFormat('#,###');
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        children: [
          Icon(icon, color: color.withOpacity(0.8), size: 20),
          const SizedBox(height: 8),
          Text(title, style: TextStyle(color: Colors.grey[600], fontSize: 11)),
          const SizedBox(height: 4),
          FittedBox(
            child: Text(
              formatter.format(value),
              style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}

// لیست تاریخچه کارکردها
class _WorkHistoryList extends ConsumerWidget {
  final String workerId;
  const _WorkHistoryList({required this.workerId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(appDatabaseProvider);
    return FutureBuilder(
      future: (db.select(db.workEntries)..where((t) => t.workerId.equals(workerId))..orderBy([(t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc)])).get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        final list = snapshot.data as List;
        if (list.isEmpty) return const Center(child: Text('بدون کارکرد'));

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: list.length,
          separatorBuilder: (ctx, index) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final entry = list[index];
            final jalaliDate = Jalali.fromDateTime(entry.date); // تبدیل به شمسی

            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade100),
              ),
              child: ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(8)),
                  child: const Icon(Icons.handyman, color: Colors.blue, size: 20),
                ),
                title: Text('${entry.amount} واحد کار', style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(entry.description ?? 'بدون توضیحات', style: const TextStyle(fontSize: 12)),
                trailing: Text(
                  '${jalaliDate.formatter.d} ${jalaliDate.formatter.mN} ${jalaliDate.formatter.yyyy}',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _PaymentHistoryList extends ConsumerWidget {
  final String workerId;
  const _PaymentHistoryList({required this.workerId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(paymentRepositoryProvider);
    return StreamBuilder(
      stream: repo.watchPaymentsByWorker(workerId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        final list = snapshot.data!;
        if (list.isEmpty) return const Center(child: Text('بدون پرداختی'));

        final formatter = intl.NumberFormat('#,###');

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: list.length,
          separatorBuilder: (ctx, index) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final payment = list[index];
            final jalaliDate = Jalali.fromDateTime(payment.date); // تبدیل به شمسی

            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade100),
              ),
              child: ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(8)),
                  child: const Icon(Icons.payment, color: Colors.green, size: 20),
                ),
                title: Text('${formatter.format(payment.amount)} تومان', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                subtitle: Text(payment.description ?? 'پرداخت نقدی', style: const TextStyle(fontSize: 12)),
                trailing: Text(
                  '${jalaliDate.formatter.d} ${jalaliDate.formatter.mN} ${jalaliDate.formatter.yyyy}',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ),
            );
          },
        );
      },
    );
  }
}