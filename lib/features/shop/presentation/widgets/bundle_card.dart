import 'package:flutter/material.dart';
import '../../../../core/theme/app_design_system.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/bundle.dart';

class BundleCard extends StatelessWidget {
  final Bundle bundle;
  final VoidCallback onBuy;
  final bool isPurchased;
  final bool isDark;

  const BundleCard({
    super.key,
    required this.bundle,
    required this.onBuy,
    this.isPurchased = false,
    required this.isDark,
  });

  String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: AppDesignSystem.spacingMedium),
      padding: EdgeInsets.all(AppDesignSystem.paddingLarge),
      decoration: BoxDecoration(
        color: AppColors.getSurface(isDark),
        borderRadius: BorderRadius.circular(AppDesignSystem.radiusLarge),
        boxShadow: AppDesignSystem.mediumShadow,
      ),
      child: Row(
        children: [
          Icon(
            bundle.type == BundleType.crystals ? Icons.diamond_rounded : Icons.block_rounded,
            size: 40,
            color: const Color(0xFFAA96DA),
          ),
          SizedBox(width: AppDesignSystem.spacingMedium),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(bundle.displayName, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppColors.getPrimary(isDark))),
                if (bundle.crystalAmount != null)
                  Text(_formatNumber(bundle.crystalAmount!), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFFAA96DA))),
              ],
            ),
          ),
          if (isPurchased && bundle.type == BundleType.noAds)
            const Icon(Icons.check_circle, color: Colors.green, size: 32)
          else
            ElevatedButton(
              onPressed: onBuy,
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF8BB4EB)),
              child: Text('\$${bundle.priceUSD.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.w900)),
            ),
        ],
      ),
    );
  }
}
