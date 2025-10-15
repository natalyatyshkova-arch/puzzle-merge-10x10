import 'package:flutter/material.dart';

/// Модель клетки на игровом поле
class Cell {
  /// Заполнена ли клетка
  final bool filled;

  /// Цвет блока (если клетка заполнена)
  final Color? color;

  /// Флаг анимации очистки
  final bool isClearing;

  /// Задержка начала анимации очистки (в миллисекундах)
  final int clearingDelay;

  const Cell({
    this.filled = false,
    this.color,
    this.isClearing = false,
    this.clearingDelay = 0,
  });

  /// Создаёт пустую клетку
  factory Cell.empty() => const Cell();

  /// Создаёт заполненную клетку с цветом
  factory Cell.filled(Color color) => Cell(filled: true, color: color);

  /// Копирует клетку с новыми параметрами
  Cell copyWith({
    bool? filled,
    Color? color,
    bool? isClearing,
    int? clearingDelay,
  }) {
    return Cell(
      filled: filled ?? this.filled,
      color: color ?? this.color,
      isClearing: isClearing ?? this.isClearing,
      clearingDelay: clearingDelay ?? this.clearingDelay,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Cell &&
          runtimeType == other.runtimeType &&
          filled == other.filled &&
          color == other.color &&
          isClearing == other.isClearing &&
          clearingDelay == other.clearingDelay;

  @override
  int get hashCode => filled.hashCode ^ color.hashCode ^ isClearing.hashCode ^ clearingDelay.hashCode;
}
