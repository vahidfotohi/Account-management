import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/worker.dart';
import '../../../../core/di/dependency_injection.dart';

class AddWorkerPage extends HookConsumerWidget {
  const AddWorkerPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nameController = useTextEditingController();
    final jobController = useTextEditingController();
    final baseWageController = useTextEditingController();
    final phoneController = useTextEditingController();

    final wageTypeState = useState(WageType.daily);

    return Scaffold(
      appBar: AppBar(title: const Text('افزودن کارگر جدید')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'نام و نام خانوادگی'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: jobController,
              decoration: const InputDecoration(labelText: 'عنوان شغلی (مثلا: بنا)'),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<WageType>(
              initialValue: wageTypeState.value,
              items: WageType.values.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type.name),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) wageTypeState.value = val;
              },
              decoration: const InputDecoration(labelText: 'نوه پرداخت'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: baseWageController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'مبلغ دستمزد پایه'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: 'شماره تماس'),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  if (nameController.text.isEmpty) return;

                  final newWorker = Worker(
                    id: const Uuid().v4(),
                    name: nameController.text,
                    jobTitle: jobController.text,
                    wageType: wageTypeState.value,
                    baseWage: double.tryParse(baseWageController.text) ?? 0,
                    isActive: true,
                    phoneNumber: phoneController.text,
                    notes: '',
                    createdAt: DateTime.now(),
                    updatedAt: DateTime.now(),
                  );

                  await ref.read(addWorkerUseCaseProvider).call(newWorker);

                  if (context.mounted) {
                    context.pop();
                  }
                },
                child: const Text('ثبت کارگر'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}