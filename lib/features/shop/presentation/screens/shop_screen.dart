import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_design_system.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../settings/domain/providers/settings_provider.dart';
import '../../domain/providers/shop_provider.dart';
import '../../data/models/bundle.dart';
import '../widgets/bundle_card.dart';
import '../widgets/currency_counter.dart';

class ShopScreen extends ConsumerWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shopState = ref.watch(shopProvider);
    final shopNotifier = ref.read(shopProvider.notifier);
    final isDark = ref.watch(settingsProvider.select((s) => s.themeMode == ThemeMode.dark));

    return GestureDetector(
      onTap: () => shopNotifier.closeShop(),
      child: Container(
        color: Colors.black.withValues(alpha: 0.75),
        child: Center(
          child: GestureDetector(
            onTap: () {},
            child: Container(
              width: MediaQuery.of(context).size.width > 600 ? 480 : double.infinity,
              margin: const EdgeInsets.all(20),
              padding: EdgeInsets.all(AppDesignSystem.paddingExtraLarge),
              decoration: BoxDecoration(
                color: AppColors.getBackground(isDark),
                borderRadius: BorderRadius.circular(AppDesignSystem.radiusExtraLarge),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Shop', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: AppColors.getPrimary(isDark))),
                      IconButton(icon: const Icon(Icons.close), onPressed: () => shopNotifier.closeShop()),
                    ],
                  ),
                  SizedBox(height: AppDesignSystem.spacingMedium),
                  CurrencyCounter(amount: shopState.crystalBalance, onTap: () {}, isDark: isDark),
                  SizedBox(height: AppDesignSystem.spacingLarge),
                  Flexible(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: ShopBundles.all.length,
                      itemBuilder: (context, index) {
                        final bundle = ShopBundles.all[index];
                        return BundleCard(
                          bundle: bundle,
                          onBuy: () async {
                            final success = await shopNotifier.purchaseBundle(bundle);
                            if (success && context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Purchased ${bundle.displayName}!')));
                            }
                          },
                          isPurchased: shopState.isPurchased(bundle.id),
                          isDark: isDark,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
