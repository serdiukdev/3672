import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:itd_2/core/constants/app_colors.dart';
import 'package:itd_2/core/services/app_navigator.dart';
import '../../../core/constants/app_styles.dart';
import '../../../core/constants/app_text.dart';
import '../../../core/services/storage_service.dart';
import '../../../shared/components/nav_bar.dart';
import '../../main/view/main_screen.dart';
import '../../settings/view/settings_screen.dart';
import '../bloc/shop/bloc.dart';
import '../bloc/shop/state.dart';
import '../models/shop.dart';

class ShopScreen extends StatefulWidget {
  static const routeName = 'shop';

  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  int _tab = 1;
  late final ShopBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = ShopBloc(storage: StorageService());
    _bloc.load();
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          AppTexts.shop.toUpperCase(),
          style: AppStyles.achievementTitle,
        ),
        leading: IconButton(
          onPressed: () =>
              context.pushNamedAndRemoveUntil(MainScreen.routeName),
          icon: Image.asset('assets/general_buttons/back_icon.webp'),
        ),
        actions: [
          IconButton(
            onPressed: () =>
                context.pushNamedAndRemoveUntil(SettingsScreen.routeName),
            icon: Image.asset('assets/general_buttons/setting_icon.webp'),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _tab,
        onTap: (index) {
          setState(() => _tab = index);
        },
      ),
      body: Stack(
        children: [
          Container(
            width: size.width,
            height: size.height,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/bg_in_game/bg_1.webp'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
            child: Container(color: AppColors.mainBlack.withOpacity(0.3)),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: BlocBuilder<ShopBloc, ShopState>(
                bloc: _bloc,
                builder: (context, state) {
                  if (state.loading) {
                    return Center(
                      child: Text(
                        AppTexts.loading,
                        style: AppStyles.categoryItem,
                      ),
                    );
                  }
                  return ListView(
                    children: [
                      _CoinsHeader(coins: state.coins),
                      const SizedBox(height: 16),

                      Text(
                        AppTexts.baskets,
                        style: AppStyles.statList.copyWith(fontSize: 22),
                      ),
                      const SizedBox(height: 8),
                      _ItemsGrid(
                        items: ShopCatalog.baskets,
                        ownedIds: state.ownedBaskets,
                        selectedId: state.selectedBasketId,
                        onTap: _onItemTap,
                      ),

                      const SizedBox(height: 24),

                      Text(
                        AppTexts.backs,
                        style: AppStyles.statList.copyWith(fontSize: 22),
                      ),
                      const SizedBox(height: 8),
                      _ItemsGrid(
                        items: ShopCatalog.backgrounds,
                        ownedIds: state.ownedBackgrounds,
                        selectedId: state.selectedBackgroundId,
                        onTap: _onItemTap,
                      ),
                      const SizedBox(height: 120),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onItemTap(ShopItem item, ShopState state) async {
    final owned = item.type == ShopItemType.basket
        ? state.ownedBaskets.contains(item.id)
        : state.ownedBackgrounds.contains(item.id);
    final selected =
        (item.type == ShopItemType.basket
            ? state.selectedBasketId
            : state.selectedBackgroundId) ==
        item.id;

    if (selected) return; // no interaction on selected

    if (!owned) {
      _showPurchaseDialog(item);
      return;
    }

    await _bloc.select(item);
  }

  Future<void> _showPurchaseDialog(ShopItem item) async {
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) {
        return Center(
          child: Container(
            width: 320,
            height: 420,
            decoration: BoxDecoration(
              image: const DecorationImage(
                image: AssetImage('assets/bg_components/privacy_terms_bg.webp'),
                fit: BoxFit.fill,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  item.name,
                  style: AppStyles.yellowText.copyWith(fontSize: 22),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    item.assetPath,
                    height: 180,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/general_buttons/coin.webp', height: 22),
                    const SizedBox(width: 6),
                    Text(
                      '${item.price}',
                      style: AppStyles.yellowText.copyWith(fontSize: 20),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _DialogButton(
                      label: AppTexts.cancel,
                      onTap: () => Navigator.of(ctx).pop(),
                    ),
                    _DialogButton(
                      label: AppTexts.buy,
                      onTap: () async {
                        final ok = await _bloc.purchase(item);
                        if (!ok) {
                          Fluttertoast.showToast(msg: AppTexts.notEnoughCoins);
                          return;
                        }
                        if (mounted) Navigator.of(ctx).pop();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _CoinsHeader extends StatelessWidget {
  final int coins;

  const _CoinsHeader({required this.coins});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          height: 28,
          width: 70,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/general_buttons/coin_aria_bg.webp'),
              fit: BoxFit.contain,
            ),
          ),
          child: Center(
            child: Text(
              '$coins',
              style: AppStyles.greenButtonText.copyWith(fontSize: 12),
            ),
          ),
        ),
      ],
    );
  }
}

class _ItemsGrid extends StatelessWidget {
  final List<ShopItem> items;
  final Set<String> ownedIds;
  final String? selectedId;
  final void Function(ShopItem, ShopState) onTap;

  const _ItemsGrid({
    required this.items,
    required this.ownedIds,
    required this.selectedId,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bloc = context.findAncestorStateOfType<_ShopScreenState>()!._bloc;
    final state = (bloc.state);

    return SizedBox(
      height: size.height * 0.25,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: items.length,
        itemBuilder: (ctx, i) {
          final item = items[i];
          final owned = ownedIds.contains(item.id);
          final selected = selectedId == item.id;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: _ShopItemTile(
              item: item,
              owned: owned,
              selected: selected,
              onTap: () => onTap(item, state),
            ),
          );
        },
      ),
    );
  }
}

class _ShopItemTile extends StatelessWidget {
  final ShopItem item;
  final bool owned;
  final bool selected;
  final VoidCallback onTap;

  const _ShopItemTile({
    required this.item,
    required this.owned,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.thirdText, width: 2),
        ),
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(item.assetPath, fit: BoxFit.contain),
              ),
            ),
            const SizedBox(height: 6),
            Text(item.name, style: AppStyles.yellowText.copyWith(fontSize: 14)),
            if (selected)
              Text(
                AppTexts.selected,
                style: AppStyles.yellowText.copyWith(fontSize: 16),
              )
            else if (owned)
              Text(AppTexts.owned, style: AppStyles.achievementTitle)
            else
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/general_buttons/coin.webp', height: 18),
                  const SizedBox(width: 4),
                  Text('${item.price}', style: AppStyles.achievementTitle),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _DialogButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _DialogButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 120,
        height: 44,
        decoration: BoxDecoration(
          image: const DecorationImage(
            image: AssetImage('assets/bg_components/expense_item_bg.webp'),
            fit: BoxFit.fill,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: Text(label, style: AppStyles.yellowText.copyWith(fontSize: 16)),
      ),
    );
  }
}
