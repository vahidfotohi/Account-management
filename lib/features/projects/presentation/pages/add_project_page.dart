import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/widgets/section_card.dart';
import '../../domain/entities/project.dart';
import '../../../../core/di/dependency_injection.dart';

class AddProjectPage extends HookConsumerWidget {
  const AddProjectPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nameCtrl = useTextEditingController();
    final locationCtrl = useTextEditingController();
    final employerCtrl = useTextEditingController();

    // (مثل بقیه صفحات از _SectionCard استفاده کنید)
// ...
    return Scaffold(
      appBar: AppBar(title: const Text('ایجاد پروژه جدید')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            SectionCard(
              title: 'مشخصات پروژه',
              icon: Icons.info_outline,
              child: Column(
                children: [
                  TextField(
                    controller: nameCtrl,
                    decoration: const InputDecoration(labelText: 'نام پروژه', prefixIcon: Icon(Icons.title)),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: employerCtrl,
                    decoration: const InputDecoration(labelText: 'کارفرما', prefixIcon: Icon(Icons.person)),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: locationCtrl,
                    decoration: const InputDecoration(labelText: 'آدرس / موقعیت', prefixIcon: Icon(Icons.location_on)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text('ذخیره پروژه'),
                onPressed: () async {
                  if (nameCtrl.text.isEmpty) return;

                  final project = Project(
                    id: const Uuid().v4(),
                    name: nameCtrl.text,
                    location: locationCtrl.text,
                    employerName: employerCtrl.text,
                    isActive: true,
                    isCompleted: false,
                    createdAt: DateTime.now(),
                    updatedAt: DateTime.now(),
                  );

                  await ref.read(addProjectUseCaseProvider).call(project);
                  if (context.mounted) context.pop();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

