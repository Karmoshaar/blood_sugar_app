import 'package:flutter/material.dart';

/// ألوان التطبيق المركزية
/// استخدمها في جميع أنحاء التطبيق للحفاظ على التناسق
class AppColors {
  // منع إنشاء instance
  AppColors._();

  // ========== الألوان الأساسية ==========

  /// اللون الأساسي (الأحمر/الوردي)
  static const Color primary = Color.fromARGB(255, 251, 68, 82);

  /// لون أفتح للـ Primary
  static const Color primaryLight = Color(0xFFFF9AA2);

  /// لون أغمق للـ Primary
  static const Color primaryDark = Color(0xFFFB4452);

  // ========== الألوان الخلفية ==========

  /// خلفية بيضاء
  static const Color background = Colors.white;

  /// خلفية رمادية فاتحة
  static const Color backgroundGrey = Color(0xFFF5F5F5);

  // ========== ألوان النصوص ==========

  /// نص أسود رئيسي
  static const Color textPrimary = Colors.black;

  /// نص رمادي ثانوي
  static const Color textSecondary = Color(0xFF757575);

  /// نص رمادي فاتح
  static const Color textLight = Color(0xFF9E9E9E);

  /// نص أبيض
  static const Color textWhite = Colors.white;

  // ========== ألوان الحالة ==========

  /// لون النجاح (أخضر)
  static const Color success = Color(0xFF4CAF50);

  /// لون الخطأ (أحمر)
  static const Color error = Color(0xFFF44336);

  /// لون التحذير (برتقالي)
  static const Color warning = Color(0xFFFF9800);

  /// لون المعلومات (أزرق)
  static const Color info = Color(0xFF2196F3);

  // ========== ألوان إضافية ==========

  /// رمادي للحدود
  static Color border = Colors.grey.shade300;

  /// رمادي للتعطيل
  static Color disabled = Colors.grey.shade400;

  /// ظل خفيف
  static Color shadow = Colors.black.withOpacity(0.1);

  /// ظل للـ Primary
  static Color primaryShadow = primary.withOpacity(0.3);

  // ========== Gradients ==========

  /// تدرج للون الأساسي
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryLight, primary],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  /// تدرج للون الأساسي (أفقي)
  static const LinearGradient primaryGradientHorizontal = LinearGradient(
    colors: [primaryLight, primary],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
}