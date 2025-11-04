import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_styles.dart';
import '../../../core/constants/app_text.dart';
import '../bloc/onboarding/bloc.dart';
import '../bloc/onboarding/event.dart';
import 'onboarding_quiz.dart';

class PreOnboardingScreen extends StatelessWidget {
  static const routeName = '/preonboarding';

  const PreOnboardingScreen({super.key});

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
          Align(
            alignment: const Alignment(0, -0.15),
            child: Container(
              height: 350,
              margin: const EdgeInsets.symmetric(horizontal: 34),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    'assets/bg_components/onboarding_item_bg.webp',
                  ),
                ),
              ),
              child: Center(
                child: Text(
                  AppTexts.preOnboardingTitle,
                  textAlign: TextAlign.center,
                  style: AppStyles.onboardingMainText,
                ),
              ),
            ),
          ),
          Align(
            alignment: const Alignment(0, 0.5),
            child: GestureDetector(
              onTap: () {
                context.read<OnboardingBloc>().add(StartQuiz());
                Navigator.of(context).pushNamed(OnboardingQuiz.routeName);
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    'assets/general_buttons/onboarding_button.webp',
                    width: size.width * 0.65,
                  ),
                  Text(AppTexts.start, style: AppStyles.onboardingNavButton),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
