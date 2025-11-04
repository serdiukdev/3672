import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:itd_2/core/services/app_navigator.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_styles.dart';
import '../../bloc/daily_bonus/bloc.dart';
import '../../bloc/daily_bonus/event.dart';
import '../../bloc/daily_bonus/state.dart';
import '../main_screen.dart';

class DailyBonusScreen extends StatefulWidget {
  static const routeName = '/daily_bonus';

  const DailyBonusScreen({super.key});

  @override
  State<DailyBonusScreen> createState() => _DailyBonusScreenState();
}

class _DailyBonusScreenState extends State<DailyBonusScreen> {
  @override
  void initState() {
    super.initState();
    context.read<DailyBonusBloc>().add(DailyBonusStarted());
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset(
              'assets/bg_in_game/bg_1.webp',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: BlocBuilder<DailyBonusBloc, DailyBonusState>(
              builder: (context, state) {
                if (state.loading) {
                  return const SizedBox.expand();
                }
                final proverb = state.proverb ?? const {};
                final title = proverb['title'] as String? ?? '';
                final tip = proverb['tip'] as String? ?? '';
                return Column(
                  children: [
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _RoundButton(
                            icon: 'assets/general_buttons/back_arrow.webp',
                            onTap: () => context.pushNamedAndRemoveUntil(
                              MainScreen.routeName,
                            ),
                          ),
                          Container(
                            height: 30,
                            width: 100,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(
                                  'assets/general_buttons/coin_aria_bg.webp',
                                ),
                                fit: BoxFit.fill,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                state.balance.toString(),
                                style: AppStyles.statList.copyWith(
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Proverb card
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18.0),
                      child: Container(
                        width: size.width * 0.8,
                        height: size.height * 0.3,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 18,
                        ),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                              'assets/bg_components/daily_bonus_bg.webp',
                            ),
                            fit: BoxFit.contain,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              title.toUpperCase(),
                              textAlign: TextAlign.center,
                              style: AppStyles.onboardingMainText,
                            ),
                            SizedBox(height: 5),
                            Text(
                              tip,
                              textAlign: TextAlign.center,
                              style: AppStyles.onboardingMainText,
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Coin affixes
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [_PlusBadge(value: state.reward)],
                      ),
                    ),

                    const Spacer(),

                    // Character image
                    Image.asset(
                      'assets/bg_in_game/character.webp',
                      height: size.height * 0.43,
                      fit: BoxFit.contain,
                    ),

                    const SizedBox(height: 12),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _PlusBadge extends StatelessWidget {
  final int value;

  const _PlusBadge({required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.mainBlack.withOpacity(0.15),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text('+$value', style: AppStyles.yellowText),
    );
  }
}

class _RoundButton extends StatelessWidget {
  final String icon;
  final VoidCallback onTap;

  const _RoundButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/general_buttons/back_icon.webp'),
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
