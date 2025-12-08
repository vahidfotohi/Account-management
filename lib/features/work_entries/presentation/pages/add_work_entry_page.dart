import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart' as intl;

// Import Entities
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
    final selectedWorker = useState<Worker?>(null);
    final selectedProject = useState<Project?>(null);
    final selectedDate = useState<DateTime>(DateTime.now());

    final amountController = useTextEditingController();
    final descController = useTextEditingController();

    // تابع کمکی برای نمایش تقویم
    Future<void> pickDate() async {
      final picked = await showDatePicker(
        context: context,
        initialDate: selectedDate.value,
        firstDate: DateTime(2020),
        lastDate: DateTime(2030),
      );
      if (picked != null) {
        selectedDate.value = picked;
      }
    }

    // محاسبه لیبل ورودی بر اساس نوع دستمزد کارگر
    String getAmountLabel() {
      if (selectedWorker.value == null) return 'مقدار کارکرد';
      switch (selectedWorker.value!.wageType) {
        case WageType.daily: return 'تعداد روز';
        case WageType.hourly: return 'تعداد ساعت';
        case WageType.metri: return 'متراژ (متر)';
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('ثبت کارکرد جدید')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // --- انتخاب پروژه ---
              projectsAsync.when(
                loading: () => const LinearProgressIndicator(),
                error: (_, __) => const Text('خطا در بارگیری پروژه‌ها'),
                data: (projects) {
                  return DropdownButtonFormField<Project>(
                    initialValue: selectedProject.value,
                    decoration: const InputDecoration(labelText: 'انتخاب پروژه', border: OutlineInputBorder()),
                    items: projects.map((p) => DropdownMenuItem(value: p, child: Text(p.name))).toList(),
                    onChanged: (val) => selectedProject.value = val,
                  );
                },
              ),
              const SizedBox(height: 16),

              // --- انتخاب کارگر ---
              workersAsync.when(
                loading: () => const LinearProgressIndicator(),
                error: (_, __) => const Text('خطا در بارگیری کارگران'),
                data: (workers) {
                  return DropdownButtonFormField<Worker>(
                    initialValue: selectedWorker.value,
                    decoration: const InputDecoration(labelText: 'انتخاب کارگر', border: OutlineInputBorder()),
                    items: workers.map((w) => DropdownMenuItem(value: w, child: Text(w.name))).toList(),
                    onChanged: (val) {
                      selectedWorker.value = val;
                      // پاک کردن مقدار قبلی چون واحد اندازه‌گیری عوض شده
                      amountController.clear();
                    },
                  );
                },
              ),
              const SizedBox(height: 16),

              // --- انتخاب تاریخ ---
              InkWell(
                onTap: pickDate,
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'تاریخ کارکرد',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  child: Text(
                    intl.DateFormat('yyyy/MM/dd').format(selectedDate.value),
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // --- مقدار کارکرد ---
              TextField(
                controller: amountController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: getAmountLabel(),
                  border: const OutlineInputBorder(),
                  helperText: selectedWorker.value != null
                      ? 'دستمزد پایه: ${selectedWorker.value!.baseWage}'
                      : null,
                ),
              ),
              const SizedBox(height: 16),

              // --- توضیحات ---
              TextField(
                controller: descController,
                maxLines: 2,
                decoration: const InputDecoration(labelText: 'توضیحات (اختیاری)', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 24),

              // --- دکمه ذخیره ---
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    // اعتبارسنجی ساده
                    if (selectedProject.value == null || selectedWorker.value == null || amountController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('لطفاً همه فیلدها را پر کنید')));
                      return;
                    }

                    try {
                      final entry = WorkEntry(
                        id: const Uuid().v4(),
                        workerId: selectedWorker.value!.id,
                        projectId: selectedProject.value!.id,
                        date: selectedDate.value,
                        amount: double.parse(amountController.text),
                        description: descController.text,
                        createdAt: DateTime.now(),
                      );

                      await ref.read(addWorkEntryUseCaseProvider).call(entry);

                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('کارکرد با موفقیت ثبت شد')));
                        context.pop();
                      }
                    } catch (e) {
                      if(context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('خطا: $e')));
                      }
                    }
                  },
                  child: const Text('ثبت و ذخیره'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}