import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppStyles {
  // Text styles
  static final titleMainText = GoogleFonts.knewave(
    fontSize: 36,
    fontWeight: FontWeight.w400,
    color: AppColors.mainWhite,
    shadows: [
      Shadow(offset: Offset(2, 2), color: AppColors.mainBlack, blurRadius: 4),
    ],
  );

  static final onboardingMainText = GoogleFonts.knewave(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    color: AppColors.mainWhite,
    shadows: [
      Shadow(offset: Offset(2, 2), color: AppColors.mainBlack, blurRadius: 4),
    ],
  );

  static final onboardingNavButton = GoogleFonts.knewave(
    fontSize: 43,
    fontWeight: FontWeight.w400,
    color: AppColors.mainWhite,
    shadows: [
      Shadow(offset: Offset(2, 2), color: AppColors.mainBlack, blurRadius: 4),
    ],
  );

  static final greenButtonText = GoogleFonts.knewave(
    fontSize: 32,
    fontWeight: FontWeight.w400,
    color: AppColors.secondText,
    shadows: [
      Shadow(offset: Offset(2, 2), color: AppColors.mainBlack, blurRadius: 4),
    ],
  );

  static final yellowText = GoogleFonts.knewave(
    fontSize: 20,
    fontWeight: FontWeight.w400,
    color: AppColors.secondText,
    shadows: [
      Shadow(offset: Offset(2, 2), color: AppColors.mainBlack, blurRadius: 4),
    ],
  );

  static final categoryItem = GoogleFonts.knewave(
    fontSize: 22,
    fontWeight: FontWeight.normal,
    color: AppColors.mainWhite,
    shadows: [
      Shadow(offset: Offset(2, 2), color: AppColors.mainBlack, blurRadius: 4),
    ],
  );

  static final addCostCard = GoogleFonts.laila(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    color: AppColors.mainWhite,
  );

  static final addNoteCard = GoogleFonts.laila(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.mainWhite,
  );

  static final achievementTitle = GoogleFonts.knewave(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    color: AppColors.mainWhite,
    shadows: [
      Shadow(offset: Offset(2, 2), color: AppColors.mainBlack, blurRadius: 4),
    ],
  );

  static final achievementDescription = GoogleFonts.laila(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.mainWhite,
  );

  static final chartDescription = GoogleFonts.laila(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.mainWhite,
    shadows: [
      Shadow(offset: Offset(1, 1), color: AppColors.mainBlack, blurRadius: 4),
    ],
  );

  static final statList = GoogleFonts.laila(
    fontSize: 18,
    fontWeight: FontWeight.w800,
    color: AppColors.mainWhite,
  );

  static final statListBlue = GoogleFonts.laila(
    fontSize: 18,
    fontWeight: FontWeight.w800,
    color: AppColors.mainBLue,
  );
}
