import 'package:flutter/material.dart';

import 'app_colors.dart';

abstract class AppTextStyles {
  static const display = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 1.15,
    color: AppColors.textPrimary,
  );

  static const headline = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 1.25,
    color: AppColors.textPrimary,
  );

  static const title = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.3,
    color: AppColors.textPrimary,
  );

  static const body = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.45,
    color: AppColors.textPrimary,
  );

  static const bodySmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.4,
    color: AppColors.textSecondary,
  );

  static const label = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.2,
    color: AppColors.textPrimary,
  );

  static const caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.25,
    color: AppColors.textMuted,
  );

  static TextTheme textTheme(Color textColor, Color secondaryTextColor) {
    return TextTheme(
      displaySmall: display.copyWith(color: textColor),
      headlineMedium: headline.copyWith(color: textColor),
      titleLarge: title.copyWith(color: textColor),
      titleMedium: label.copyWith(color: textColor),
      bodyLarge: body.copyWith(color: textColor),
      bodyMedium: bodySmall.copyWith(color: textColor),
      bodySmall: caption.copyWith(color: secondaryTextColor),
      labelLarge: label.copyWith(color: textColor),
      labelMedium: caption.copyWith(color: secondaryTextColor),
    );
  }
}
