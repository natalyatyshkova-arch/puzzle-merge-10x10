import 'package:flutter/material.dart';
import '../../../../core/theme/app_design_system.dart';
import '../../../../core/theme/app_colors.dart';

/// Счётчик кристаллов в правом верхнем углу
class CurrencyCounter extends StatelessWidget {
  final int amount;
  final VoidCallback onTap;
  final bool isDark;

  const CurrencyCounter({
    super.key,
    required this.amount,
    required this.onTap,
    required this.isDark,
  });

  /// Форматировать число (1,234 или 1.2K)
  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDesignSystem.radiusLarge),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppDesignSystem.paddingMedium,
            vertical: AppDesignSystem.paddingSmall,
          ),
          decoration: BoxDecoration(
            color: AppColors.getSurface(isDark).withValues(
              alpha: AppDesignSystem.backgroundOpacity,
            ),
            borderRadius: BorderRadius.circular(AppDesignSystem.radiusLarge),
            boxShadow: AppDesignSystem.lightShadow,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Иконка кристалла
              Icon(
                Icons.diamond_rounded,
                size: 20,
                color: const Color(0xFFAA96DA), // Фиолетовый
              ),
              SizedBox(width: AppDesignSystem.spacingSmall),
              // Количество
              Text(
                _formatNumber(amount),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: AppColors.getPrimary(isDark),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
