import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../settings/domain/providers/settings_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_design_system.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/counter_badge.dart';
import '../../data/models/power_up_type.dart';

/// Панель с power-ups (бустеры)
///
/// Отрефакторена для использования переиспользуемых компонентов:
/// - AppButton для кнопок бустеров
/// - CounterBadge для счетчиков
/// - PowerUpType enum для типов бустеров
/// - AppDesignSystem для размеров и отступов
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
      padding: EdgeInsets.symmetric(
        horizontal: AppDesignSystem.paddingSmall,
        vertical: AppDesignSystem.paddingMedium,
      ),
      decoration: BoxDecoration(
        color: AppColors.getSurface(isDark).withValues(
          alpha: AppDesignSystem.backgroundOpacity,
        ),
        borderRadius: BorderRadius.circular(AppDesignSystem.radiusLarge),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildPowerUpButton(
            type: PowerUpType.undo,
            onTap: onUndo,
            count: undoCount,
          ),
          SizedBox(width: AppDesignSystem.spacingMedium),
          _buildPowerUpButton(
            type: PowerUpType.removeShape,
            onTap: onRemoveShape,
            count: removeShapeCount,
          ),
          SizedBox(width: AppDesignSystem.spacingMedium),
          _buildPowerUpButton(
            type: PowerUpType.overlay,
            onTap: onPlaceOverlay,
            count: placeOverlayCount,
          ),
          SizedBox(width: AppDesignSystem.spacingMedium),
          _buildPowerUpButton(
            type: PowerUpType.newGame,
            onTap: onPowerUp4,
            count: null, // У кнопки "Начать заново" нет счётчика
          ),
        ],
      ),
    );
  }

  /// Построить кнопку power-up с использованием переиспользуемых компонентов
  Widget _buildPowerUpButton({
    required PowerUpType type,
    required VoidCallback? onTap,
    int? count,
  }) {
    // Определяем, нужно ли затемнить кнопку
    final shouldDim = (isRemovalModeActive && !type.isRemovalButton) ||
        (isOverlayModeActive && !type.isOverlayButton);

    // Создаём бейдж если есть счётчик
    final badge = count != null
        ? CounterBadge(
            count: count,
            showBuyButton: true, // Показываем кнопку покупки когда count == 0
          )
        : null;

    return AppButton(
      icon: type.icon,
      color: type.color,
      onTap: onTap,
      enabled: !shouldDim,
      badge: badge,
      usePrimaryGradient: true, // Используем стандартный градиент
    );
  }
}
