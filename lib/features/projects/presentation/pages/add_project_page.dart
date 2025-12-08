import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/project.dart';
import '../../../../core/di/dependency_injection.dart';

class AddProjectPage extends HookConsumerWidget {
  const AddProjectPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nameCtrl = useTextEditingController();
    final locationCtrl = useTextEditingController();
    final employerCtrl = useTextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('ثبت پروژه جدید')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: 'نام پروژه (مثلا: ویلای آقای ...)', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: locationCtrl,
              decoration: const InputDecoration(labelText: 'آدرس / موقعیت', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: employerCtrl,
              decoration: const InputDecoration(labelText: 'نام کارفرما', border: OutlineInputBorder()),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  if (nameCtrl.text.isEmpty) return;

                  final project = Project(
                    id: const Uuid().v4(),
                    name: nameCtrl.text,
                    location: locationCtrl.text,
                    employerName: employerCtrl.text,
                    isCompleted: false,
                    createdAt: DateTime.now(),
                    updatedAt: DateTime.now(),
                  );

                  await ref.read(addProjectUseCaseProvider).call(project);
                  if (context.mounted) context.pop();
                },
                icon: const Icon(Icons.check),
                label: const Text('ذخیره پروژه'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}