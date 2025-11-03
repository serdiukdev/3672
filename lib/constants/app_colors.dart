import 'dart:ui';

import 'package:flutter/material.dart';

class AppColors {
  const AppColors._();

  static const mainWhite =  Color(0xFFFFFFFF);
  static const secondText =  Color(0xFFF3FF9E);
  static const thirdText =  Color(0xFFFFF053);

  static const mainGreen =  Color(0xE51A7700); //90%
  static const mainBlack =  Color (0xFF000000);
  static const mainBLue = Color (0xFF09CED7);

  static const secondItemBg =  Color (0x80FFFF61); //50%
  static const topBlueBg = Color(0xCC09CED7);  //80%
  static const topOrangeBG = Color(0xCCFD911E); //80%
  static const bottomNavBg = Color(0xB2B20500);  //70%
  static const bottomNavBorder = Color(0xFFFFAC01);
  static const progressBorder = Color(0xFFFE9F06);
  static const chartBorder = Color(0xFFDC5100);
  static const popupYellowText = Color(0xFFFFCD00);
  static const yellowBorder = Color (0xFF);

  static const goldenYellow =  Color(0xFFFFD700);

  static const LinearGradient loader = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color(0xFFFFFFFF),
      Color(0xFFF29517),
    ],
  );

  static const LinearGradient achievement = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color(0xFFF29517),
      Color(0xFFFFF053),
    ],
  );
}