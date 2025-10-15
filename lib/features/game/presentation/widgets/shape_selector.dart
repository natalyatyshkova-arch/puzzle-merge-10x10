import 'package:flutter/material.dart';
import '../../data/models/shape.dart';
import 'shape_widget.dart';

/// Селектор фигур внизу экрана
class ShapeSelector extends StatelessWidget {
  final List<GameShape> shapes;
  final Function(GameShape, Offset, Offset) onShapeDragStart; // globalPosition, localPosition
  final Function(GameShape, Offset) onShapeDragUpdate;
  final Function(GameShape) onShapeDragEnd;
  final Function(GameShape)? onShapeTap; // Для режима удаления
  final bool isRemovalModeActive;

  const ShapeSelector({
    super.key,
    required this.shapes,
    required this.onShapeDragStart,
    required this.onShapeDragUpdate,
    required this.onShapeDragEnd,
    this.onShapeTap,
    this.isRemovalModeActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: shapes.asMap().entries.map((entry) {
          final index = entry.key;
          final shape = entry.value;

          // Если фигура использована - показываем пустое место
          if (shape.isUsed) {
            return SizedBox(
              key: ValueKey('empty_${shape.id}_$index'),
              width: 80,
              height: 80,
            );
          }
          return _DraggableShape(
            key: ValueKey('shape_${shape.id}_$index'),
            shape: shape,
            onDragStart: (globalPos, localPos) => onShapeDragStart(shape, globalPos, localPos),
            onDragUpdate: (offset) => onShapeDragUpdate(shape, offset),
            onDragEnd: () => onShapeDragEnd(shape),
            onTap: onShapeTap != null ? () => onShapeTap!(shape) : null,
            shouldShake: isRemovalModeActive,
          );
        }).toList(),
      ),
    );
  }
}

/// Виджет перетаскиваемой фигуры
class _DraggableShape extends StatefulWidget {
  final GameShape shape;
  final Function(Offset, Offset) onDragStart; // globalPosition, localPosition
  final Function(Offset) onDragUpdate;
  final VoidCallback onDragEnd;
  final VoidCallback? onTap; // Для режима удаления
  final bool shouldShake;

  const _DraggableShape({
    super.key,
    required this.shape,
    required this.onDragStart,
    required this.onDragUpdate,
    required this.onDragEnd,
    this.onTap,
    this.shouldShake = false,
  });

  @override
  State<_DraggableShape> createState() => _DraggableShapeState();
}

class _DraggableShapeState extends State<_DraggableShape> {
  bool _isDragging = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap != null
          ? () {
              // Останавливаем всплытие события, чтобы не сработал GestureDetector экрана
              widget.onTap!();
            }
          : null,
      // Блокируем всплытие tap события к родительскому GestureDetector
      behavior: HitTestBehavior.opaque,
      onPanStart: widget.shouldShake ? null : (details) {
        setState(() => _isDragging = true);
        widget.onDragStart(details.globalPosition, details.localPosition);
      },
      onPanUpdate: widget.shouldShake ? null : (details) {
        widget.onDragUpdate(details.globalPosition);
      },
      onPanEnd: widget.shouldShake ? null : (details) {
        setState(() => _isDragging = false);
        widget.onDragEnd();
      },
      onPanCancel: widget.shouldShake ? null : () {
        setState(() => _isDragging = false);
        widget.onDragEnd();
      },
      child: ShapeWidget(
        shape: widget.shape,
        isDragging: _isDragging,
        shouldShake: widget.shouldShake,
      ),
    );
  }
}
