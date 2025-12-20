import 'package:construction_manager/core/utils/number_formatter.dart';
import 'package:construction_manager/core/widgets/persian_date_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'package:uuid/uuid.dart';

// Import Entities
import '../../../../core/widgets/section_card.dart';
import '../../domain/entities/work_entry.dart';
import '../../../workers/domain/entities/worker.dart';
import '../../../projects/domain/entities/project.dart';

// Import Providers
import '../../../../core/di/dependency_injection.dart';
import '../../../workers/presentation/providers/workers_list_provider.dart';
import '../../../projects/presentation/providers/projects_list_provider.dart';

class AddWorkEntryPage extends HookConsumerWidget {
  const AddWorkEntryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. دریافت داده‌های اولیه (لیست کارگران و پروژه‌ها)
    final workersAsync = ref.watch(workersListProvider);
    final projectsAsync = ref.watch(projectsListProvider);

    // 2. مدیریت استیت‌های فرم
    final selectedWorkers = useState<List<Worker>>([]);
    final selectedProject = useState<Project?>(null);
    final selectedDate = useState<Jalali>(Jalali.now());

    final amountController = useTextEditingController();
    final descController = useTextEditingController();

    // تابع کمکی برای نمایش تقویم
    Future<void> pickDate() async {
      final Jalali? picked =
          await showMyPersianDatePicker(context, selectedDate.value);
      if (picked != null) {
        selectedDate.value = picked;
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('ثبت کارکرد گروهی')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            SectionCard(
              title: 'پروژه',
              icon: Icons.business,
              child: projectsAsync.when(
                loading: () => const LinearProgressIndicator(),
                error: (_, __) => const Text('خطا'),
                data: (projects) => DropdownButtonFormField<Project>(
                  value: selectedProject.value,
                  decoration: const InputDecoration(
                      labelText: 'پروژه مربوطه',
                      prefixIcon: Icon(Icons.apartment),),
                  items: projects
                      .where((p) => p.isActive,).map((p) =>
                          DropdownMenuItem(value: p, child: Text(p.name)),)
                      .toList(),
                  onChanged: (val) => selectedProject.value = val,
                ),
              ),
            ),
            const SizedBox(height: 16),
            SectionCard(
              title: 'پرسنل فعال',
              icon: Icons.group_add,
              child: workersAsync.when(
                loading: () => const LinearProgressIndicator(),
                error: (_, __) => const Text('خطا'),
                data: (workers) {
                  return Column(
                    children: [
                      DropdownButtonFormField<Worker>(
                        decoration: const InputDecoration(
                            labelText: 'افزودن نفرات',
                            prefixIcon: Icon(Icons.person_add_alt_1),),
                        items: workers.where((worker) => worker.isActive ,).map((w) {
                          final isSelected = selectedWorkers.value.contains(w);
                          return DropdownMenuItem(
                              value: w,
                              enabled: !isSelected,
                              child: Text(w.name,
                                  style: TextStyle(
                                      color: isSelected
                                          ? Colors.grey
                                          : Colors.black,),),);
                        }).toList(),
                        onChanged: (val) {
                          if (val != null &&
                              !selectedWorkers.value.contains(val)) {
                            selectedWorkers.value = [
                              ...selectedWorkers.value,
                              val,
                            ];
                          }
                        },
                        value: null,
                      ),
                      if (selectedWorkers.value.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: selectedWorkers.value
                              .map((w) => Chip(
                                    label: Text(w.name),
                                    backgroundColor: Colors.blue.shade50,
                                    deleteIcon: const Icon(Icons.cancel,
                                        size: 18, color: Colors.red,),
                                    onDeleted: () {
                                      final list = List<Worker>.from(
                                          selectedWorkers.value,);
                                      list.remove(w);
                                      selectedWorkers.value = list;
                                    },
                                  ),)
                              .toList(),
                        ),
                      ],
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            SectionCard(
              title: 'جزئیات کارکرد',
              icon: Icons.timelapse,
              child: Column(
                children: [
                  InkWell(
                    onTap: pickDate,
                    child: InputDecorator(
                      decoration: const InputDecoration(
                          labelText: 'تاریخ',
                          prefixIcon: Icon(Icons.calendar_month),),
                      child: Text(
                          '${selectedDate.value.formatter.wN} ${selectedDate.value.formatter.d} ${selectedDate.value.formatter.mN}',),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        labelText: 'مقدار (روز / ساعت / متر)',
                        prefixIcon: Icon(Icons.numbers),),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: descController,
                    decoration: const InputDecoration(
                        labelText: 'توضیحات کار',
                        prefixIcon: Icon(Icons.description),),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.done_all),
                label: const Text('ثبت برای همه نفرات'),
                onPressed: () async {
                  // اعتبارسنجی: لیست کارگران نباید خالی باشد (isEmpty)
                  if (selectedProject.value == null ||
                      selectedWorkers.value.isEmpty ||
                      amountController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'لطفاً پروژه، کارگران و مقدار کارکرد را مشخص کنید',
                        ),
                      ),
                    );
                    return;
                  }

                  try {
                    final gregorianDate = selectedDate.value.toDateTime();

                    // ثبت برای تمام کارگران انتخاب شده
                    for (final selectedWorker in selectedWorkers.value) {
                      final entry = WorkEntry(
                        id: const Uuid().v4(),
                        workerId: selectedWorker.id,
                        projectId: selectedProject.value!.id,
                        date: gregorianDate,
                        amount: parseCurrency(amountController.text),
                        description: descController.text,
                        wageAtTime: selectedWorker.baseWage,
                        createdAt: DateTime.now(),
                      );
                      await ref.read(addWorkEntryUseCaseProvider).call(entry);
                    }

                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            '${selectedWorkers.value.length} کارکرد با موفقیت ثبت شد',
                          ),
                        ),
                      );
                      context.pop();
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text('خطا: $e')));
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
