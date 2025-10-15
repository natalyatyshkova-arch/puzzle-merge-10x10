import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/shape.dart';
import '../../providers/settings_provider.dart';
import '../../theme/app_colors.dart';
import 'shape_widget.dart';

/// Селектор фигур внизу экрана
class ShapeSelector extends ConsumerWidget {
  final List<GameShape> shapes;
  final Function(GameShape, Offset, Offset) onShapeDragStart; // globalPosition, localPosition
  final Function(GameShape, Offset) onShapeDragUpdate;
  final Function(GameShape) onShapeDragEnd;

  const ShapeSelector({
    super.key,
    required this.shapes,
    required this.onShapeDragStart,
    required this.onShapeDragUpdate,
    required this.onShapeDragEnd,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(settingsProvider.select((s) => s.themeMode == ThemeMode.dark));

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.getSurface(isDark).withValues(alpha: 0.7),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
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

  const _DraggableShape({
    super.key,
    required this.shape,
    required this.onDragStart,
    required this.onDragUpdate,
    required this.onDragEnd,
  });

  @override
  State<_DraggableShape> createState() => _DraggableShapeState();
}

class _DraggableShapeState extends State<_DraggableShape> {
  bool _isDragging = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (details) {
        setState(() => _isDragging = true);
        widget.onDragStart(details.globalPosition, details.localPosition);
      },
      onPanUpdate: (details) {
        widget.onDragUpdate(details.globalPosition);
      },
      onPanEnd: (details) {
        setState(() => _isDragging = false);
        widget.onDragEnd();
      },
      onPanCancel: () {
        setState(() => _isDragging = false);
        widget.onDragEnd();
      },
      child: ShapeWidget(
        shape: widget.shape,
        isDragging: _isDragging,
      ),
    );
  }
}
