import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/cell.dart';
import '../../data/models/game_state.dart';
import '../../data/models/shape.dart';

/// Provider для управления состоянием игры
final gameProvider = StateNotifierProvider<GameNotifier, GameState>((ref) {
  return GameNotifier();
});

/// Notifier для управления игровой логикой
class GameNotifier extends StateNotifier<GameState> {
  GameNotifier() : super(GameState.initial());

  /// Начать новую игру
  void newGame() {
    state = GameState.initial();
  }

  /// Проверить, можно ли разместить фигуру на позиции (row, col)
  bool canPlaceShape(GameShape shape, int row, int col) {
    // Если фигура уже использована - нельзя разместить
    if (shape.isUsed) return false;

    // Проверяем границы
    if (row < 0 || col < 0) return false;
    if (row + shape.height > state.gridHeight) return false;
    if (col + shape.width > state.gridWidth) return false;

    // Проверяем, не занята ли каждая клетка фигуры
    for (int r = 0; r < shape.height; r++) {
      for (int c = 0; c < shape.width; c++) {
        if (shape.pattern[r][c]) {
          if (state.grid[row + r][col + c].filled) {
            return false;
          }
        }
      }
    }

    return true;
  }

  /// Разместить фигуру на поле
  void placeShape(GameShape shape, int row, int col) {
    // Если фигура уже использована - игнорируем
    if (shape.isUsed) return;

    if (!canPlaceShape(shape, row, col)) return;

    // Копируем сетку
    final newGrid = GameState.copyGrid(state.grid);

    // Размещаем фигуру
    for (int r = 0; r < shape.height; r++) {
      for (int c = 0; c < shape.width; c++) {
        if (shape.pattern[r][c]) {
          newGrid[row + r][col + c] = Cell.filled(shape.color);
        }
      }
    }

    // Отмечаем фигуру как использованную (не удаляем из списка!)
    final newShapes = state.availableShapes.map((s) {
      if (s.id == shape.id) {
        return s.copyWith(isUsed: true);
      }
      return s;
    }).toList();

    // Обновляем состояние с использованными фигурами
    state = state.copyWith(
      grid: newGrid,
      availableShapes: newShapes,
      moveCount: state.moveCount + 1,
    );

    // Проверяем, все ли 3 фигуры использованы
    final allUsed = newShapes.every((s) => s.isUsed);

    // Если все использованы - генерируем новые сразу, но с задержкой перед отображением
    if (allUsed) {
      // Сначала показываем пустые места (текущее состояние с isUsed)
      // Затем через задержку генерируем новые
      Future.delayed(const Duration(milliseconds: 500), () {
        final freshShapes = _generateShapesWithGuarantee();
        state = state.copyWith(availableShapes: freshShapes);
      });
    }

    // Проверяем и очищаем заполненные линии
    _checkAndClearLines();

    // Проверяем, может ли игрок сделать ход
    _checkGameOver();
  }

  /// Проверить и очистить заполненные линии
  void _checkAndClearLines() {
    // Находим заполненные строки
    final rowsToClear = <int>[];
    for (int r = 0; r < state.gridHeight; r++) {
      if (state.grid[r].every((cell) => cell.filled)) {
        rowsToClear.add(r);
      }
    }

    // Находим заполненные столбцы
    final colsToClear = <int>[];
    for (int c = 0; c < state.gridWidth; c++) {
      if (state.grid.every((row) => row[c].filled)) {
        colsToClear.add(c);
      }
    }

    if (rowsToClear.isEmpty && colsToClear.isEmpty) {
      return;
    }

    // Общая анимация всех линий занимает ~0.5 секунды
    // Задержка между исчезновением соседних клеток
    const delayPerCell = 50; // 50ms между началом анимации каждой клетки
    const cellAnimationDuration = 150; // Длительность анимации одной клетки

    // Создаем список клеток для анимации с координатами и задержками
    final cellsToAnimate = <({int row, int col, int delay})>[];

    // Горизонтальные ряды: слева направо
    for (final r in rowsToClear) {
      for (int c = 0; c < state.gridWidth; c++) {
        cellsToAnimate.add((row: r, col: c, delay: c * delayPerCell));
      }
    }

    // Вертикальные ряды: снизу вверх
    for (final c in colsToClear) {
      for (int r = 0; r < state.gridHeight; r++) {
        // Проверяем, не добавлена ли уже эта клетка (пересечение)
        final alreadyAdded = cellsToAnimate.any((cell) => cell.row == r && cell.col == c);
        if (!alreadyAdded) {
          // Снизу вверх: нижняя клетка (r=9) начинает первой, верхняя (r=0) последней
          final delay = (state.gridHeight - 1 - r) * delayPerCell;
          cellsToAnimate.add((row: r, col: c, delay: delay));
        }
      }
    }

    // Помечаем ВСЕ клетки для анимации СРАЗУ, но с разными задержками
    final newGrid = GameState.copyGrid(state.grid);
    for (final cellInfo in cellsToAnimate) {
      newGrid[cellInfo.row][cellInfo.col] = newGrid[cellInfo.row][cellInfo.col].copyWith(
        isClearing: true,
        clearingDelay: cellInfo.delay, // Сохраняем задержку в клетке
      );
    }

    // Обновляем состояние ОДИН раз - все клетки помечены, но с разными задержками
    state = state.copyWith(grid: newGrid);

    // Находим максимальную задержку
    final maxDelay = cellsToAnimate.isEmpty
        ? 0
        : cellsToAnimate.map((c) => c.delay).reduce((a, b) => a > b ? a : b);

    // Очищаем все клетки после завершения всех анимаций
    final totalAnimationTime = maxDelay + cellAnimationDuration;
    Future.delayed(Duration(milliseconds: totalAnimationTime), () {
      final clearedGrid = GameState.copyGrid(state.grid);
      int linesCleared = 0;

      // Очищаем все отмеченные клетки
      for (final cellInfo in cellsToAnimate) {
        clearedGrid[cellInfo.row][cellInfo.col] = Cell.empty();
        linesCleared++;
      }

      // Подсчёт очков: 10 очков за каждую очищенную клетку
      final points = linesCleared * 10;

      state = state.copyWith(
        grid: clearedGrid,
        score: state.score + points,
      );
    });
  }

