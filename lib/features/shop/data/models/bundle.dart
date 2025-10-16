/// Модель пакета покупки в магазине
class Bundle {
  final String id;
  final BundleType type;
  final int? crystalAmount; // null для no-ads пакета
  final double priceUSD;
  final String? badge; // "Popular", "Best Value", null

  const Bundle({
    required this.id,
    required this.type,
    this.crystalAmount,
    required this.priceUSD,
    this.badge,
  });

  /// Название пакета для отображения
  String get displayName {
    switch (type) {
      case BundleType.crystals:
        return '$crystalAmount Crystals';
      case BundleType.noAds:
        return 'Remove Ads';
    }
  }

  /// Описание пакета
  String get description {
    switch (type) {
      case BundleType.crystals:
        return 'Get $crystalAmount purple crystals';
      case BundleType.noAds:
        return 'Remove all ads forever';
    }
  }
}

/// Тип пакета
enum BundleType {
  crystals,
  noAds,
}

/// Предустановленные пакеты магазина
class ShopBundles {
  static const List<Bundle> all = [
    Bundle(
      id: 'bundle_1',
      type: BundleType.crystals,
      crystalAmount: 650,
      priceUSD: 1.99,
      badge: null,
    ),
    Bundle(
      id: 'bundle_2',
      type: BundleType.crystals,
      crystalAmount: 2650,
      priceUSD: 9.99,
      badge: 'Popular',
    ),
    Bundle(
      id: 'bundle_3',
      type: BundleType.crystals,
      crystalAmount: 3400,
      priceUSD: 11.99,
      badge: null,
    ),
    Bundle(
      id: 'bundle_4',
      type: BundleType.crystals,
      crystalAmount: 7000,
      priceUSD: 22.99,
      badge: 'Best Value',
    ),
    Bundle(
      id: 'bundle_5',
      type: BundleType.crystals,
      crystalAmount: 9000,
      priceUSD: 29.99,
      badge: null,
    ),
    Bundle(
      id: 'bundle_6',
      type: BundleType.noAds,
      crystalAmount: null,
      priceUSD: 1.99,
      badge: null,
    ),
  ];
}
