import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/models/shop_state.dart';
import '../../data/models/bundle.dart';

/// Provider для управления магазином
final shopProvider = StateNotifierProvider<ShopNotifier, ShopState>((ref) {
  return ShopNotifier();
});

/// Notifier для управления магазином
class ShopNotifier extends StateNotifier<ShopState> {
  ShopNotifier() : super(const ShopState()) {
    _loadFromPrefs();
  }

  /// Загрузить состояние из SharedPreferences
  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();

    final balance = prefs.getInt('crystal_balance') ?? 1000; // Стартовый баланс 1000
    final purchased = prefs.getStringList('purchased_bundles') ?? [];

    state = state.copyWith(
      crystalBalance: balance,
      purchasedBundles: purchased,
    );

    debugPrint('Shop: Loaded balance=$balance, purchased=${purchased.length}');
  }

  /// Сохранить состояние в SharedPreferences
  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt('crystal_balance', state.crystalBalance);
    await prefs.setStringList('purchased_bundles', state.purchasedBundles);

    debugPrint('Shop: Saved balance=${state.crystalBalance}');
  }

  /// Открыть магазин
  void openShop() {
    state = state.copyWith(isShopOpen: true);
    debugPrint('Shop: Opened');
  }

  /// Закрыть магазин
  void closeShop() {
    state = state.copyWith(isShopOpen: false);
    debugPrint('Shop: Closed');
  }

  /// Купить пакет
  Future<bool> purchaseBundle(Bundle bundle) async {
    // Проверка что пакет no-ads еще не куплен
    if (bundle.type == BundleType.noAds && state.isPurchased(bundle.id)) {
      debugPrint('Shop: No-ads already purchased');
      return false;
    }

    // Симуляция покупки (в реальном приложении здесь будет платёжная система)
    debugPrint('Shop: Purchase ${bundle.id} for \$${bundle.priceUSD}');

    // Добавить кристаллы или no-ads
    if (bundle.type == BundleType.crystals && bundle.crystalAmount != null) {
      final newBalance = state.crystalBalance + bundle.crystalAmount!;
      state = state.copyWith(crystalBalance: newBalance);
      debugPrint('Shop: Added ${bundle.crystalAmount} crystals, new balance=$newBalance');
    } else if (bundle.type == BundleType.noAds) {
      final newPurchased = [...state.purchasedBundles, bundle.id];
      state = state.copyWith(purchasedBundles: newPurchased);
      debugPrint('Shop: No-ads purchased');
    }

    // Сохранить
    await _saveToPrefs();

    return true;
  }

  /// Потратить кристаллы (для будущего функционала)
  Future<bool> spendCrystals(int amount) async {
    if (state.crystalBalance < amount) {
      debugPrint('Shop: Not enough crystals (have ${state.crystalBalance}, need $amount)');
      return false;
    }

    final newBalance = state.crystalBalance - amount;
    state = state.copyWith(crystalBalance: newBalance);
    await _saveToPrefs();

    debugPrint('Shop: Spent $amount crystals, new balance=$newBalance');
    return true;
  }
}
