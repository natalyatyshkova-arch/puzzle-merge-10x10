import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/shape.dart';
import '../../domain/providers/game_provider.dart';
import '../../../localization/domain/providers/localization_provider.dart';
import '../../../settings/domain/providers/settings_provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_dialog.dart';
import '../widgets/game_grid.dart';
import '../../../settings/presentation/widgets/score_panel.dart';
import '../widgets/shape_selector.dart';
import '../widgets/power_ups_panel.dart';
import '../../../settings/presentation/screens/settings_screen.dart';
import '../../../shop/domain/providers/shop_provider.dart';
import '../../../shop/presentation/widgets/currency_counter.dart';
import '../../../shop/presentation/screens/shop_screen.dart';

/// Главный экран игры
class GameScreen extends ConsumerStatefulWidget {
  const GameScreen({super.key});

  @override
  ConsumerState<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends ConsumerState<GameScreen> {
  // Состояние перетаскивания
  GameShape? _draggingShape;
  Offset? _dragPosition;
  Offset? _dragOffset; // Смещение курсора относительно фигуры
  Offset? _localDragPosition; // Позиция в локальных координатах сетки
  int? _previewRow;
  int? _previewCol;
  bool _canPlace = false;

  // Ключ для получения позиции сетки
  final GlobalKey _gridKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(gameProvider);
    final gameNotifier = ref.read(gameProvider.notifier);

    final isDark = ref.watch(settingsProvider.select((s) => s.themeMode == ThemeMode.dark));

    return Scaffold(
      backgroundColor: AppColors.getBackground(isDark),
      body: GestureDetector(
        // Отключаем режим удаления/наслаивания при клике на любую область
        onTap: () {
          if (gameState.isRemovalModeActive) {
            ref.read(gameProvider.notifier).toggleRemovalMode();
          } else if (gameState.isOverlayModeActive) {
            ref.read(gameProvider.notifier).toggleOverlayMode();
          }
        },
        child: Stack(
          children: [
            SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // Размеры компонентов
                  final scorePanelHeight = 100.0;
                  final shapeSelectorHeight = 77.0;
                  final powerUpsPanelHeight = 90.0;

                  return Column(
                    children: [
                      // Панель счёта
                      Container(
                        height: scorePanelHeight,
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                        child: ScorePanel(
                          score: gameState.score,
                          onSettings: () => showSettingsDialog(context),
                        ),
                      ),

                      // Игровое поле (адаптивное с отступами 20px)
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                          child: Center(
                            child: FittedBox(
                              fit: BoxFit.contain,
                              child: Stack(
                                children: [
                                  // Сетка
                                  RepaintBoundary(
                                    key: _gridKey,
                                    child: GameGrid(grid: gameState.grid),
                                  ),

                                  // Перетаскиваемая фигура (внутри FittedBox)
                                  if (_draggingShape != null && _localDragPosition != null)
                                    _buildDraggingShape(),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Селектор фигур
                      SizedBox(
                        height: shapeSelectorHeight,
                        child: ShapeSelector(
                          shapes: gameState.availableShapes,
                          onShapeDragStart: _onShapeDragStart,
                          onShapeDragUpdate: _onShapeDragUpdate,
                          onShapeDragEnd: _onShapeDragEnd,
                          onShapeTap: (shape) {
                            ref.read(gameProvider.notifier).removeShape(shape);
                          },
                          isRemovalModeActive: gameState.isRemovalModeActive,
                        ),
                      ),

                      // Панель Power-Ups (бустеры)
                      Container(
                        height: powerUpsPanelHeight,
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                        child: PowerUpsPanel(
                          onUndo: _onUndo,
                          onRemoveShape: _onRemoveShape,
                          onPlaceOverlay: _onPlaceOverlay,
                          onPowerUp4: () => _showNewGameDialog(context, gameNotifier),
                          undoCount: gameState.undoBoostersCount,
                          removeShapeCount: gameState.removeShapeBoostersCount,
                          placeOverlayCount: gameState.placeOverlayBoostersCount,
                          isRemovalModeActive: gameState.isRemovalModeActive,
                          isOverlayModeActive: gameState.isOverlayModeActive,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            // Диалог окончания игры
            if (gameState.gameOver)
              _buildGameOverOverlay(context, gameState.score, gameNotifier),

            // Магазин
            if (ref.watch(shopProvider.select((s) => s.isShopOpen)))
              const ShopScreen(),
          ],
        ),
      ),
    );
  }

  /// Обработчик начала перетаскивания фигуры
  void _onShapeDragStart(GameShape shape, Offset globalPosition, Offset localPosition) {
    // Игнорируем использованные фигуры
    if (shape.isUsed) return;

    // Вычисляем смещение курсора относительно центра фигуры
    final cellSize = GameSizes.cellSize;
    final spacing = GameSizes.cellSpacing;
    final shapeWidth = shape.width * cellSize + (shape.width - 1) * spacing;
    final shapeHeight = shape.height * cellSize + (shape.height - 1) * spacing;

    setState(() {
      _draggingShape = shape;
      _dragPosition = globalPosition;
      _dragOffset = Offset(shapeWidth / 2, shapeHeight / 2); // Центр фигуры

      // Конвертируем глобальную позицию в локальную (относительно сетки)
      _updateLocalPosition(globalPosition);
    });
  }

  /// Обработчик обновления позиции перетаскивания
  void _onShapeDragUpdate(GameShape shape, Offset position) {
    // Обновляем предпросмотр и проверяем валидность
    _updatePlacementPreview(position);

    setState(() {
      _dragPosition = position;
      _updateLocalPosition(position);
    });
  }

  /// Конвертировать глобальную позицию в локальную (относительно сетки)
  void _updateLocalPosition(Offset globalPosition) {
    final gridBox = _gridKey.currentContext?.findRenderObject() as RenderBox?;
    if (gridBox == null || _dragOffset == null) return;

    // Конвертируем глобальную позицию в локальную относительно сетки
    // globalToLocal учитывает все трансформации, включая FittedBox
    final localPosition = gridBox.globalToLocal(globalPosition);

    // Вычитаем смещение, чтобы курсор был в центре фигуры
    _localDragPosition = Offset(
      localPosition.dx - _dragOffset!.dx,
      localPosition.dy - _dragOffset!.dy,
    );
  }

  /// Обработчик окончания перетаскивания
  void _onShapeDragEnd(GameShape shape) {
    if (_canPlace && _previewRow != null && _previewCol != null) {
      // Размещаем фигуру
      ref.read(gameProvider.notifier).placeShape(shape, _previewRow!, _previewCol!);
    }

    // Сбрасываем состояние
    setState(() {
      _draggingShape = null;
      _dragPosition = null;
      _dragOffset = null;
      _localDragPosition = null;
      _previewRow = null;
      _previewCol = null;
      _canPlace = false;
    });
  }

  /// Обработчик кнопки "Отменить ход"
  void _onUndo() {
    ref.read(gameProvider.notifier).undo();
  }

  /// Обработчик кнопки "Удалить фигуру"
  void _onRemoveShape() {
    ref.read(gameProvider.notifier).toggleRemovalMode();
  }

  /// Обработчик кнопки "Поставить поверх"
  void _onPlaceOverlay() {
    ref.read(gameProvider.notifier).toggleOverlayMode();
  }

  /// Обновить предпросмотр размещения
  void _updatePlacementPreview(Offset globalPosition) {
    final gridBox = _gridKey.currentContext?.findRenderObject() as RenderBox?;
    if (gridBox == null || _draggingShape == null || _localDragPosition == null) return;

    // Используем локальную позицию фигуры (левый верхний угол)
    // _localDragPosition уже содержит позицию левого верхнего угла фигуры
    // с учетом смещения курсора к центру
    final leftX = _localDragPosition!.dx;
    final topY = _localDragPosition!.dy;

    // Используем фиксированный размер ячейки (95px) и spacing (5px)
    final cellSize = GameSizes.cellSize;
    final spacing = GameSizes.cellSpacing;

    // Вычисляем на какую ячейку попадает левый верхний угол фигуры
    // Прибавляем половину ячейки, чтобы "защелкивание" происходило по центру ячейки
    final col = ((leftX + cellSize / 2) / (cellSize + spacing)).floor();
    final row = ((topY + cellSize / 2) / (cellSize + spacing)).floor();

    if (row < 0 || col < 0 || row >= 10 || col >= 10) {
      setState(() {
        _previewRow = null;
        _previewCol = null;
        _canPlace = false;
      });
      return;
    }

    // Проверяем, можно ли разместить фигуру
    final canPlace = ref.read(gameProvider.notifier).canPlaceShape(_draggingShape!, row, col);

    setState(() {
      _previewRow = row;
      _previewCol = col;
      _canPlace = canPlace;
    });
  }

  /// Построить перетаскиваемую фигуру в координатах сетки
  Widget _buildDraggingShape() {
    if (_draggingShape == null || _localDragPosition == null) {
      return const SizedBox.shrink();
    }

    final cellSize = GameSizes.cellSize;
    final spacing = GameSizes.cellSpacing;

    return Positioned(
      left: _localDragPosition!.dx,
      top: _localDragPosition!.dy,
      child: IgnorePointer(
        child: Opacity(
          opacity: 0.8,
          child: _buildShapeWidget(_draggingShape!, cellSize, spacing),
        ),
      ),
    );
  }

  /// Построить виджет фигуры
  Widget _buildShapeWidget(GameShape shape, double cellSize, double spacing) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(shape.height, (row) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(shape.width, (col) {
            if (!shape.pattern[row][col]) {
              return SizedBox(
                width: cellSize + (col < shape.width - 1 ? spacing : 0),
                height: cellSize + (row < shape.height - 1 ? spacing : 0),
              );
            }

            return Container(
              width: cellSize,
              height: cellSize,
              margin: EdgeInsets.only(
                right: col < shape.width - 1 ? spacing : 0,
                bottom: row < shape.height - 1 ? spacing : 0,
              ),
              decoration: BoxDecoration(
                color: _canPlace ? shape.color : Colors.red.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(GameSizes.cornerRadius),
                border: Border.all(
                  color: _canPlace ? shape.color.withValues(alpha: 0.5) : Colors.red,
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

  /// Построить overlay окончания игры
  Widget _buildGameOverOverlay(BuildContext context, int score, GameNotifier notifier) {
    final locale = ref.read(localizationProvider);
    final isDark = ref.read(settingsProvider.select((s) => s.themeMode == ThemeMode.dark));

    return Container(
      color: Colors.black.withValues(alpha: 0.75),
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(32),
          padding: const EdgeInsets.all(36),
          decoration: BoxDecoration(
            color: AppColors.getBackground(isDark),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.emoji_events_rounded,
                size: 72,
                color: Color(0xFFFFC107),
              ),
              const SizedBox(height: 20),
              Text(
                locale.gameOver,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: AppColors.getPrimary(isDark),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                '${locale.finalScore}: $score',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.getTertiary(isDark),
                ),
              ),
              const SizedBox(height: 28),
              ElevatedButton(
                onPressed: () => notifier.newGame(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.getAccent(isDark),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.refresh_rounded, size: 24),
                    const SizedBox(width: 8),
                    Text(
                      locale.newGame,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Показать диалог новой игры
  Future<void> _showNewGameDialog(BuildContext context, GameNotifier notifier) async {
    final locale = ref.read(localizationProvider);

    final result = await AppDialog.show(
      context: context,
      title: locale.newGameTitle,
      message: locale.newGameMessage,
      icon: Icons.refresh_rounded,
      confirmText: locale.ok,
      cancelText: locale.cancel,
    );

    if (result == true) {
      notifier.newGame();
    }
  }
}
