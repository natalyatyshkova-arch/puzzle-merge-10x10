import 'package:flutter/material.dart';
import '../../data/models/cell.dart';
import '../../../../core/theme/app_theme.dart';

/// Виджет игровой сетки 10x10
class GameGrid extends StatelessWidget {
  final List<List<Cell>> grid;
  final Function(Offset)? onDragUpdate;
  final VoidCallback? onDragEnd;

  const GameGrid({
    super.key,
    required this.grid,
    this.onDragUpdate,
    this.onDragEnd,
  });

  @override
  Widget build(BuildContext context) {
    // Используем фиксированный размер клетки 95px
    const cellSize = GameSizes.cellSize;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isDark ? GameColors.gridBackgroundDark : GameColors.gridBackgroundLight,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(10, (row) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(10, (col) {
              return Padding(
                padding: EdgeInsets.only(
                  right: col < 9 ? GameSizes.cellSpacing : 0,
                  bottom: row < 9 ? GameSizes.cellSpacing : 0,
                ),
                child: _buildCell(grid[row][col], cellSize, row, col),
              );
            }),
          );
        }),
      ),
    );
  }

  /// Построить одну клетку сетки
  Widget _buildCell(Cell cell, double size, int row, int col) {
    return Builder(
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: size,
          height: size,
          decoration: BoxDecoration(
            // Если клетка очищается, не показываем цвет в базовом контейнере
            color: cell.isClearing
                ? (isDark ? GameColors.emptyCellFillDark : GameColors.emptyCellFillLight)
                : (cell.filled
                    ? cell.color
                    : (isDark ? GameColors.emptyCellFillDark : GameColors.emptyCellFillLight)),
            borderRadius: BorderRadius.circular(GameSizes.smallCornerRadius),
            border: Border.all(
              color: isDark ? GameColors.gridLineDark : GameColors.gridLineLight,
              width: 0.5,
            ),
          ),
          // Анимация для очистки линий
          child: cell.isClearing
              ? _ClearAnimation(
                  // Уникальный ключ с учетом позиции и задержки
                  key: ValueKey('clear_$row' '_$col' '_${cell.clearingDelay}'),
                  delay: cell.clearingDelay,
                  color: cell.color ?? Colors.transparent,
                )
              : null,
        );
      },
    );
  }
}

/// Виджет для анимации очистки клетки
class _ClearAnimation extends StatefulWidget {
  final Color color;
  final int delay;

  const _ClearAnimation({
    super.key,
    required this.color,
    required this.delay,
  });

  @override
  State<_ClearAnimation> createState() => _ClearAnimationState();
}

class _ClearAnimationState extends State<_ClearAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _animation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Запускаем анимацию после задержки
    if (widget.delay > 0) {
      Future.delayed(Duration(milliseconds: widget.delay), () {
        if (mounted) {
          _controller.forward();
        }
      });
    } else {
      // Если задержки нет, запускаем сразу
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        // До начала анимации показываем клетку полностью (opacity=1, scale=1)
        // После начала анимации показываем с текущим значением анимации
        final animValue = _controller.isAnimating || _controller.isCompleted
            ? _animation.value
            : 1.0;

        return Opacity(
          opacity: animValue,
          child: Transform.scale(
            scale: animValue,
            child: Container(
              decoration: BoxDecoration(
                color: widget.color,
                borderRadius: BorderRadius.circular(GameSizes.smallCornerRadius),
              ),
            ),
          ),
        );
      },
    );
  }
}
