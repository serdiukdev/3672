enum ShopItemType { basket, background }

class ShopItem {
  final String id;
  final String name;
  final String assetPath;
  final String? maskAssetPath;
  final int price;
  final ShopItemType type;
  const ShopItem({
    required this.id,
    required this.name,
    required this.assetPath,
    this.maskAssetPath,
    required this.price,
    required this.type,
  });
}

sealed class ShopCatalog {
  static const int basketPrice = 300;
  static const int backgroundPrice = 1250;

  static const String defaultBasketAsset = 'assets/baskets/box_default.webp';
  static const String defaultBasketMaskAsset = 'assets/baskets/box_default_mask.webp';
  static const String defaultBackgroundAsset = 'assets/bg_in_game/bg_1.webp';

  static const List<ShopItem> baskets = [
    ShopItem(
      id: 'basket_1',
      name: 'PINK',
      assetPath: 'assets/baskets/box_shop_1.webp',
      maskAssetPath: 'assets/baskets/box_shop_1_mask.webp',
      price: basketPrice,
      type: ShopItemType.basket,
    ),
    ShopItem(
      id: 'basket_2',
      name: 'GREEN',
      assetPath: 'assets/baskets/box_shop_2.webp',
      maskAssetPath: 'assets/baskets/box_shop_2_mask.webp',
      price: basketPrice,
      type: ShopItemType.basket,
    ),
    ShopItem(
      id: 'basket_3',
      name: 'BLUE',
      assetPath: 'assets/baskets/box_shop_3.webp',
      maskAssetPath: 'assets/baskets/box_shop_3_mask.webp',
      price: basketPrice,
      type: ShopItemType.basket,
    ),
    ShopItem(
      id: 'basket_4',
      name: 'VIOLET',
      assetPath: 'assets/baskets/box_shop_4.webp',
      maskAssetPath: 'assets/baskets/box_shop_4_mask.webp',
      price: basketPrice,
      type: ShopItemType.basket,
    ),
    ShopItem(
      id: 'basket_5',
      name: 'RED',
      assetPath: 'assets/baskets/box_shop_5.webp',
      maskAssetPath: 'assets/baskets/box_shop_5_mask.webp',
      price: basketPrice,
      type: ShopItemType.basket,
    ),
  ];

  static const List<ShopItem> backgrounds = [
    ShopItem(
      id: 'bg_1',
      name: 'GOLDEN RED',
      assetPath: 'assets/bg_in_shop/bg_shop_1.webp',
      price: backgroundPrice,
      type: ShopItemType.background,
    ),
    ShopItem(
      id: 'bg_2',
      name: 'MAGIC FOREST',
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
      name: 'WOODEN FIELD',
      assetPath: 'assets/bg_in_shop/bg_shop_4.webp',
      price: backgroundPrice,
      type: ShopItemType.background,
    ),
    ShopItem(
      id: 'bg_5',
      name: 'SUNNY BLUE',
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
        maskAssetPath: defaultBasketMaskAsset,
        price: 0,
        type: ShopItemType.basket,
      ),
    );
  }
}
