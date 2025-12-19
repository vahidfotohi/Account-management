import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:construction_manager/core/di/dependency_injection.dart';

class SettingsPage extends HookConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ...
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(title: const Text('تنظیمات')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text('مدیریت داده‌ها', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
          const SizedBox(height: 8),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: Colors.grey.shade200)),
            child: Column(
              children: [
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(8)),
                    child: const Icon(Icons.cloud_upload, color: Colors.blue),
                  ),
                  title: const Text('پشتیبان‌گیری (Backup)'),
                  subtitle: const Text('ذخیره اطلاعات در فایل'),
                  onTap: () async {
                    try {
                      final repo = ref.read(backupRepositoryProvider);

                      final success = await repo.exportDatabase();

                      if (context.mounted) {
                        if (success) {
                          _showSuccessDialog(context, 'فایل با موفقیت در گوشی ذخیره شد.');
                        } else {
                        }
                      }
                    } catch (e) {
                      developer.log('Error during export: $e');
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('خطا: $e'), backgroundColor: Colors.red),
                        );
                      }
                    }
                  },
                ),
                const Divider(height: 1, indent: 60),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(8)),
                    child: const Icon(Icons.cloud_download, color: Colors.green),
                  ),
                  title: const Text('بازگردانی (Restore)'),
                  subtitle: const Text('ایمپورت فایل پشتیبان'),
                  onTap: () => _confirmRestore(context, ref),
                ),
              ],
            ),
          ),
          // ...
        ],
      ),
    );
  }



  // دیالوگ هشدار قبل از ایمپورت
  void _confirmRestore(BuildContext context, WidgetRef ref) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('هـشدار مهم', style: TextStyle(color: Colors.red)),
        content: const Text(
            'با بازگردانی اطلاعات، تمام داده‌های فعلی برنامه پاک شده و اطلاعات فایل جدید جایگزین می‌شود.\n\nآیا مطمئن هستید؟',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('انصراف')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: () async {
              Navigator.pop(ctx); // بستن دیالوگ
              try {
                final repo = ref.read(backupRepositoryProvider);
                final success = await repo.restoreDatabase();

                if (context.mounted) {
                  if (success) {
                    _showSuccessDialog(context, 'اطلاعات با موفقیت بازیابی شد.\nلطفا برنامه را بسته و دوباره باز کنید.');
                  }
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('فایل نامعتبر است یا خطا رخ داد: $e'), backgroundColor: Colors.red),
                  );
                }
              }
            },
            child: const Text('بله، جایگزین کن'),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(BuildContext context, String message) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        icon: const Icon(Icons.check_circle, color: Colors.green, size: 50),
        content: Text(message, textAlign: TextAlign.center),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('باشه')),
        ],
      ),
    );
  }
}

