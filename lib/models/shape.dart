import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Модель игровой фигуры
class GameShape {
  /// Уникальный идентификатор фигуры
  final String id;

  /// Матрица фигуры (true = заполненная клетка, false = пустая)
  final List<List<bool>> pattern;

  /// Цвет фигуры
  final Color color;

  /// Использована ли фигура (размещена на поле)
  final bool isUsed;

  const GameShape({
    required this.id,
    required this.pattern,
    required this.color,
    this.isUsed = false,
  });

  /// Высота фигуры
  int get height => pattern.length;

  /// Ширина фигуры
  int get width => pattern.isEmpty ? 0 : pattern[0].length;

  /// Генерирует случайную фигуру
  factory GameShape.random() {
    final random = Random();
    final patterns = _getShapePatterns();
    final pattern = patterns[random.nextInt(patterns.length)];
    final color = GameColors.shapeColors[random.nextInt(GameColors.shapeColors.length)];

    // Генерируем уникальный ID: время + случайное число
    final timestamp = DateTime.now().microsecondsSinceEpoch;
    final randomSuffix = random.nextInt(1000000);
    final uniqueId = '${timestamp}_$randomSuffix';

    return GameShape(
      id: uniqueId,
      pattern: pattern,
      color: color,
    );
  }

  /// Библиотека шаблонов фигур (похожих на Tetris и блок-пазлы)
  static List<List<List<bool>>> _getShapePatterns() {
    return [
      // Одна клетка
      [
        [true],
      ],

      // Линия 2x1
      [
        [true, true],
      ],

      // Линия 3x1
      [
        [true, true, true],
      ],

      // Линия 4x1
      [
        [true, true, true, true],
      ],

      // Линия 5x1
      [
        [true, true, true, true, true],
      ],

      // Линия 1x2
      [
        [true],
        [true],
      ],

      // Линия 1x3
      [
        [true],
        [true],
        [true],
      ],

      // Линия 1x4
      [
        [true],
        [true],
        [true],
        [true],
      ],

      // Квадрат 2x2
      [
        [true, true],
        [true, true],
      ],

      // Квадрат 3x3
      [
        [true, true, true],
        [true, true, true],
        [true, true, true],
      ],

      // L-образная 1
      [
        [true, false],
        [true, false],
        [true, true],
      ],

      // L-образная 2
      [
        [false, true],
        [false, true],
        [true, true],
      ],

      // L-образная 3
      [
        [true, true],
        [true, false],
        [true, false],
      ],

      // L-образная 4
      [
        [true, true],
        [false, true],
        [false, true],
      ],

      // T-образная
      [
        [true, true, true],
        [false, true, false],
      ],

      // T-образная перевёрнутая
      [
        [false, true, false],
        [true, true, true],
      ],

      // Z-образная
      [
        [true, true, false],
        [false, true, true],
      ],

      // Z-образная перевёрнутая
      [
        [false, true, true],
        [true, true, false],
      ],

      // Угол маленький
      [
        [true, false],
        [true, true],
      ],

      // Угол маленький 2
      [
        [false, true],
        [true, true],
      ],

      // Угол маленький 3
      [
        [true, true],
        [true, false],
      ],

      // Угол маленький 4
      [
        [true, true],
        [false, true],
      ],

      // Крест
      [
        [false, true, false],
        [true, true, true],
        [false, true, false],
      ],
    ];
  }

  /// Создаёт копию фигуры с изменёнными параметрами
  GameShape copyWith({bool? isUsed}) {
    return GameShape(
      id: id,
      pattern: pattern,
      color: color,
      isUsed: isUsed ?? this.isUsed,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GameShape &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
