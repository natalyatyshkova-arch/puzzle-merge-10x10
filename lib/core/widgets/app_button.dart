import 'package:flutter/material.dart';
import '../theme/app_design_system.dart';

/// Универсальная кнопка приложения с градиентом и иконкой
///
/// Поддерживает:
/// - Иконку в центре
/// - Градиентный фон
/// - Бейдж в правом верхнем углу
/// - Состояния enabled/disabled с прозрачностью
/// - Настраиваемый размер
///
/// Использование:
/// ```dart
/// AppButton(
///   icon: Icons.undo_rounded,
///   color: Colors.blue,
///   onTap: () => print('Tapped'),
///   badge: CounterBadge(count: 3),
/// )
/// ```
class AppButton extends StatelessWidget {
  /// Иконка кнопки
  final IconData icon;

  /// Базовый цвет для градиента
  final Color color;

  /// Callback при нажатии
  final VoidCallback? onTap;

  /// Размер кнопки (по умолчанию большой 60x60)
  final double size;

  /// Виджет бейджа в правом верхнем углу (опционально)
  final Widget? badge;

  /// Включена ли кнопка (влияет на прозрачность и возможность нажатия)
  final bool enabled;

  /// Использовать градиент по умолчанию вместо цветового
  final bool usePrimaryGradient;

  const AppButton({
    super.key,
    required this.icon,
    required this.color,
    this.onTap,
    this.size = AppDesignSystem.buttonSizeLarge,
    this.badge,
    this.enabled = true,
    this.usePrimaryGradient = false,
  });

  @override
  Widget build(BuildContext context) {
    final gradient = usePrimaryGradient
        ? AppDesignSystem.primaryButtonGradient
        : AppDesignSystem.createButtonGradient(color);

    final iconSize = size * AppDesignSystem.buttonIconSizeRatio;

    return Opacity(
      opacity: enabled ? 1.0 : AppDesignSystem.disabledOpacity,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: enabled ? onTap : null,
          borderRadius: BorderRadius.circular(AppDesignSystem.radiusMedium),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Основная кнопка
              Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  gradient: gradient,
                  borderRadius: BorderRadius.circular(AppDesignSystem.radiusMedium),
                  boxShadow: enabled ? AppDesignSystem.mediumShadow : null,
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: iconSize,
                ),
              ),

              // Бейдж (если есть)
              if (badge != null)
                Positioned(
                  top: AppDesignSystem.badgeOffset,
                  right: AppDesignSystem.badgeOffset,
                  child: badge!,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
