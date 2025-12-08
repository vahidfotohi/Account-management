import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/workers_list_provider.dart';

class WorkersPage extends HookConsumerWidget {
  const WorkersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workersAsync = ref.watch(workersListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('مدیریت کارگران')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/add-worker'),
        child: const Icon(Icons.add),
      ),
      body: workersAsync.when(
        data: (workers) {
          if (workers.isEmpty) {
            return const Center(child: Text('هیچ کارگری ثبت نشده است'));
          }
          return ListView.builder(
            itemCount: workers.length,
            itemBuilder: (context, index) {
              final worker = workers[index];
              return ListTile(
                title: Text(worker.name),
                subtitle: Text(worker.jobTitle ?? '-'),
                trailing: Text(worker.wageType.name),
                leading: CircleAvatar(child: Text(worker.name[0])),
              );
            },
          );
        },
        error: (err, stack) => Center(child: Text('خطا: $err')),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}