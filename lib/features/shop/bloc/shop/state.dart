class ShopState {
  final bool loading;
  final int coins;
  final Set<String> ownedBaskets;
  final Set<String> ownedBackgrounds;
  final String? selectedBasketId;
  final String? selectedBackgroundId;

  const ShopState({
    required this.loading,
    required this.coins,
    required this.ownedBaskets,
    required this.ownedBackgrounds,
    required this.selectedBasketId,
    required this.selectedBackgroundId,
  });

  static const initial = ShopState(
    loading: true,
    coins: 0,
    ownedBaskets: <String>{},
    ownedBackgrounds: <String>{},
    selectedBasketId: null,
    selectedBackgroundId: null,
  );

  ShopState copyWith({
    bool? loading,
    int? coins,
    Set<String>? ownedBaskets,
    Set<String>? ownedBackgrounds,
    String? selectedBasketId,
    String? selectedBackgroundId,
  }) => ShopState(
    loading: loading ?? this.loading,
    coins: coins ?? this.coins,
    ownedBaskets: ownedBaskets ?? this.ownedBaskets,
    ownedBackgrounds: ownedBackgrounds ?? this.ownedBackgrounds,
    selectedBasketId: selectedBasketId ?? this.selectedBasketId,
    selectedBackgroundId: selectedBackgroundId ?? this.selectedBackgroundId,
  );

  @override
  String toString() =>
      'ShopState(loading: $loading, coins: $coins, ownedBaskets: $ownedBaskets, ownedBackgrounds: $ownedBackgrounds, selectedBasketId: $selectedBasketId, selectedBackgroundId: $selectedBackgroundId)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ShopState &&
        other.loading == loading &&
        other.coins == coins &&
        _setEquals(other.ownedBaskets, ownedBaskets) &&
        _setEquals(other.ownedBackgrounds, ownedBackgrounds) &&
        other.selectedBasketId == selectedBasketId &&
        other.selectedBackgroundId == selectedBackgroundId;
  }

  @override
  int get hashCode => Object.hash(
    loading,
    coins,
    ownedBaskets.length,
    ownedBackgrounds.length,
    selectedBasketId,
    selectedBackgroundId,
  );
}

bool _setEquals(Set a, Set b) => a.length == b.length && a.containsAll(b);
