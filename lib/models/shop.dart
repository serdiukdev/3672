enum ShopItemType { basket, background }

class ShopItem {
  final String id;
  final String name;
  final String assetPath;
  final int price;
  final ShopItemType type;
  const ShopItem({
    required this.id,
    required this.name,
    required this.assetPath,
    required this.price,
    required this.type,
  });
}

sealed class ShopCatalog {
  static const int basketPrice = 300;
  static const int backgroundPrice = 1250;

  static const String defaultBasketAsset = 'assets/baskets/defoult_bascket.webp';
  static const String defaultBackgroundAsset = 'assets/bg_in_game/bg_1.webp';

  static const List<ShopItem> baskets = [
    ShopItem(
      id: 'basket_1',
      name: 'White',
      assetPath: 'assets/baskets/basket_shop_1.webp',
      price: basketPrice,
      type: ShopItemType.basket,
    ),
    ShopItem(
      id: 'basket_2',
      name: 'Green',
      assetPath: 'assets/baskets/basket_shop_2.webp',
      price: basketPrice,
      type: ShopItemType.basket,
    ),
    ShopItem(
      id: 'basket_3',
      name: 'Blue',
      assetPath: 'assets/baskets/basket_shop_3.webp',
      price: basketPrice,
      type: ShopItemType.basket,
    ),
    ShopItem(
      id: 'basket_4',
      name: 'Red',
      assetPath: 'assets/baskets/basket_shop_4.webp',
      price: basketPrice,
      type: ShopItemType.basket,
    ),
    ShopItem(
      id: 'basket_5',
      name: 'Black',
      assetPath: 'assets/baskets/basket_shop_5.webp',
      price: basketPrice,
      type: ShopItemType.basket,
    ),
  ];

  static const List<ShopItem> backgrounds = [
    ShopItem(
      id: 'bg_1',
      name: 'SUNNY VIEW',
      assetPath: 'assets/bg_in_shop/bg_shop_1.webp',
      price: backgroundPrice,
      type: ShopItemType.background,
    ),
    ShopItem(
      id: 'bg_2',
      name: 'SUNNY FIELD',
      assetPath: 'assets/bg_in_shop/bg_shop_2.webp',
      price: backgroundPrice,
      type: ShopItemType.background,
    ),
    ShopItem(
      id: 'bg_3',
      name: 'LUCKY RAINBOW',
      assetPath: 'assets/bg_in_shop/bg_shop_3.webp',
      price: backgroundPrice,
      type: ShopItemType.background,
    ),
    ShopItem(
      id: 'bg_4',
      name: 'MAGIC WINTER',
      assetPath: 'assets/bg_in_shop/bg_shop_4.webp',
      price: backgroundPrice,
      type: ShopItemType.background,
    ),
    ShopItem(
      id: 'bg_5',
      name: 'GOLD AUTUMN',
      assetPath: 'assets/bg_in_shop/bg_shop_5.webp',
      price: backgroundPrice,
      type: ShopItemType.background,
    ),
  ];

  static ShopItem? byId(String id) {
    return [...baskets, ...backgrounds].firstWhere(
      (e) => e.id == id,
      orElse: () => const ShopItem(
        id: 'unknown',
        name: 'Unknown',
        assetPath: defaultBasketAsset,
        price: 0,
        type: ShopItemType.basket,
      ),
    );
  }
}
