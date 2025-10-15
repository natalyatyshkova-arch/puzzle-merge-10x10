import 'package:flutter/material.dart';
import '../../data/models/shape.dart';
import '../../../../core/theme/app_theme.dart';

/// Виджет для отображения фигуры
class ShapeWidget extends StatelessWidget {
  final GameShape shape;
  final double cellSize;
  final bool isDragging;

  const ShapeWidget({
    super.key,
    required this.shape,
    this.cellSize = GameSizes.shapeCellSize,
    this.isDragging = false,
  });

  @override
  Widget build(BuildContext context) {
    // Убираем AnimatedScale для перетаскиваемых фигур
    final content = Opacity(
      opacity: isDragging ? 0.8 : 1.0,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDragging ? 0.3 : 0.1),
              blurRadius: isDragging ? 12 : 6,
              offset: Offset(0, isDragging ? 4 : 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(shape.height, (row) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(shape.width, (col) {
                return Padding(
                  padding: EdgeInsets.only(
                    right: col < shape.width - 1 ? GameSizes.shapeCellSpacing : 0,
                    bottom: row < shape.height - 1 ? GameSizes.shapeCellSpacing : 0,
                  ),
                  child: _buildShapeCell(shape.pattern[row][col], shape.color),
                );
              }),
            );
          }),
        ),
      ),
    );

    // Применяем AnimatedScale только для фигур в панели (не перетаскиваемых)
    if (!isDragging) {
      return content;
    }

    return content;
  }

  /// Построить клетку фигуры
  Widget _buildShapeCell(bool filled, Color color) {
    return Container(
      width: cellSize,
      height: cellSize,
      decoration: BoxDecoration(
        color: filled ? color : Colors.transparent,
        borderRadius: BorderRadius.circular(GameSizes.smallCornerRadius),
      ),
    );
  }
}
