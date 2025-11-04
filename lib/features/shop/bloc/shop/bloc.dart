import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/services/storage_service.dart';
import 'event.dart';
import 'state.dart';
import '../../models/shop.dart';

class ShopBloc extends Cubit<ShopState> {
  static const String _kOwnedBaskets = 'owned_baskets';
  static const String _kOwnedBackgrounds = 'owned_backgrounds';
  static const String _kSelectedBasket = 'selected_basket';
  static const String _kSelectedBackground = 'selected_background';

  final StorageService storage;

  ShopBloc({required this.storage}) : super(ShopState.initial);

  Future<void> load() async {
    emit(state.copyWith(loading: true));
    final prefs = await SharedPreferences.getInstance();
    final coins = storage.getBalance();
    final ownedBaskets =
        prefs.getStringList(_kOwnedBaskets)?.toSet() ?? <String>{};
    final ownedBackgrounds =
        prefs.getStringList(_kOwnedBackgrounds)?.toSet() ?? <String>{};
    final selectedBasket = prefs.getString(_kSelectedBasket);
    final selectedBackground = prefs.getString(_kSelectedBackground);
    emit(
      ShopState(
        loading: false,
        coins: coins,
        ownedBaskets: ownedBaskets,
        ownedBackgrounds: ownedBackgrounds,
        selectedBasketId: selectedBasket,
        selectedBackgroundId: selectedBackground,
      ),
    );
  }

  Future<bool> purchase(ShopItem item) async {
    if (state.coins < item.price) {
      return false;
    }

    final prefs = await SharedPreferences.getInstance();
    int coins = state.coins - item.price;
    await storage.setBalance(coins);

    Set<String> ownedBaskets = state.ownedBaskets;
    Set<String> ownedBackgrounds = state.ownedBackgrounds;
    String? selectedBasketId = state.selectedBasketId;
    String? selectedBackgroundId = state.selectedBackgroundId;

    bool firstOfType = false;

    if (item.type == ShopItemType.basket) {
      if (!ownedBaskets.contains(item.id)) {
        firstOfType = ownedBaskets.isEmpty;
        ownedBaskets = {...ownedBaskets, item.id};
        await prefs.setStringList(_kOwnedBaskets, ownedBaskets.toList());
        if (firstOfType) {
          selectedBasketId = item.id;
          await prefs.setString(_kSelectedBasket, selectedBasketId);
          ShopEvents.emit(SelectionChanged());
        }
      }
    } else {
      if (!ownedBackgrounds.contains(item.id)) {
        firstOfType = ownedBackgrounds.isEmpty;
        ownedBackgrounds = {...ownedBackgrounds, item.id};
        await prefs.setStringList(
          _kOwnedBackgrounds,
          ownedBackgrounds.toList(),
        );
        if (firstOfType) {
          selectedBackgroundId = item.id;
          await prefs.setString(_kSelectedBackground, selectedBackgroundId);
          ShopEvents.emit(SelectionChanged());
        }
      }
    }

    emit(
      state.copyWith(
        coins: coins,
        ownedBaskets: ownedBaskets,
        ownedBackgrounds: ownedBackgrounds,
        selectedBasketId: selectedBasketId,
        selectedBackgroundId: selectedBackgroundId,
      ),
    );
    ShopEvents.emit(BalanceChanged());
    return true;
  }

  Future<void> select(ShopItem item) async {
    if (item.type == ShopItemType.basket &&
        !state.ownedBaskets.contains(item.id))
      return;
    if (item.type == ShopItemType.background &&
        !state.ownedBackgrounds.contains(item.id))
      return;

    final prefs = await SharedPreferences.getInstance();
    if (item.type == ShopItemType.basket) {
      await prefs.setString(_kSelectedBasket, item.id);
      emit(state.copyWith(selectedBasketId: item.id));
    } else {
      await prefs.setString(_kSelectedBackground, item.id);
      emit(state.copyWith(selectedBackgroundId: item.id));
    }
    ShopEvents.emit(SelectionChanged());
  }

  Future<void> addCoins(int amount) async {
    final newBalance = state.coins + amount;
    await storage.setBalance(newBalance);
    emit(state.copyWith(coins: newBalance));
    ShopEvents.emit(BalanceChanged());
  }
}
