import 'package:flutter/material.dart';

class AppTheme {
  // رنگ‌های اصلی مدرن (سرمه‌ای تیره و طلایی ملایم)
  static const Color primaryColor = Color(0xFF1E293B); // Dark Slate Blue
  static const Color secondaryColor = Color(0xFF3B82F6); // Blue
  static const Color accentColor = Color(0xFFF59E0B); // Amber/Gold
  static const Color backgroundColor = Color(0xFFF8FAFC); // Very Light Grey-Blue
  static const Color surfaceColor = Colors.white;
  static const Color errorColor = Color(0xFFEF4444);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      // اگر فونت وزیر را لوکال دارید نامش را اینجا بنویسید، وگرنه از گوگل فونت استفاده کنید
      fontFamily: 'Vazir', // فرض بر این است که فونت وزیر در pubspec تعریف شده

      scaffoldBackgroundColor: backgroundColor,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        primary: primaryColor,
        secondary: secondaryColor,
        surface: surfaceColor,
        error: errorColor,
        brightness: Brightness.light,
      ),

      // --- استایل AppBar ---
      appBarTheme: const AppBarTheme(
        backgroundColor: backgroundColor,
        foregroundColor: primaryColor,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: 'Vazir',
          color: primaryColor,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(color: primaryColor),
      ),

      // --- استایل TextField (مدرن و مینیمال) ---
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceColor,
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: secondaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: errorColor),
        ),
        labelStyle: TextStyle(color: Colors.grey.shade600, fontSize: 14),
        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
        prefixIconColor: Colors.grey.shade500,
        suffixIconColor: Colors.grey.shade500,
      ),

      // --- استایل دکمه‌ها ---
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 2,
          shadowColor: primaryColor.withOpacity(0.3),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Vazir',
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      // --- استایل کارت‌ها ---
      cardTheme: CardThemeData(
        color: surfaceColor,
        elevation: 0, // مینیمال (بدون سایه تیز)
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.grey.shade200), // خط دور ملایم
        ),
        margin: const EdgeInsets.only(bottom: 16),
      ),
    );
  }
}