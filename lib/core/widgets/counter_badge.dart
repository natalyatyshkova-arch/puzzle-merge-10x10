import 'package:flutter/material.dart';
import '../theme/app_design_system.dart';

/// Бейдж со счетчиком или кнопкой покупки
///
/// Используется для отображения количества доступных бустеров
/// или кнопки покупки когда бустеры закончились
///
/// Использование:
/// ```dart
/// // Бейдж со счетчиком
/// CounterBadge(count: 3)
///
/// // Бейдж с кнопкой покупки
/// CounterBadge(count: 0, showBuyButton: true)
/// ```
class CounterBadge extends StatelessWidget {
  /// Количество для отображения
  final int count;

  /// Показывать кнопку покупки вместо числа
  final bool showBuyButton;

  /// Цвет фона бейджа (по умолчанию оранжевый для счетчика, зелёный для покупки)
  final Color? backgroundColor;

  const CounterBadge({
    super.key,
    required this.count,
    this.showBuyButton = false,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final shouldShowBuy = showBuyButton && count <= 0;
    final bgColor = backgroundColor ??
        (shouldShowBuy ? Colors.green : Colors.orange);

    return Container(
      width: AppDesignSystem.badgeSize,
      height: AppDesignSystem.badgeSize,
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
        boxShadow: AppDesignSystem.badgeShadow,
      ),
      child: Center(
        child: shouldShowBuy
            ? const Icon(
                Icons.add,
                color: Colors.white,
                size: AppDesignSystem.badgeIconSize,
              )
            : Text(
                count.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: AppDesignSystem.badgeFontSize,
                  fontWeight: FontWeight.w900,
                  height: 1.0,
                ),
              ),
      ),
    );
  }
}
