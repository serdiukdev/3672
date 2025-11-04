import 'package:flutter/material.dart';
import 'package:itd_2/core/services/app_navigator.dart';

import '../../features/achievements/view/achievemets_screen.dart';
import '../../features/add/view/add_screen.dart';
import '../../features/history/view/history_screen_main.dart';
import '../../features/shop/view/shop_screen.dart';
import '../../features/statistic/view/statistic_screen.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height * 0.13,
      width: size.width,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/nav_bar/nav_bar_bg.webp',
              fit: BoxFit.fill,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _NavIcon(
                  asset: 'assets/nav_bar/nav_bar_achievement.webp',
                  selected: currentIndex == 0,
                  onTap: () {
                    onTap(0);
                    context.pushNamedAndRemoveUntil(
                      AchievementsScreen.routeName,
                    );
                  },
                ),
                _NavIcon(
                  asset: 'assets/nav_bar/nav_bar_shop.webp',
                  selected: currentIndex == 1,
                  onTap: () {
                    onTap(1);
                    context.pushNamedAndRemoveUntil(ShopScreen.routeName);
                  },
                ),
                GestureDetector(
                  onTap: () {
                    onTap(2);
                    context.pushNamedAndRemoveUntil(AddScreen.routeName);
                  },
                  child: Image.asset(
                    'assets/nav_bar/nav_bar_add.webp',
                    height: 80,
                    fit: BoxFit.contain,
                  ),
                ),
                _NavIcon(
                  asset: 'assets/nav_bar/nav_bar_history.webp',
                  selected: currentIndex == 3,
                  onTap: () {
                    onTap(3);
                    context.pushNamedAndRemoveUntil(HistoryMain.routeName);
                  },
                ),
                _NavIcon(
                  asset: 'assets/nav_bar/nav_bar_statistic.webp',
                  selected: currentIndex == 4,
                  onTap: () {
                    onTap(4);
                    context.pushNamedAndRemoveUntil(StatisticScreen.routeName);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NavIcon extends StatelessWidget {
  final String asset;
  final bool selected;
  final VoidCallback onTap;

  const _NavIcon({
    required this.asset,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Opacity(
        opacity: selected ? 1.0 : 0.75,
        child: Image.asset(asset, height: 60, fit: BoxFit.contain),
      ),
    );
  }
}
