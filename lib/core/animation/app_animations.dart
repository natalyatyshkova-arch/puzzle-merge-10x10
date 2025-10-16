import 'package:flutter/material.dart';

/// Константы анимаций приложения
///
/// Содержит стандартные длительности, кривые и параметры для всех анимаций
///
/// Использование:
/// ```dart
/// AnimationController(
///   duration: AppAnimations.durationMedium,
///   vsync: this,
/// )
///
/// CurvedAnimation(
///   parent: controller,
///   curve: AppAnimations.curveDefault,
/// )
/// ```
class AppAnimations {
  // ==================== ДЛИТЕЛЬНОСТИ ====================

  /// Очень быстрая анимация (150ms) - для мгновенных изменений
  static const Duration durationExtraFast = Duration(milliseconds: 150);

  /// Быстрая анимация (200ms) - для простых переходов
  static const Duration durationFast = Duration(milliseconds: 200);

  /// Средняя анимация (300ms) - для обычных переходов
  static const Duration durationMedium = Duration(milliseconds: 300);

  /// Обычная анимация (500ms) - для заметных изменений
  static const Duration durationNormal = Duration(milliseconds: 500);

  /// Медленная анимация (800ms) - для выразительных эффектов
  static const Duration durationSlow = Duration(milliseconds: 800);

  /// Очень медленная анимация (1200ms) - для драматических эффектов
  static const Duration durationExtraSlow = Duration(milliseconds: 1200);

  // ==================== КРИВЫЕ ====================

  /// Стандартная кривая для большинства анимаций
  static const Curve curveDefault = Curves.easeInOut;

  /// Резкая кривая для быстрых изменений
  static const Curve curveSnappy = Curves.easeOutCubic;

  /// Плавная кривая для мягких переходов
  static const Curve curveSmooth = Curves.easeInOutCubic;

  /// Кривая с отскоком для игривых эффектов
  static const Curve curveBounce = Curves.elasticOut;

  /// Кривая с пружинящим эффектом
  static const Curve curveSpring = Curves.elasticInOut;

  // ==================== ПАРАМЕТРЫ SHAKE АНИМАЦИИ ====================

  /// Длительность анимации покачивания
  static const Duration shakeDuration = Duration(milliseconds: 800);

  /// Амплитуда покачивания (в пикселях)
  static const double shakeAmplitude = 3.0;

  /// Кривая для анимации покачивания
  static const Curve shakeCurve = Curves.easeInOut;

  // ==================== ПАРАМЕТРЫ SCALE АНИМАЦИИ ====================

  /// Длительность анимации масштабирования
  static const Duration scaleDuration = Duration(milliseconds: 200);

  /// Масштаб при наведении/нажатии
  static const double scaleOnHover = 1.05;

  /// Масштаб при нажатии
  static const double scaleOnPress = 0.95;

  // ==================== ПАРАМЕТРЫ FADE АНИМАЦИИ ====================

  /// Длительность анимации прозрачности
  static const Duration fadeDuration = Duration(milliseconds: 300);

  /// Начальная прозрачность для fade-in
  static const double fadeInStart = 0.0;

  /// Конечная прозрачность для fade-in
  static const double fadeInEnd = 1.0;

  // ==================== ПАРАМЕТРЫ ОЧИСТКИ ЯЧЕЕК ====================

  /// Длительность анимации очистки одной ячейки
  static const Duration clearCellDuration = Duration(milliseconds: 150);

  /// Задержка между анимацией очистки ячеек (в миллисекундах)
  static const int clearCellDelayMs = 50;

  /// Кривая для анимации очистки ячеек
  static const Curve clearCellCurve = Curves.easeOut;

  // ==================== ПАРАМЕТРЫ ПЕРЕТАСКИВАНИЯ ====================

  /// Прозрачность перетаскиваемого элемента
  static const double draggingOpacity = 0.8;

  /// Длительность возврата элемента на место
  static const Duration dragReturnDuration = Duration(milliseconds: 200);

  // ==================== ПАРАМЕТРЫ ПОЯВЛЕНИЯ ФИГУР ====================

  /// Длительность появления новых фигур
  static const Duration shapeAppearDuration = Duration(milliseconds: 300);

  /// Задержка между появлением фигур (в миллисекундах)
  static const int shapeAppearDelayMs = 100;

  /// Кривая для появления фигур
  static const Curve shapeAppearCurve = Curves.easeOutBack;
}
