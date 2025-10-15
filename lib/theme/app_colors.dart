import 'package:flutter/material.dart';

/// Цвета приложения для светлой и тёмной темы
class AppColors {
  // Светлая тема
  static const Color lightBackground = Color(0xFFEBE4F5);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightPrimary = Color(0xFF4A4458);
  static const Color lightSecondary = Color(0xFFB8B0C8);
  static const Color lightTertiary = Color(0xFF8B7FA8);
  static const Color lightAccent = Color(0xFF8BE88B);

  // Тёмная тема
  static const Color darkBackground = Color(0xFF1E1A2E);
  static const Color darkSurface = Color(0xFF2D2640);
  static const Color darkPrimary = Color(0xFFE8E4F0);
  static const Color darkSecondary = Color(0xFF9B93B0);
  static const Color darkTertiary = Color(0xFFB8B0C8);
  static const Color darkAccent = Color(0xFF6FD46F);

  /// Получить цвет фона в зависимости от темы
  static Color getBackground(bool isDark) {
    return isDark ? darkBackground : lightBackground;
  }

  /// Получить цвет поверхности в зависимости от темы
  static Color getSurface(bool isDark) {
    return isDark ? darkSurface : lightSurface;
  }

  /// Получить основной цвет текста в зависимости от темы
  static Color getPrimary(bool isDark) {
    return isDark ? darkPrimary : lightPrimary;
  }

  /// Получить вторичный цвет в зависимости от темы
  static Color getSecondary(bool isDark) {
    return isDark ? darkSecondary : lightSecondary;
  }

  /// Получить третичный цвет в зависимости от темы
  static Color getTertiary(bool isDark) {
    return isDark ? darkTertiary : lightTertiary;
  }

  /// Получить акцентный цвет в зависимости от темы
  static Color getAccent(bool isDark) {
    return isDark ? darkAccent : lightAccent;
  }
}
