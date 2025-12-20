import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/utils/number_formatter.dart';
import '../../domain/entities/worker.dart';
import '../../../../core/di/dependency_injection.dart';

class AddWorkerPage extends HookConsumerWidget {
  const AddWorkerPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Controllers
    final nameController = useTextEditingController();
    final jobController = useTextEditingController();
    final phoneController = useTextEditingController();

    final baseWageController = useTextEditingController();
    final initialDebtController = useTextEditingController();
    final wageTypeState = useState(WageType.daily);

    final cardController = useTextEditingController();
    final shebaController = useTextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('ثبت پرسنل جدید')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- بخش ۱: اطلاعات فردی ---
            _FormSection(
              title: 'اطلاعات هویتی',
              icon: Icons.person_outline,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'نام و نام خانوادگی',
                    prefixIcon: Icon(Icons.badge_outlined),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: jobController,
                  decoration: const InputDecoration(
                    labelText: 'سمت / شغل',
                    prefixIcon: Icon(Icons.work_outline , ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'شماره موبایل',
                    prefixIcon: Icon(Icons.phone_android,),
                  ),
                ),
              ],
            ),

            // --- بخش ۲: اطلاعات مالی ---
            _FormSection(
              title: 'اطلاعات مالی و حقوق',
              icon: Icons.monetization_on_outlined,
              children: [
                DropdownButtonFormField<WageType>(
                  value: wageTypeState.value,
                  decoration: const InputDecoration(
                    labelText: 'نوع پرداخت دستمزد',
                    prefixIcon: Icon(Icons.category_outlined),
                  ),
                  items: WageType.values.map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(type.label),
                    );
                  }).toList(),
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
                    labelText: 'مبلغ دستمزد پایه',
                    suffixText: 'تومان',
                    prefixIcon: Icon(Icons.attach_money),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: initialDebtController,
                  keyboardType: const TextInputType.numberWithOptions(signed: true),
                  inputFormatters: [CurrencyInputFormatter()],
                  decoration: InputDecoration(
                    labelText: 'حساب دفتری قبلی',
                    suffixText: 'تومان',
                    prefixIcon: const Icon(Icons.history_edu),
                    helperText: 'مثبت (+) = بدهی شما | منفی (-) = طلب شما',
                    helperStyle: TextStyle(color: Colors.orange.shade800),
                  ),
                ),
              ],
            ),

            // --- بخش ۳: اطلاعات بانکی ---
            _FormSection(
              title: 'اطلاعات حساب بانکی',
              icon: Icons.account_balance_outlined,
              children: [
                TextField(
                  controller: cardController,
                  keyboardType: TextInputType.number,
                  maxLength: 16,
                  decoration: const InputDecoration(
                    labelText: 'شماره کارت',
                    counterText: '',
                    prefixIcon: Icon(Icons.credit_card),
                    suffixIcon: Icon(Icons.copy, size: 16),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: shebaController,
                  keyboardType: TextInputType.number,
                  maxLength: 26, // با احتساب IR
                  decoration: const InputDecoration(
                    labelText: 'شماره شبا',
                    hintText: 'بدون IR وارد کنید',
                    prefixText: 'IR - ',
                    counterText: '',
                    prefixIcon: Icon(Icons.account_balance_wallet_outlined),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // --- دکمه ثبت ---
            ElevatedButton.icon(
              onPressed: () async {
                try{
                  if (nameController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('نام الزامی است')),);
                    return;
                  }

                  final newWorker = Worker(
                    id: const Uuid().v4(),
                    name: nameController.text,
                    jobTitle: jobController.text,
                    wageType: wageTypeState.value,
                    baseWage: parseCurrency(baseWageController.text),
                    initialDebt: parseCurrency(initialDebtController.text),
                    cardNumber: cardController.text,
                    shebaNumber: shebaController.text,
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
                }catch(e){
                  developer.log(e.toString());
                  if(context.mounted)
                  {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('خطا در ثبت کارگر: $e')),);
                  }
                }
              },
              icon: const Icon(Icons.check_circle_outline),
              label: const Text('ثبت نهایی اطلاعات'),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

// --- ویجت کمکی برای بخش‌بندی فرم ---
class _FormSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const _FormSection({
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: Row(
            children: [
              Icon(icon, size: 20, color: Theme.of(context).primaryColor),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: children,
            ),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}