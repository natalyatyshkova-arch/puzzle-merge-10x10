import 'package:flutter/material.dart';

/// Дизайн-система приложения
/// Содержит все константы для размеров, отступов, радиусов и градиентов
///
/// Использование:
/// ```dart
/// Container(
///   width: AppDesignSystem.buttonSizeLarge,
///   padding: EdgeInsets.all(AppDesignSystem.paddingMedium),
///   decoration: BoxDecoration(
///     gradient: AppDesignSystem.primaryButtonGradient,
///     borderRadius: BorderRadius.circular(AppDesignSystem.radiusMedium),
///   ),
/// )
/// ```
class AppDesignSystem {
  // ==================== РАЗМЕРЫ КНОПОК ====================

  /// Большая кнопка (60x60) - для основных действий
  static const double buttonSizeLarge = 60.0;

  /// Средняя кнопка (48x48) - для второстепенных действий
  static const double buttonSizeMedium = 48.0;

  /// Маленькая кнопка (36x36) - для компактных элементов
  static const double buttonSizeSmall = 36.0;

  /// Размер иконки внутри кнопки (относительно размера кнопки)
  static const double buttonIconSizeRatio = 0.53;

  // ==================== РАЗМЕРЫ БЕЙДЖЕЙ ====================

  /// Размер бейджа со счетчиком
  static const double badgeSize = 24.0;

  /// Размер иконки в бейдже
  static const double badgeIconSize = 16.0;

  /// Размер шрифта в бейдже
  static const double badgeFontSize = 18.0;

  // ==================== РАДИУСЫ СКРУГЛЕНИЯ ====================

  /// Маленький радиус (8px) - для мелких элементов
  static const double radiusSmall = 8.0;

  /// Средний радиус (16px) - для кнопок и карточек
  static const double radiusMedium = 16.0;

  /// Большой радиус (20px) - для панелей
  static const double radiusLarge = 20.0;

  /// Очень большой радиус (24px) - для больших контейнеров
  static const double radiusExtraLarge = 24.0;

  // ==================== ОТСТУПЫ ====================

  /// Очень маленький отступ (4px)
  static const double paddingExtraSmall = 4.0;

  /// Маленький отступ (8px)
  static const double paddingSmall = 8.0;

  /// Средний отступ (12px)
  static const double paddingMedium = 12.0;

  /// Большой отступ (16px)
  static const double paddingLarge = 16.0;

  /// Очень большой отступ (24px)
  static const double paddingExtraLarge = 24.0;

  // ==================== РАССТОЯНИЯ МЕЖДУ ЭЛЕМЕНТАМИ ====================

  /// Маленькое расстояние между элементами (8px)
  static const double spacingSmall = 8.0;

  /// Среднее расстояние между элементами (12px)
  static const double spacingMedium = 12.0;

  /// Большое расстояние между элементами (16px)
  static const double spacingLarge = 16.0;

  /// Очень большое расстояние между элементами (24px)
  static const double spacingExtraLarge = 24.0;

  // ==================== ПРОЗРАЧНОСТЬ ====================

  /// Прозрачность для отключенных элементов
  static const double disabledOpacity = 0.4;

  /// Прозрачность при наведении
  static const double hoverOpacity = 0.8;

  /// Прозрачность для фона
  static const double backgroundOpacity = 0.7;

  // ==================== ТЕНИ ====================

  /// Легкая тень для карточек
  static List<BoxShadow> get lightShadow => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.1),
      blurRadius: 6,
      offset: const Offset(0, 2),
    ),
  ];

  /// Средняя тень для кнопок
  static List<BoxShadow> get mediumShadow => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.2),
      blurRadius: 8,
      offset: const Offset(0, 3),
    ),
  ];

  /// Сильная тень для модальных окон
  static List<BoxShadow> get strongShadow => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.3),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];

  /// Тень для бейджа
  static List<BoxShadow> get badgeShadow => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.2),
      blurRadius: 4,
      offset: const Offset(0, 2),
    ),
  ];

  // ==================== ГРАДИЕНТЫ ====================

  /// Основной градиент для кнопок (голубой)
  static const Gradient primaryButtonGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF8BB4EB), // Светлый голубой сверху
      Color(0xFF738BD8), // Тёмный голубой снизу
    ],
  );

  /// Создать градиент для кнопки на основе базового цвета
  ///
  /// Использование:
  /// ```dart
  /// decoration: BoxDecoration(
  ///   gradient: AppDesignSystem.createButtonGradient(Colors.red),
  /// )
  /// ```
  static Gradient createButtonGradient(Color baseColor) {
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        baseColor,
        HSLColor.fromColor(baseColor).withLightness(
          (HSLColor.fromColor(baseColor).lightness - 0.1).clamp(0.0, 1.0),
        ).toColor(),
      ],
    );
  }

  // ==================== ПОЗИЦИОНИРОВАНИЕ БЕЙДЖЕЙ ====================

  /// Смещение бейджа от края кнопки
  static const double badgeOffset = -6.0;
}
