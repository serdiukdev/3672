import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:itd_2/services/app_navigator.dart';
import 'package:itd_2/view/add/expense/choose_category_expense.dart';
import 'package:itd_2/view/add/income/choose_category_income.dart';
import 'package:itd_2/view/main/main_screen.dart';
import 'package:itd_2/view/settings/settings_screen.dart';

import '../../general_components/nav_bar.dart';

class AddScreen extends StatefulWidget {
  static const routeName = 'add';

  const AddScreen({super.key});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  int _tab = 2;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed:
                () => context.pushNamedAndRemoveUntil(SettingsScreen.routeName),
            icon: Image.asset('assets/general_buttons/setting_icon.webp'),
          ),
        ],
        leading: IconButton(
          onPressed:
              () => context.pushNamedAndRemoveUntil(MainScreen.routeName),
          icon: Image.asset('assets/general_buttons/back_icon.webp'),
        ),
      ),
      bottomNavigationBar: GameNavBar(
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
                        ChooseCategoryIncome.routeName,
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
                        ChooseCategoryExpense.routeName,
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
