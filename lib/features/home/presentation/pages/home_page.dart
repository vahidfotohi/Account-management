import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('مدیریت ساختمانی'),
        actions: [
          IconButton(
            onPressed: () => context.push('/settings'),
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16),
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        children: [
          _MenuCard(
            title: 'پرسنل',
            icon: Icons.people,
            color: Colors.blueAccent,
            onTap: () => context.push('/workers'),
          ),
          _MenuCard(
            title: 'پروژه‌ها',
            icon: Icons.apartment,
            color: Colors.orangeAccent,
            onTap: () => context.push('/projects'),
          ),
          _MenuCard(
            title: 'ثبت کارکرد',
            icon: Icons.assignment_add,
            color: Colors.deepPurpleAccent,
            onTap: () {
              context.push('/add-work-entry'); // مسیر جدید
            },
          ),
          _MenuCard(
            title: 'پرداختی (هزینه)',
            icon: Icons.payment,
            color: Colors.redAccent,
            onTap: () => context.push('/add-payment'),
          ),
          _MenuCard(
            title: 'دریافتی (درآمد)',
            icon: Icons.account_balance_wallet,
            color: Colors.green,
            onTap: () => context.push('/add-receipt'),
          ),
          _MenuCard(
            title: 'تاریخچه تراکنش‌ها',
            icon: Icons.history,
            color: Colors.blueGrey,
            onTap: () => context.push('/transactions'),
          ),
        ],
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _MenuCard(
      {required this.title,
      required this.icon,
      required this.color,
      required this.onTap,});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.5)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 10),
            Text(title,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
          ],
        ),
      ),
    );
  }
}
