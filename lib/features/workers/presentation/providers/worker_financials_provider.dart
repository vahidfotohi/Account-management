import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:construction_manager/core/di/dependency_injection.dart';

part 'worker_financials_provider.g.dart';

class WorkerStats {
  final double totalWorkValue; // ارزش ریالی کل کارهای انجام شده
  final double totalPaid;      // کل پولی که بهش دادیم
  final double remainingDebt;  // چقدر بدهکاریم

  WorkerStats({
    required this.totalWorkValue,
    required this.totalPaid,
    required this.remainingDebt,
  });
}

@riverpod
Future<WorkerStats> workerFinancials(Ref ref, String workerId) async {
  // 1. دریافت اطلاعات خود کارگر (برای فهمیدن دستمزد پایه)
  final workerRepo = ref.watch(workerRepositoryProvider);
  final worker = await workerRepo.getWorkerById(workerId);

  if (worker == null) {
    return WorkerStats(totalWorkValue: 0, totalPaid: 0, remainingDebt: 0);
  }

  // 2. محاسبه ارزش کارکردها (Work Entries)
  // نکته: اینجا همه پروژه‌ها را چک می‌کنیم تا بفهمیم این کارگر کلاً چقدر کار کرده
  // چون متد watchEntriesByWorker نداریم، فعلاً همه رو میگیریم و فیلتر میکنیم (برای دیتابیس لوکال سریع است)
  // * روش بهتر: اضافه کردن متد watchEntriesByWorker به Repository است، اما فعلا این کار را می‌کنیم:

  final db = ref.watch(appDatabaseProvider);
  final allEntries = await (db.select(db.workEntries)..where((t) => t.workerId.equals(workerId))).get();

  double totalWorkValue = 0;
  for (var entry in allEntries) {
    // فرمول: مقدار کار * دستمزد پایه کارگر
    totalWorkValue += (entry.amount * worker.baseWage);
  }

  // 3. محاسبه پرداختی‌ها (Payments)
  final paymentRepo = ref.watch(paymentRepositoryProvider);
  final payments = await paymentRepo.watchPaymentsByWorker(workerId).first;

  final double totalPaid = payments.fold(0, (sum, item) => sum + item.amount);
  final double totalWorkWithInitial = totalWorkValue + (worker.initialDebt ?? 0);
  return WorkerStats(
    totalWorkValue: totalWorkValue,
    totalPaid: totalPaid,
    remainingDebt: totalWorkWithInitial - totalPaid, // اگر مثبت باشد یعنی ما بدهکاریم
  );
}