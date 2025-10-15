import 'cell.dart';
import 'shape.dart';

/// Модель состояния игры
class GameState {
  /// Игровое поле 10x10
  final List<List<Cell>> grid;

  /// Доступные фигуры для размещения (обычно 3 штуки)
  final List<GameShape> availableShapes;

  /// Текущий счёт
  final int score;

  /// Игра окончена?
  final bool gameOver;

  /// Номер хода (для отладки)
  final int moveCount;

  const GameState({
    required this.grid,
    required this.availableShapes,
    this.score = 0,
    this.gameOver = false,
    this.moveCount = 0,
  });

  /// Создаёт начальное состояние игры
  factory GameState.initial() {
    // Создаём пустое поле 10x10
    final grid = List.generate(
      10,
      (_) => List.generate(10, (_) => Cell.empty()),
    );

    // Генерируем 3 случайные фигуры
    final shapes = List.generate(3, (_) => GameShape.random());

    return GameState(
      grid: grid,
      availableShapes: shapes,
    );
  }

  /// Копирует состояние с новыми параметрами
  GameState copyWith({
    List<List<Cell>>? grid,
    List<GameShape>? availableShapes,
    int? score,
    bool? gameOver,
    int? moveCount,
  }) {
    return GameState(
      grid: grid ?? copyGrid(this.grid),
      availableShapes: availableShapes ?? List.from(this.availableShapes),
      score: score ?? this.score,
      gameOver: gameOver ?? this.gameOver,
      moveCount: moveCount ?? this.moveCount,
    );
  }

  /// Глубокое копирование сетки
  static List<List<Cell>> copyGrid(List<List<Cell>> grid) {
    return grid.map((row) => List<Cell>.from(row)).toList();
  }

  /// Получить высоту сетки
  int get gridHeight => grid.length;

  /// Получить ширину сетки
  int get gridWidth => grid.isEmpty ? 0 : grid[0].length;
}
