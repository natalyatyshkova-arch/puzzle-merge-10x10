import 'package:flutter/material.dart';

/// Типы бустеров (power-ups) в игре
///
/// Каждый тип имеет:
/// - Иконку
/// - Цвет
/// - Идентификатор для локализации
///
/// Использование:
/// ```dart
/// final powerUp = PowerUpType.undo;
/// Icon(powerUp.icon, color: powerUp.color)
/// ```
enum PowerUpType {
  /// Отменить последний ход
  undo,

  /// Удалить фигуру из панели
  removeShape,

  /// Разместить фигуру поверх существующих
  overlay,

  /// Начать новую игру
  newGame;

  /// Получить иконку для этого типа бустера
  IconData get icon {
    switch (this) {
      case PowerUpType.undo:
        return Icons.undo_rounded;
      case PowerUpType.removeShape:
        return Icons.delete_outline_rounded;
      case PowerUpType.overlay:
        return Icons.layers_rounded;
      case PowerUpType.newGame:
        return Icons.refresh_rounded;
    }
  }

  /// Получить цвет для этого типа бустера
  Color get color {
    switch (this) {
      case PowerUpType.undo:
        return const Color(0xFF4ECDC4); // Бирюзовый
      case PowerUpType.removeShape:
        return const Color(0xFFFF6B6B); // Красный
      case PowerUpType.overlay:
        return const Color(0xFFFFE66D); // Жёлтый
      case PowerUpType.newGame:
        return const Color(0xFFAA96DA); // Фиолетовый
    }
  }

  /// Это кнопка удаления фигуры?
  bool get isRemovalButton => this == PowerUpType.removeShape;

  /// Это кнопка наслаивания?
  bool get isOverlayButton => this == PowerUpType.overlay;

  /// Есть ли у этого бустера счетчик использований?
  bool get hasCounter => this != PowerUpType.newGame;
}
