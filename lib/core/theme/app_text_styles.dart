import 'package:flutter/material.dart';
import 'app_colors.dart';

/// أنماط النصوص المستخدمة في التطبيق
/// تحتوي على جميع أنماط Typography بشكل مركزي
class AppTextStyles {
  AppTextStyles._();

  // ========== العناوين ==========

  /// عنوان كبير جداً (32px)
  static const TextStyle displayLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  /// عنوان كبير (28px)
  static const TextStyle displayMedium = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  /// عنوان متوسط (24px)
  static const TextStyle displaySmall = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  // ========== العناوين الفرعية ==========

  /// عنوان فرعي كبير (20px)
  static const TextStyle headlineLarge = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  /// عنوان فرعي متوسط (18px)
  static const TextStyle headlineMedium = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  /// عنوان فرعي صغير (16px)
  static const TextStyle headlineSmall = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  // ========== النص العادي ==========

  /// نص كبير (18px)
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
  );

  /// نص متوسط (16px)
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
  );

  /// نص صغير (14px)
  static const TextStyle bodySmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
  );

  // ========== التسميات ==========

  /// تسمية كبيرة (16px)
  static const TextStyle labelLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  /// تسمية متوسطة (14px)
  static const TextStyle labelMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );

  /// تسمية صغيرة (12px)
  static const TextStyle labelSmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textLight,
  );

  // ========== أنماط خاصة بالتطبيق ==========

  /// نص الأزرار
  static const TextStyle button = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textWhite,
  );

  /// عنوان صفحة Setup
  static const TextStyle setupTitle = TextStyle(
    fontSize: 25,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  /// وصف صفحة Setup
  static const TextStyle setupDescription = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );

  /// نص Progress (مثل "1/6")
  static const TextStyle progressText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
  );

  /// نص مدخل
  static const TextStyle inputText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
  );

  /// نص hint في المدخل
  static const TextStyle inputHint = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textLight,
  );
}