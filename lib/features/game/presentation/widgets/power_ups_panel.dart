import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../settings/domain/providers/settings_provider.dart';
import '../../../../core/theme/app_colors.dart';

/// Панель с power-ups (бустеры)
class PowerUpsPanel extends ConsumerWidget {
  final VoidCallback? onUndo;
  final VoidCallback? onRemoveShape;
  final VoidCallback? onPlaceOverlay;
  final VoidCallback? onPowerUp4;
  final int undoCount;
  final int removeShapeCount;
  final int placeOverlayCount;
  final bool isRemovalModeActive;
  final bool isOverlayModeActive;

  const PowerUpsPanel({
    super.key,
    this.onUndo,
    this.onRemoveShape,
    this.onPlaceOverlay,
    this.onPowerUp4,
    this.undoCount = 0,
    this.removeShapeCount = 0,
    this.placeOverlayCount = 0,
    this.isRemovalModeActive = false,
    this.isOverlayModeActive = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(settingsProvider.select((s) => s.themeMode == ThemeMode.dark));

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.getSurface(isDark).withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildPowerUpButton(
            icon: Icons.undo_rounded,
            color: const Color(0xFF4ECDC4), // Бирюзовый
            onTap: onUndo,
            isDark: isDark,
            count: undoCount,
            isRemovalButton: false,
          ),
          const SizedBox(width: 12),
          _buildPowerUpButton(
            icon: Icons.delete_outline_rounded,
            color: const Color(0xFFFF6B6B), // Красный
            onTap: onRemoveShape,
            isDark: isDark,
            count: removeShapeCount,
            isRemovalButton: true,
          ),
          const SizedBox(width: 12),
          _buildPowerUpButton(
            icon: Icons.layers_rounded,
            color: const Color(0xFFFFE66D), // Жёлтый
            onTap: onPlaceOverlay,
            isDark: isDark,
            count: placeOverlayCount,
            isRemovalButton: false,
            isOverlayButton: true,
          ),
          const SizedBox(width: 12),
          _buildPowerUpButton(
            icon: Icons.refresh_rounded,
            color: const Color(0xFFAA96DA), // Фиолетовый
            onTap: onPowerUp4,
            isDark: isDark,
            count: null, // У кнопки "Начать заново" нет счётчика
            isRemovalButton: false,
          ),
        ],
      ),
    );
  }

  /// Построить кнопку power-up
  Widget _buildPowerUpButton({
    required IconData icon,
    required Color color,
    required VoidCallback? onTap,
    required bool isDark,
    int? count,
    required bool isRemovalButton,
    bool isOverlayButton = false,
  }) {
    final showBuyButton = count != null && count <= 0;

    // Если режим удаления активен, и это НЕ кнопка удаления - делаем прозрачной на 40%
    // Если режим наслаивания активен, и это НЕ кнопка наслаивания - делаем прозрачной на 40%
    final shouldDim = (isRemovalModeActive && !isRemovalButton) ||
                      (isOverlayModeActive && !isOverlayButton);
    final opacity = shouldDim ? 0.4 : 1.0;

    return Opacity(
      opacity: opacity,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: shouldDim ? null : onTap, // Отключаем нажатие для затемненных кнопок
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF8BB4EB), // Светлый голубой сверху
                      Color(0xFF738BD8), // Тёмный голубой снизу
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              // Счётчик или кнопка покупки
              if (count != null)
                Positioned(
                  top: -6,
                  right: -6,
                  child: showBuyButton
                      ? _buildBuyButton()
                      : _buildCounterBadge(count),
                ),
            ],
          ),
        ),
      ),
    );
  }

  /// Построить счётчик бустеров
  Widget _buildCounterBadge(int count) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: Colors.orange,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Text(
          count.toString(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w900,
            height: 1.0,
          ),
        ),
      ),
    );
  }

  /// Построить кнопку покупки
  Widget _buildBuyButton() {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: Colors.green,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Center(
        child: Icon(
          Icons.add,
          color: Colors.white,
          size: 16,
        ),
      ),
    );
  }
}
