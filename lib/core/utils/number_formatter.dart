import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }
    if (newValue.text == '-') {
      return newValue;
    }
    final bool isNegative = newValue.text.startsWith('-');

    final String newText = newValue.text.replaceAll(',', '').replaceAll('-', ''); // حذف کاما برای محاسبه
    if (newText.isEmpty) return newValue;

    try{
      final double value = double.parse(newText);
      final formatter = NumberFormat('#,###');
      String newTextFormatted = formatter.format(value);
      if (isNegative) {
        newTextFormatted = '-$newTextFormatted';
      }
      return newValue.copyWith(
        text: newTextFormatted,
        selection: TextSelection.collapsed(
          offset: newTextFormatted.length,
        ),
      );
    }catch (e) {
      // اگر خطایی در پارس کردن رخ داد (مثلا کاراکتر غیرمجاز)، مقدار قبلی را برگردان
      return oldValue;
    }

  }
}

// تابع کمکی برای تبدیل رشته فرمت شده به عدد خالص
double parseCurrency(String text) {
  if (text.isEmpty || text == '-') return 0;
  return double.parse(text.replaceAll(',', ''));
}


class ThousandsSeparatorInputFormatter extends TextInputFormatter {
  final NumberFormat _formatter = NumberFormat.decimalPattern('en_US');

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue,) {

    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    final String newTextClean = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    if (newTextClean.isEmpty) {
      return newValue.copyWith(text: '');
    }

    final int value = int.parse(newTextClean);
    final String newString = _formatter.format(value);

    int digitsBeforeCursor = 0;
    for (int i = 0; i < newValue.selection.end && i < newValue.text.length; i++) {
      if (RegExp(r'[0-9]').hasMatch(newValue.text[i])) {
        digitsBeforeCursor++;
      }
    }

    int newCursorOffset = 0;
    int currentDigits = 0;
    for (int i = 0; i < newString.length; i++) {
      if (currentDigits == digitsBeforeCursor) {
        break;
      }
      if (RegExp(r'[0-9]').hasMatch(newString[i])) {
        currentDigits++;
      }
      newCursorOffset++;
    }

    return TextEditingValue(
      text: newString,
      selection: TextSelection.collapsed(offset: newCursorOffset),
    );
  }
}