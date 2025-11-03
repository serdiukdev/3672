import 'package:flutter/material.dart';
import 'package:itd_2/services/app_navigator.dart';

import '../view/main/main_screen.dart';
import '../view/settings/settings_screen.dart';

class AppBar extends StatelessWidget {
  const AppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed:
                () => context.pushNamedAndRemoveUntil(MainScreen.routeName),
            icon: Image.asset('assets/general_buttons/back_icon.webp'),
          ),

          IconButton(
            onPressed:
                () => context.pushNamedAndRemoveUntil(SettingsScreen.routeName),
            icon:  Image.asset('assets/general_buttons/setting_icon.webp'),
          ),


        ],
      ),
    );
  }
}
