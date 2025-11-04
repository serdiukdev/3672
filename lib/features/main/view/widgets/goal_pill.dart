import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_styles.dart';

class GoalPill extends StatelessWidget {
  final String title;
  final String amount;
  final VoidCallback onTap;

  const GoalPill({
    super.key,
    required this.title,
    required this.amount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            color: AppColors.mainBlack.withOpacity(0.25),
            child: Text(
              title,
              style: AppStyles.yellowText.copyWith(fontSize: 13),
            ),
          ),

          const SizedBox(height: 8),
          Stack(
            alignment: Alignment.centerLeft,
            children: [
              Image.asset(
                'assets/general_buttons/onboarding_button.webp',
                width: size.width * 0.42,
                fit: BoxFit.contain,
              ),
              Row(
                children: [
                  const SizedBox(width: 16),
                  Image.asset(
                    'assets/general_buttons/coin.webp',
                    width: 24,
                    height: 24,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    amount.isEmpty ? '0' : amount,
                    style: AppStyles.categoryItem,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
