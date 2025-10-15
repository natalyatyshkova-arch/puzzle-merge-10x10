import 'package:flutter/material.dart';
import '../../data/models/shape.dart';
import '../../../../core/theme/app_theme.dart';

/// Overlay для отображения перетаскиваемой фигуры
class DraggableShapeOverlay extends StatelessWidget {
  final GameShape? shape;
  final Offset? position;
  final Offset? dragOffset; // Смещение от курсора до левого верхнего угла фигуры
  final bool canPlace;
  final double? cellSize; // Реальный размер ячейки на экране

  const DraggableShapeOverlay({
    super.key,
    this.shape,
    this.position,
    this.dragOffset,
    this.canPlace = false,
    this.cellSize,
  });

  @override
  Widget build(BuildContext context) {
    if (shape == null || position == null) {
      return const SizedBox.shrink();
    }

    // Используем реальный размер ячейки если доступен, иначе стандартный
    final effectiveCellSize = cellSize ?? GameSizes.cellSize;
    final spacing = GameSizes.cellSpacing;

    // Если есть сохраненное смещение - используем его, иначе центрируем
    final offset = dragOffset ?? Offset(
      shape!.width * effectiveCellSize / 2,
      shape!.height * effectiveCellSize / 2,
    );

    return Positioned(
      left: position!.dx - offset.dx,
      top: position!.dy - offset.dy,
      child: IgnorePointer(
        child: Opacity(
          opacity: 0.8,
          child: _buildLargeShape(shape!, canPlace, effectiveCellSize, spacing),
        ),
      ),
    );
  }

  /// Построить фигуру с размером ячеек поля
  Widget _buildLargeShape(GameShape shape, bool canPlace, double cellSize, double spacing) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(shape.height, (row) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(shape.width, (col) {
            if (!shape.pattern[row][col]) {
              // Пустая ячейка - показываем пространство
              return SizedBox(
                width: cellSize + (col < shape.width - 1 ? spacing : 0),
                height: cellSize + (row < shape.height - 1 ? spacing : 0),
              );
            }

            // Заполненная ячейка фигуры
            return Container(
              width: cellSize,
              height: cellSize,
              margin: EdgeInsets.only(
                right: col < shape.width - 1 ? spacing : 0,
                bottom: row < shape.height - 1 ? spacing : 0,
              ),
              decoration: BoxDecoration(
                color: canPlace ? shape.color : Colors.red.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(GameSizes.cornerRadius),
                border: Border.all(
                  color: canPlace ? shape.color.withValues(alpha: 0.5) : Colors.red,
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
            );
          }),
        );
      }),
    );
  }
}

/// Overlay для предпросмотра размещения фигуры на сетке
class ShapePlacementPreview extends StatelessWidget {
  final GameShape? shape;
  final int? row;
  final int? col;
  final bool canPlace;
  final double cellSize;
  final Offset gridOffset;

  const ShapePlacementPreview({
    super.key,
    this.shape,
    this.row,
    this.col,
    this.canPlace = false,
    required this.cellSize,
    required this.gridOffset,
  });

  @override
  Widget build(BuildContext context) {
    if (shape == null || row == null || col == null) {
      return const SizedBox.shrink();
    }

    return Positioned(
      left: gridOffset.dx + (col! * cellSize),
      top: gridOffset.dy + (row! * cellSize),
      child: IgnorePointer(
        child: _buildPreview(),
      ),
    );
  }

  Widget _buildPreview() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(shape!.height, (r) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(shape!.width, (c) {
            if (!shape!.pattern[r][c]) {
              return SizedBox(
                width: cellSize,
                height: cellSize,
              );
            }

            return Container(
              width: cellSize,
              height: cellSize,
              margin: EdgeInsets.only(
                right: c < shape!.width - 1 ? GameSizes.cellSpacing : 0,
                bottom: r < shape!.height - 1 ? GameSizes.cellSpacing : 0,
              ),
              decoration: BoxDecoration(
                color: canPlace
                    ? shape!.color.withValues(alpha: 0.5)
                    : Colors.red.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(GameSizes.smallCornerRadius),
                border: Border.all(
                  color: canPlace ? shape!.color : Colors.red,
                  width: 2,
                ),
              ),
            );
          }),
        );
      }),
    );
  }
}
