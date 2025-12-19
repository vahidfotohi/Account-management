import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:construction_manager/features/workers/domain/entities/worker.dart'; // برای دسترسی به WageType و اکستنشن label
import '../../../../core/di/dependency_injection.dart';
import '../providers/workers_list_provider.dart';

class WorkersPage extends HookConsumerWidget {
  const WorkersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workersAsync = ref.watch(workersListProvider);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.grey[50], // پس‌زمینه روشن و مدرن
      appBar: AppBar(
        title: const Text('لیست پـرسنل'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: theme.primaryColor,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/workers/add'), // مسیر اصلاح شده طبق روتر
        icon: const Icon(Icons.add),
        label: const Text('افزودن کارگر'),
        backgroundColor: theme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      body: workersAsync.when(
        data: (workers) {
          if (workers.isEmpty) {
            return _buildEmptyState(theme);
          }
          return ListView.separated(
            padding: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 80),
            itemCount: workers.length,
            separatorBuilder: (ctx, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final worker = workers[index];
              return _WorkerCard(worker: worker);
            },
          );
        },
        error: (err, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 48),
              const SizedBox(height: 8),
              Text('خطا در بارگیری اطلاعات:\n$err', textAlign: TextAlign.center),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  // --- ویجت حالت خالی ---
  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: theme.primaryColor.withOpacity(0.05),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.people_outline, size: 64, color: theme.primaryColor.withOpacity(0.5)),
          ),
          const SizedBox(height: 16),
          Text(
            'هنوز هیچ کارگری ثبت نشده است',
            style: TextStyle(fontSize: 16, color: Colors.grey[600], fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'برای شروع دکمه "افزودن کارگر" را بزنید',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

// --- ویجت کارت کارگر (مدرن) ---
class _WorkerCard extends ConsumerWidget {
  final Worker worker;

  const _WorkerCard({required this.worker});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final avatarColor = Colors.primaries[worker.name.length % Colors.primaries.length].shade100;
    final avatarTextColor = Colors.primaries[worker.name.length % Colors.primaries.length].shade900;

    // اگر غیرفعال باشد، کارت را کمی شفاف و خاکستری می‌کنیم
    final opacity = worker.isActive ? 1.0 : 0.6;

    return Opacity(
      opacity: opacity,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade100),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.08),
              offset: const Offset(0, 4),
              blurRadius: 12,
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => context.push('/workers/details', extra: worker),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  // 1. آواتار
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: worker.isActive ? avatarColor : Colors.grey.shade200,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      worker.name.isNotEmpty ? worker.name[0] : '?',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: worker.isActive ? avatarTextColor : Colors.grey,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // 2. مشخصات
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          worker.name,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          worker.jobTitle ?? 'بدون عنوان',
                          style: TextStyle(color: Colors.grey[600], fontSize: 12),
                        ),
                      ],
                    ),
                  ),

                  // 3. سوییچ فعال/غیرفعال (قابلیت جدید)
                  Column(
                    children: [
                      Switch(
                        value: worker.isActive,
                        activeColor: Colors.green,
                        onChanged: (val) async {
                          // فراخوانی UseCase برای آپدیت وضعیت
                          final updatedWorker = worker.copyWith(isActive: val);
                          await ref.read(updateWorkerUseCaseProvider).call(updatedWorker);
                        },
                      ),
                      Text(
                        worker.isActive ? 'فعال' : 'غیرفعال',
                        style: TextStyle(
                            fontSize: 10,
                            color: worker.isActive ? Colors.green : Colors.grey,
                            fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}