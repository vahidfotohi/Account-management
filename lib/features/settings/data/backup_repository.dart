// ignore_for_file: empty_catches

import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart'; // پکیج جدید
import 'package:intl/intl.dart';
import 'package:construction_manager/data/local/app_database.dart';
import 'package:path_provider/path_provider.dart';

class BackupRepository {
  final AppDatabase _db;

  BackupRepository(this._db);

  // --- متد ۱: ذخیره فایل (Export) به روش استاندارد ---
  Future<bool> exportDatabase() async {
    // 1. جمع‌آوری داده‌ها
    final workers = await _db.select(_db.workers).get();
    final projects = await _db.select(_db.projects).get();
    final workEntries = await _db.select(_db.workEntries).get();
    final payments = await _db.select(_db.payments).get();

    List<Receipt> receipts = [];
    try {
      receipts = await _db.select(_db.receipts).get();
    } catch (e) { }

    final Map<String, dynamic> backupData = {
      'version': 1,
      'timestamp': DateTime.now().toIso8601String(),
      'workers': workers.map((e) => e.toJson()).toList(),
      'projects': projects.map((e) => e.toJson()).toList(),
      'work_entries': workEntries.map((e) => e.toJson()).toList(),
      'payments': payments.map((e) => e.toJson()).toList(),
      'receipts': receipts.map((e) => e.toJson()).toList(),
    };

    final jsonString = jsonEncode(backupData);
    final fileName = 'backup_${DateFormat('yyyyMMdd_HHmm').format(DateTime.now())}.json';

    // 2. ساخت فایل موقت (Cache)
    final directory = await getTemporaryDirectory();
    final tempFile = File('${directory.path}/$fileName');
    await tempFile.writeAsString(jsonString);

    // 3. باز کردن دیالوگ ذخیره سیستم (Save Dialog)
    // این متد فایل موقت را می‌گیرد و از کاربر می‌پرسد کجا کپی‌اش کنم
    final params = SaveFileDialogParams(sourceFilePath: tempFile.path);
    final finalPath = await FlutterFileDialog.saveFile(params: params);

    // اگر کاربر ذخیره کرد، مسیر برمی‌گردد، اگر کنسل کرد null برمی‌گردد
    return finalPath != null;
  }

  // --- متد ۲: بازگردانی (Import) ---
  // این متد عالی کار می‌کند چون با محتوای فایل کار دارد نه آدرس آن
  Future<bool> restoreDatabase() async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
      withData: true, // خواندن مستقیم بایت‌ها (حل مشکل پرمیشن)
    );

    if (result != null) {
      String jsonString;

      if (result.files.single.bytes != null) {
        jsonString = utf8.decode(result.files.single.bytes!);
      }
      else if (result.files.single.path != null) {
        final file = File(result.files.single.path!);
        jsonString = await file.readAsString();
      } else {
        return false;
      }

      try {
        final data = jsonDecode(jsonString) as Map<String, dynamic>;

        await _db.transaction(() async {
          // پاک‌سازی
          await _db.delete(_db.workEntries).go();
          await _db.delete(_db.payments).go();
          await _db.delete(_db.receipts).go();
          await _db.delete(_db.workers).go();
          await _db.delete(_db.projects).go();

          // بازگردانی
          if (data['workers'] != null) {
            for (var item in data['workers']) {
              await _db.into(_db.workers).insert(Worker.fromJson(item));
            }
          }
          if (data['projects'] != null) {
            for (var item in data['projects']) {
              await _db.into(_db.projects).insert(Project.fromJson(item));
            }
          }
          if (data['work_entries'] != null) {
            for (var item in data['work_entries']) {
              await _db.into(_db.workEntries).insert(WorkEntry.fromJson(item));
            }
          }
          if (data['payments'] != null) {
            for (var item in data['payments']) {
              await _db.into(_db.payments).insert(Payment.fromJson(item));
            }
          }
          if (data['receipts'] != null) {
            for (var item in data['receipts']) {
              await _db.into(_db.receipts).insert(Receipt.fromJson(item));
            }
          }
        });

        return true;
      } catch (e) {
        rethrow;
      }
    }
    return false;
  }
}