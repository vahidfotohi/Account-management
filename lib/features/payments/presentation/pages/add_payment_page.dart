// ignore_for_file: empty_catches

import 'package:construction_manager/core/utils/number_formatter.dart';
import 'package:construction_manager/core/widgets/persian_date_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/widgets/copyable_row.dart';
import '../../../../core/widgets/section_card.dart';
import '../../domain/entities/payment.dart';
import '../../../workers/domain/entities/worker.dart';
import '../../../workers/presentation/providers/workers_list_provider.dart';
import '../../../../core/di/dependency_injection.dart';

class AddPaymentPage extends HookConsumerWidget {
  final Payment? paymentToEdit;

  const AddPaymentPage({this.paymentToEdit, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEditing = paymentToEdit != null;

    final workersAsync = ref.watch(workersListProvider);
    final selectedWorker = useState<Worker?>(null);
    final selectedDate = useState<Jalali>(
      isEditing ? Jalali.fromDateTime(paymentToEdit!.date) : Jalali.now(),
    );
    final amountController = useTextEditingController(
      text: isEditing ? paymentToEdit!.amount.toInt().toString() : '',
    );
    final descController =
        useTextEditingController(text: paymentToEdit?.description);
    useEffect(
      () {
        if (isEditing) {
          workersAsync.whenData((workers) {
            selectedWorker.value =
                workers.firstWhere((w) => w.id == paymentToEdit!.workerId);
          });
        }
        return null;
      },
      [],
    );

    Future<void> pickDate() async {
      final Jalali? picked =
          await showMyPersianDatePicker(context, selectedDate.value);
      if (picked != null) selectedDate.value = picked;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('ثبت پـرداختی')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // --- بخش ۱: انتخاب گیرنده ---
            SectionCard(
              title: 'گیرنده وجه',
              icon: Icons.person_outline,
              child: Column(
                children: [
                  workersAsync.when(
                    loading: () => const LinearProgressIndicator(),
                    error: (_, __) => const Text('خطا'),
                    data: (workers) {
                      if (isEditing && selectedWorker.value == null) {
                        try {
                          final w = workers.firstWhere((element) => element.id == paymentToEdit!.workerId);
                          // استفاده از Future.microtask برای جلوگیری از ارور setState در build
                          Future.microtask(() => selectedWorker.value = w);
                        } catch (e) {}
                      }
                      return DropdownButtonFormField<Worker>(
                      value: selectedWorker.value,
                      decoration: const InputDecoration(
                        labelText: 'انتخاب کارگر',
                        prefixIcon: Icon(Icons.search),
                      ),
                      items: workers
                          .where(
                            (worker) => worker.isActive,
                          )
                          .map(
                            (w) =>
                                DropdownMenuItem(value: w, child: Text(w.name)),
                          )
                          .toList(),
                      onChanged: (val) => selectedWorker.value = val,
                    );
                    },
                  ),
                  if (selectedWorker.value != null) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.blue.shade100),
                      ),
                      child: Column(
                        children: [
                          if (selectedWorker.value!.cardNumber?.isNotEmpty ==
                              true)
                            CopyableRow(
                              title: 'کارت:',
                              value: selectedWorker.value!.cardNumber!,
                            ),
                          if (selectedWorker.value!.shebaNumber?.isNotEmpty ==
                              true)
                            CopyableRow(
                              title: 'شبا:',
                              value: 'IR${selectedWorker.value!.shebaNumber!}',
                            ),
                          if ((selectedWorker.value!.cardNumber?.isEmpty ??
                                  true) &&
                              (selectedWorker.value!.shebaNumber?.isEmpty ??
                                  true))
                            const Text(
                              'اطلاعات بانکی ثبت نشده است',
                              style: TextStyle(color: Colors.grey),
                            ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),

            // --- بخش ۲: جزئیات پرداخت ---
            SectionCard(
              title: 'جزئیات مالی',
              icon: Icons.attach_money,
              child: Column(
                children: [
                  InkWell(
                    onTap: pickDate,
                    borderRadius: BorderRadius.circular(12),
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'تاریخ پرداخت',
                        prefixIcon: Icon(Icons.calendar_month_outlined),
                      ),
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
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      CurrencyInputFormatter(),
                    ],
                    decoration: const InputDecoration(
                      labelText: 'مبلغ (تومان)',
                      prefixIcon: Icon(Icons.payments_outlined),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: descController,
                    decoration: const InputDecoration(
                      labelText: 'توضیحات (اختیاری)',
                      prefixIcon: Icon(Icons.description_outlined),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // --- دکمه ثبت ---
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.check_circle_outline),
                label: Text(isEditing ? 'ویرایش پرداخت' : 'ثبت نهایی پرداخت'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                ),
                onPressed: () async {
                  if (selectedWorker.value == null ||
                      amountController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('لطفا کارگر و مبلغ را مشخص کنید'),
                      ),
                    );
                    return;
                  }
                  final payment = Payment(
                    id:isEditing ? paymentToEdit!.id : const Uuid().v4(),
                    workerId: selectedWorker.value!.id,
                    amount: parseCurrency(amountController.text),
                    date: selectedDate.value.toDateTime(),
                    description: descController.text,
                  );
                  if (isEditing) {
                    await ref.read(paymentRepositoryProvider).updatePayment(payment);
                  } else {
                    await ref.read(addPaymentUseCaseProvider).call(payment);
                  }
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('پرداختی ثبت شد')),
                    );
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