  /// Проверить, окончена ли игра
  void _checkGameOver() {
    // Получаем только НЕиспользованные фигуры
    final unusedShapes = state.availableShapes.where((s) => !s.isUsed).toList();

    // Если нет неиспользованных фигур - игра продолжается (скоро придут новые)
    if (unusedShapes.isEmpty) {
      return;
    }

    // Проверяем, можно ли разместить хотя бы одну из НЕиспользованных фигур
    for (final shape in unusedShapes) {
      for (int r = 0; r < state.gridHeight; r++) {
        for (int c = 0; c < state.gridWidth; c++) {
          // Проверяем размещение без учета флага isUsed
          if (_canPlaceShapeIgnoringUsed(shape, r, c)) {
            return; // Есть возможный ход
          }
        }
      }
    }

    // Нет возможных ходов - игра окончена
    state = state.copyWith(gameOver: true);
  }

  /// Проверка размещения без учета флага isUsed (для _checkGameOver)
  bool _canPlaceShapeIgnoringUsed(GameShape shape, int row, int col) {
    // Проверяем границы
    if (row < 0 || col < 0) return false;
    if (row + shape.height > state.gridHeight) return false;
    if (col + shape.width > state.gridWidth) return false;

    // Проверяем, не занята ли каждая клетка фигуры
    for (int r = 0; r < shape.height; r++) {
      for (int c = 0; c < shape.width; c++) {
        if (shape.pattern[r][c]) {
          if (state.grid[row + r][col + c].filled) {
            return false;
          }
        }
      }
    }

    return true;
  }

  /// Генерировать 3 фигуры с гарантией, что хотя бы одна может быть размещена
  List<GameShape> _generateShapesWithGuarantee() {
    const maxAttempts = 10;

    for (int attempt = 0; attempt < maxAttempts; attempt++) {
      // Генерируем 3 случайные фигуры
      final shapes = List.generate(3, (_) => GameShape.random());

      // Проверяем, может ли хотя бы одна из них быть размещена
      for (final shape in shapes) {
        if (_canShapeBePlaced(shape)) {
          // Нашли набор, где есть хотя бы одна размещаемая фигура
          return shapes;
        }
      }
    }

    // Если после maxAttempts попыток не нашли - возвращаем последний набор
    // (это очень редкий случай, почти невозможный)
    return List.generate(3, (_) => GameShape.random());
  }

  /// Проверить, может ли фигура быть размещена где-то на поле
  bool _canShapeBePlaced(GameShape shape) {
    for (int r = 0; r < state.gridHeight; r++) {
      for (int c = 0; c < state.gridWidth; c++) {
        if (_canPlaceShapeIgnoringUsed(shape, r, c)) {
          return true;
        }
      }
    }
    return false;
  }

  /// Получить позицию ячейки сетки по глобальным координатам
  /// Возвращает (row, col) или null если вне сетки
  (int, int)? getGridPosition(Offset globalPosition, Offset gridOffset, double cellSize) {
    final localX = globalPosition.dx - gridOffset.dx;
    final localY = globalPosition.dy - gridOffset.dy;

    if (localX < 0 || localY < 0) return null;

    final col = (localX / cellSize).floor();
    final row = (localY / cellSize).floor();

    if (row >= state.gridHeight || col >= state.gridWidth) return null;

    return (row, col);
  }
}
