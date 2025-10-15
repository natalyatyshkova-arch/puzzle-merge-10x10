import 'dart:math';
import 'package:flutter/material.dart';
import '../../data/models/shape.dart';
import '../../../../core/theme/app_theme.dart';

/// Виджет для отображения фигуры
class ShapeWidget extends StatefulWidget {
  final GameShape shape;
  final double cellSize;
  final bool isDragging;
  final bool shouldShake;

  const ShapeWidget({
    super.key,
    required this.shape,
    this.cellSize = GameSizes.shapeCellSize,
    this.isDragging = false,
    this.shouldShake = false,
  });

  @override
  State<ShapeWidget> createState() => _ShapeWidgetState();
}

class _ShapeWidgetState extends State<ShapeWidget> with SingleTickerProviderStateMixin {
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _shakeAnimation = Tween<double>(
      begin: -3,
      end: 3,
    ).animate(CurvedAnimation(
      parent: _shakeController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void didUpdateWidget(ShapeWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.shouldShake && !oldWidget.shouldShake) {
      _startShaking();
    } else if (!widget.shouldShake && oldWidget.shouldShake) {
      _stopShaking();
    }
  }

  void _startShaking() {
    _shakeController.repeat(reverse: true);
  }

  void _stopShaking() {
    _shakeController.stop();
    _shakeController.reset();
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final content = Opacity(
      opacity: widget.isDragging ? 0.8 : 1.0,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: widget.isDragging ? 0.3 : 0.1),
              blurRadius: widget.isDragging ? 12 : 6,
              offset: Offset(0, widget.isDragging ? 4 : 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(widget.shape.height, (row) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(widget.shape.width, (col) {
                return Padding(
                  padding: EdgeInsets.only(
                    right: col < widget.shape.width - 1 ? GameSizes.shapeCellSpacing : 0,
                    bottom: row < widget.shape.height - 1 ? GameSizes.shapeCellSpacing : 0,
                  ),
                  child: _buildShapeCell(widget.shape.pattern[row][col], widget.shape.color),
                );
              }),
            );
          }),
        ),
      ),
    );

    // Оборачиваем в Stack для добавления крестика
    Widget shapeWithCross = widget.shouldShake
        ? Stack(
            clipBehavior: Clip.none,
            children: [
              content,
              // Крестик полностью за пределами белой подложки
              Positioned(
                top: -8,
                right: -8,
                child: Icon(
                  Icons.close,
                  size: 14,
                  color: const Color(0xFFB8B0C8),
                ),
              ),
            ],
          )
        : content;

    // Если нужно покачиваться - оборачиваем в AnimatedBuilder
    if (widget.shouldShake) {
      return AnimatedBuilder(
        animation: _shakeAnimation,
        builder: (context, child) {
          final offset = sin(_shakeController.value * 2 * pi) * _shakeAnimation.value;
          return Transform.translate(
            offset: Offset(offset, 0),
            child: child,
          );
        },
        child: shapeWithCross,
      );
    }

    return shapeWithCross;
  }

  /// Построить клетку фигуры
  Widget _buildShapeCell(bool filled, Color color) {
    if (!filled) {
      return Container(
        width: widget.cellSize,
        height: widget.cellSize,
      );
    }

    // Обычная закрашенная клетка
    return Container(
      width: widget.cellSize,
      height: widget.cellSize,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(GameSizes.smallCornerRadius),
      ),
    );
  }
}
