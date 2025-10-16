/// Состояние магазина
class ShopState {
  /// Текущий баланс кристаллов
  final int crystalBalance;

  /// Список ID купленных пакетов (для no-ads)
  final List<String> purchasedBundles;

  /// Открыт ли магазин
  final bool isShopOpen;

  const ShopState({
    this.crystalBalance = 0,
    this.purchasedBundles = const [],
    this.isShopOpen = false,
  });

  /// Проверить куплен ли пакет
  bool isPurchased(String bundleId) {
    return purchasedBundles.contains(bundleId);
  }

  /// Куплен ли пакет отключения рекламы
  bool get hasNoAds => purchasedBundles.contains('bundle_6');

  /// Создать копию с изменениями
  ShopState copyWith({
    int? crystalBalance,
    List<String>? purchasedBundles,
    bool? isShopOpen,
  }) {
    return ShopState(
      crystalBalance: crystalBalance ?? this.crystalBalance,
      purchasedBundles: purchasedBundles ?? this.purchasedBundles,
      isShopOpen: isShopOpen ?? this.isShopOpen,
    );
  }
}
