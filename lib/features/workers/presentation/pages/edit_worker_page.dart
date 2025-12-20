import 'dart:developer' as developer;

import 'package:construction_manager/core/utils/number_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/section_card.dart';
import '../../domain/entities/worker.dart';
import '../../../../core/di/dependency_injection.dart';
import '../providers/worker_financials_provider.dart';

class EditWorkerPage extends HookConsumerWidget {
  final Worker worker; // کارگری که قرار است ویرایش شود

  const EditWorkerPage({super.key, required this.worker});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // مقداردهی اولیه کنترلرها با اطلاعات کارگر
    final nameController = useTextEditingController(text: worker.name);
    final jobController = useTextEditingController(text: worker.jobTitle);
    final phoneController = useTextEditingController(text: worker.phoneNumber);

    // برای اعداد، باید فرمت ۳ رقم را رعایت کنیم یا ساده نمایش دهیم
    // اینجا ساده نمایش می‌دهیم، خود کاربر پاک میکند و دوباره میزند
    final baseWageController =
        useTextEditingController(text: worker.baseWage.toInt().toString());
    final initialDebtController = useTextEditingController(
      text: worker.initialDebt?.toInt().toString() ?? '0',
    );

    final wageTypeState = useState(worker.wageType);
    final cardController = useTextEditingController(text: worker.cardNumber);
    final shebaController = useTextEditingController(text: worker.shebaNumber);

    return Scaffold(
      appBar: AppBar(title: const Text('ویرایش مشخصات پرسنل')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // --- فرم مشابه افزودن ---
            SectionCard(
              title: 'اطلاعات هویتی',
              icon: Icons.person_outline,
              child: Column(
                children: [
                  TextField(
                    controller: nameController,
                    decoration:
                        const InputDecoration(labelText: 'نام و نام خانوادگی'),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: jobController,
                    decoration: const InputDecoration(labelText: 'عنوان شغلی'),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(labelText: 'شماره تماس'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            SectionCard(
              title: 'اطلاعات مالی',
              icon: Icons.monetization_on_outlined,
              child: Column(
                children: [
                  DropdownButtonFormField<WageType>(
                    value: wageTypeState.value,
                    decoration: const InputDecoration(labelText: 'نوع پرداخت'),
                    items: WageType.values
                        .map(
                          (type) => DropdownMenuItem(
                            value: type,
                            child: Text(type.label),
                          ),
                        )
                        .toList(),
                    onChanged: (val) {
                      if (val != null) wageTypeState.value = val;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: baseWageController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      CurrencyInputFormatter(),
                    ],
                    decoration: const InputDecoration(
                      labelText: 'دستمزد پایه',
                      suffixText: 'تومان',
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: initialDebtController,
                    keyboardType:
                        const TextInputType.numberWithOptions(signed: true),
                    inputFormatters: [CurrencyInputFormatter()],
                    decoration: const InputDecoration(
                      labelText: 'حساب دفتری اولیه',
                      suffixText: 'تومان',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            SectionCard(
              title: 'حساب بانکی',
              icon: Icons.credit_card,
              child: Column(
                children: [
                  TextField(
                    controller: cardController,
                    maxLength: 16,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'شماره کارت',
                      counterText: '',
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: shebaController,
                    maxLength: 24,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'شماره شبا (بدون IR)',
                      prefixText: 'IR-',
                      counterText: '',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.save_as),
                label: const Text('ذخیره تغییرات'),
                onPressed: () async {
                  try{
                    if (nameController.text.isEmpty) return;

                    final updatedWorker = worker.copyWith(
                      name: nameController.text,
                      jobTitle: jobController.text,
                      phoneNumber: phoneController.text,
                      wageType: wageTypeState.value,
                      baseWage: parseCurrency(baseWageController.text),
                      initialDebt: parseCurrency(initialDebtController.text),
                      cardNumber: cardController.text,
                      shebaNumber: shebaController.text,
                      updatedAt: DateTime.now(),
                    );

                    // فراخوانی UseCase آپدیت
                    await ref
                        .read(updateWorkerUseCaseProvider)
                        .call(updatedWorker);
                    ref.invalidate(workerFinancialsProvider(worker.id));
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('اطلاعات با موفقیت ویرایش شد'),
                        ),
                      );
                      context.pop(); // برگشت به صفحه قبل
                    }
                  }catch(e){
                    developer.log(e.toString());
                    if(context.mounted)
                    {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('خطا در ویرایش کارگر: $e')),);
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
