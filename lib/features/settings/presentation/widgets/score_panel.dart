import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../localization/domain/providers/localization_provider.dart';
import '../../domain/providers/settings_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../shop/domain/providers/shop_provider.dart';
import '../../../shop/presentation/widgets/currency_counter.dart';

/// Панель счёта и управления
class ScorePanel extends ConsumerWidget {
  final int score;
  final VoidCallback? onSettings;

  const ScorePanel({
    super.key,
    required this.score,
    this.onSettings,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localizationProvider);
    final isDark = ref.watch(settingsProvider.select((s) => s.themeMode == ThemeMode.dark));

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.getSurface(isDark).withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Кнопка настроек слева
          IconButton(
            onPressed: onSettings,
            icon: const Icon(Icons.settings_rounded),
            iconSize: 32,
            color: AppColors.getSecondary(isDark),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),

          // Счёт (вертикальная компоновка по центру)
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  locale.score,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.getSecondary(isDark),
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 4),
                TweenAnimationBuilder<int>(
                  tween: IntTween(begin: 0, end: score),
                  duration: const Duration(milliseconds: 500),
                  builder: (context, value, child) {
                    return Text(
                      value.toString(),
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w900,
                        color: AppColors.getPrimary(isDark),
                        height: 1.0,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          // Счётчик кристаллов справа
          CurrencyCounter(
            amount: ref.watch(shopProvider.select((s) => s.crystalBalance)),
            onTap: () => ref.read(shopProvider.notifier).openShop(),
            isDark: isDark,
          ),
        ],
      ),
    );
  }
}
