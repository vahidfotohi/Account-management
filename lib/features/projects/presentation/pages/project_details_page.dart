import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart' as intl;

// Entities
import 'package:construction_manager/features/projects/domain/entities/project.dart';
import 'package:construction_manager/features/workers/domain/entities/worker.dart';

// Providers
import 'package:construction_manager/features/work_entries/presentation/providers/project_entries_provider.dart';
import 'package:construction_manager/features/workers/presentation/providers/workers_list_provider.dart';
import '../../../../core/di/dependency_injection.dart';
import '../providers/project_financials_provider.dart';

class ProjectDetailsPage extends HookConsumerWidget {
  final Project project;

  const ProjectDetailsPage({super.key, required this.project});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entriesAsync = ref.watch(projectEntriesProvider(project.id));
    final workersAsync = ref.watch(workersListProvider);
    final statsAsync = ref.watch(projectFinancialsProvider(project.id));

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(project.name),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            tooltip: 'حذف پروژه',
            onPressed: () => _confirmDelete(context, ref),
          ),
        ],
      ),
      body: Column(
        children: [
          // --- بخش ۱: داشبورد مالی ---
          statsAsync.when(
            loading: () => const Padding(
              padding: EdgeInsets.all(20),
              child: LinearProgressIndicator(),
            ),
            error: (err, stack) => const SizedBox(),
            data: (stats) => Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _BalanceCard(profit: stats.profit),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _DetailCard(
                          label: 'کل هزینه',
                          amount: stats.totalExpenses,
                          icon: Icons.trending_down,
                          color: Colors.redAccent,
                          bgColor: Colors.red.shade50,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _DetailCard(
                          label: 'کل دریافتی',
                          amount: stats.totalIncome,
                          icon: Icons.trending_up,
                          color: Colors.green,
                          bgColor: Colors.green.shade50,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // --- تیتر لیست ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              children: [
                const Icon(Icons.list_alt, size: 18, color: Colors.grey),
                const SizedBox(width: 8),
                const Text(
                  'خلاصه کارکرد پرسنل',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
                const Spacer(),
                Text(
                  '(تجمیعی)',
                  style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                ),
              ],
            ),
          ),

          // --- بخش ۲: لیست کارکردها ---
          Expanded(
            child: entriesAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('خطا: $err')),
              data: (entries) {
                if (entries.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.assignment_outlined, size: 48, color: Colors.grey[300]),
                        const SizedBox(height: 8),
                        Text('هنوز کارکردی ثبت نشده', style: TextStyle(color: Colors.grey[500])),
                      ],
                    ),
                  );
                }

                return workersAsync.when(
                  loading: () => const SizedBox(),
                  error: (_, __) => const SizedBox(),
                  data: (workers) {
                    final workersMap = {for (var w in workers) w.id: w};

                    // منطق تجمیع
                    final Map<String, double> aggregatedWork = {};
                    for (var entry in entries) {
                      aggregatedWork.update(entry.workerId, (val) => val + entry.amount, ifAbsent: () => entry.amount);
                    }

                    return ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      itemCount: aggregatedWork.length,
                      separatorBuilder: (ctx, index) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final workerId = aggregatedWork.keys.elementAt(index);
                        final totalAmount = aggregatedWork[workerId]!;
                        final worker = workersMap[workerId];
                        final workerName = worker?.name ?? 'نامشخص';

                        // رنگ آواتار رندوم
                        final avatarColor = Colors.primaries[workerName.length % Colors.primaries.length].shade100;
                        final avatarTextColor = Colors.primaries[workerName.length % Colors.primaries.length].shade900;

                        // واحد
                        String unit = '';
                        if (worker != null) {
                          switch(worker.wageType) {
                            case WageType.daily: unit = 'روز'; break;
                            case WageType.hourly: unit = 'ساعت'; break;
                            case WageType.metri: unit = 'متر'; break;
                          }
                        }

                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade100),
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: avatarColor,
                              child: Text(
                                workerName.isNotEmpty ? workerName[0] : '?',
                                style: TextStyle(color: avatarTextColor, fontWeight: FontWeight.bold),
                              ),
                            ),
                            title: Text(workerName, style: const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: const Text('مجموع کارکرد در این پروژه'),
                            trailing: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade50,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '$totalAmount $unit',
                                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue.shade800),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('حذف پروژه', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
        content: Text(
          'آیا مطمئن هستید که می‌خواهید پروژه "${project.name}" را حذف کنید؟\n\nتمام سوابق مالی و کاری این پروژه پاک خواهند شد.',
          style: const TextStyle(height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('انصراف', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton.icon(
            icon: const Icon(Icons.delete_forever, size: 18),
            label: const Text('حذف کن'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              elevation: 0,
            ),
            onPressed: () async {
              Navigator.pop(ctx);
              try {
                await ref.read(deleteProjectUseCaseProvider).call(project.id);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('پروژه حذف شد')));
                  context.pop();
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('خطا: $e'), backgroundColor: Colors.red));
                }
              }
            },
          ),
        ],
      ),
    );
  }
}

// ویجت‌های مالی (بدون تغییر منطق، فقط کمی پولیش ظاهری)
class _BalanceCard extends StatelessWidget {
  final double profit;
  const _BalanceCard({required this.profit});

  @override
  Widget build(BuildContext context) {
    final isPositive = profit >= 0;
    final formatter = intl.NumberFormat('#,###');

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isPositive
              ? [Colors.blue.shade700, Colors.blue.shade500]
              : [Colors.orange.shade800, Colors.orange.shade600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: isPositive ? Colors.blue.withOpacity(0.3) : Colors.orange.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            isPositive ? 'سـود (مانده پـروژه)' : 'زیـان (بدهی پـروژه)',
            style: const TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              "${formatter.format(profit.abs())} ${profit < 0 ? '-' : ''}",
              style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold, letterSpacing: 1),
            ),
          ),
          const SizedBox(height: 4),
          const Text('تومان', style: TextStyle(color: Colors.white70, fontSize: 12)),
        ],
      ),
    );
  }
}

class _DetailCard extends StatelessWidget {
  final String label;
  final double amount;
  final IconData icon;
  final Color color;
  final Color bgColor;

  const _DetailCard({required this.label, required this.amount, required this.icon, required this.color, required this.bgColor});

  @override
  Widget build(BuildContext context) {
    final formatter = intl.NumberFormat('#,###');
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 8),
            Text(label, style: TextStyle(color: color.withOpacity(0.8), fontSize: 12, fontWeight: FontWeight.bold)),
          ],),
          const SizedBox(height: 12),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              formatter.format(amount),
              style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.w900),
            ),
          ),
        ],
      ),
    );
  }
}