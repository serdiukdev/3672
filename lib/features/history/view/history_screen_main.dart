import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:itd_2/core/services/app_navigator.dart';

import '../../../core/constants/app_styles.dart';
import '../../../core/constants/app_text.dart';
import '../../../shared/components/nav_bar.dart';
import '../../main/view/main_screen.dart';
import '../../settings/view/settings_screen.dart';
import 'history_list_screen.dart';

class HistoryMain extends StatefulWidget {
  static const routeName = 'history';

  const HistoryMain({super.key});

  @override
  State<HistoryMain> createState() => _HistoryMainState();
}

class _HistoryMainState extends State<HistoryMain> {
  int _tab = 3;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(AppTexts.history, style: AppStyles.achievementTitle),
        actions: [
          IconButton(
            onPressed: () =>
                context.pushNamedAndRemoveUntil(SettingsScreen.routeName),
            icon: Image.asset('assets/general_buttons/setting_icon.webp'),
          ),
        ],
        leading: IconButton(
          onPressed: () =>
              context.pushNamedAndRemoveUntil(MainScreen.routeName),
          icon: Image.asset('assets/general_buttons/back_icon.webp'),
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _tab,
        onTap: (index) {
          setState(() => _tab = index);
        },
      ),
      body: Container(
        width: size.width,
        height: size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bg_in_game/bg_1.webp'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {
                      context.pushNamedAndRemoveUntil(
                        HistoryListScreen.routeName,
                        arguments: 'income',
                      );
                    },
                    child: Container(
                      height: size.height * 0.4,
                      width: size.width * 0.4,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                            'assets/general_buttons/add_income.webp',
                          ),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),

                  GestureDetector(
                    onTap: () {
                      context.pushNamedAndRemoveUntil(
                        HistoryListScreen.routeName,
                        arguments: 'expense',
                      );
                    },
                    child: Container(
                      height: size.height * 0.4,
                      width: size.width * 0.4,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                            'assets/general_buttons/add_expense.webp',
                          ),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
