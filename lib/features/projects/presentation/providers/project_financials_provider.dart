import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:construction_manager/core/di/dependency_injection.dart';
import 'package:rxdart/rxdart.dart';

part 'project_financials_provider.g.dart';

class ProjectStats {
  final double totalIncome;
  final double totalExpenses;
  final double profit;

  ProjectStats({
    required this.totalIncome,
    required this.totalExpenses,
    required this.profit,
  });
}

@riverpod
Stream<ProjectStats> projectFinancials(Ref ref, String projectId) {
  final receiptRepo = ref.watch(receiptRepositoryProvider);
  final workRepo = ref.watch(workEntryRepositoryProvider);

  return Rx.combineLatest2(
    receiptRepo.watchReceiptsByProject(projectId),
    workRepo.watchEntriesByProject(projectId),
        (receipts, workEntries) {

      final double totalIncome = receipts.fold(0, (sum, item) => sum + item.amount);

      double totalExpenses = 0;
      for (var entry in workEntries) {
        totalExpenses += (entry.amount * entry.wageAtTime);
      }

      return ProjectStats(
        totalIncome: totalIncome,
        totalExpenses: totalExpenses,
        profit: totalIncome - totalExpenses,
      );
    },
  );
}