import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/utils/number_formatter.dart';
// ویجت تقویم سفارشی که ساختیم
import '../../../../core/widgets/persian_date_picker.dart';
// ویجت کارت که ساختیم (اگر در فایل جداست ایمپورت کنید، اگر نه کدش را پایین همین فایل بگذارید)
import '../../../../core/widgets/section_card.dart';

import '../../domain/entities/receipt.dart';
import '../../../projects/domain/entities/project.dart';
import '../../../projects/presentation/providers/projects_list_provider.dart';
import '../../../../core/di/dependency_injection.dart';

class AddReceiptPage extends HookConsumerWidget {
  final Receipt? receiptToEdit;

  const AddReceiptPage({super.key, this.receiptToEdit});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectsAsync = ref.watch(projectsListProvider);
    final isEditing = receiptToEdit != null;

    // استیت‌ها
    final selectedProject = useState<Project?>(null);
    final selectedDate = useState<Jalali>(
        isEditing ? Jalali.fromDateTime(receiptToEdit!.date) : Jalali.now(),
    );
    final amountController = useTextEditingController(
        text: isEditing ? receiptToEdit!.amount.toInt().toString() : '',
    );
    final descController = useTextEditingController(text: receiptToEdit?.description);

    // انتخاب تاریخ با تقویم شمسی صحیح
    Future<void> pickDate() async {
      final Jalali? picked = await showMyPersianDatePicker(context, selectedDate.value);
      if (picked != null) selectedDate.value = picked;
    }

    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'ویرایش دریافتی' : 'ثبت دریافتی (درآمد)')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            SectionCard(
              title: 'منبع درآمد',
              icon: Icons.apartment,
              child: projectsAsync.when(
                loading: () => const LinearProgressIndicator(),
                error: (_, __) => const Text('خطا'),
                data: (projects) {
                  // اگر در حال ویرایش هستیم، پروژه مربوطه را ست کن
                  if (isEditing && selectedProject.value == null) {
                    try {
                      final p = projects.firstWhere((element) => element.id == receiptToEdit!.projectId);
                      Future.microtask(() => selectedProject.value = p);
                    } catch (_) {}
                  }

                  return DropdownButtonFormField<Project>(
                    value: selectedProject.value,
                    decoration: const InputDecoration(labelText: 'انتخاب پروژه', prefixIcon: Icon(Icons.business)),
                    // فقط پروژه‌های فعال یا پروژه‌ای که قبلا انتخاب شده (برای ویرایش)
                    items: projects
                        .where((p) => p.isActive || (isEditing && p.id == receiptToEdit!.projectId))
                        .map((p) => DropdownMenuItem(value: p, child: Text(p.name)))
                        .toList(),
                    onChanged: (val) => selectedProject.value = val,
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            SectionCard(
              title: 'اطلاعات مالی',
              icon: Icons.attach_money,
              child: Column(
                children: [
                  InkWell(
                    onTap: pickDate,
                    child: InputDecorator(
                      decoration: const InputDecoration(labelText: 'تاریخ دریافت', prefixIcon: Icon(Icons.calendar_month)),
                      child: Text(
                        '${selectedDate.value.formatter.wN} ${selectedDate.value.formatter.d} ${selectedDate.value.formatter.mN} ${selectedDate.value.formatter.yyyy}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly, CurrencyInputFormatter()],
                    decoration: const InputDecoration(labelText: 'مبلغ دریافتی', suffixText: 'تومان', prefixIcon: Icon(Icons.add_card, color: Colors.green)),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: descController,
                    decoration: const InputDecoration(labelText: 'بابت / توضیحات', prefixIcon: Icon(Icons.notes)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: Icon(isEditing ? Icons.save_as : Icons.check),
                label: Text(isEditing ? 'ذخیره تغییرات' : 'ثبت دریافتی'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                onPressed: () async {
                  if (selectedProject.value == null || amountController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('لطفا پروژه و مبلغ را مشخص کنید')));
                    return;
                  }

                  final receipt = Receipt(
                    id: isEditing ? receiptToEdit!.id : const Uuid().v4(), // ID ثابت برای ویرایش
                    projectId: selectedProject.value!.id,
                    amount: parseCurrency(amountController.text),
                    date: selectedDate.value.toDateTime(),
                    description: descController.text,
                  );

                  if (isEditing) {
                    // آپدیت
                    await ref.read(receiptRepositoryProvider).updateReceipt(receipt);
                  } else {
                    // افزودن جدید
                    await ref.read(addReceiptUseCaseProvider).call(receipt);
                  }

                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(isEditing ? 'ویرایش شد' : 'ثبت شد')));
                    context.pop();
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