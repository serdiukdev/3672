import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_styles.dart';
import '../../../core/constants/app_text.dart';
import '../bloc/onboarding/bloc.dart';
import '../bloc/onboarding/event.dart';
import '../bloc/onboarding/state.dart';
import 'post_onboarding.dart';

class OnboardingQuiz extends StatelessWidget {
  static const routeName = '/onboarding_quiz';

  const OnboardingQuiz({super.key});

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
          BlocListener<OnboardingBloc, OnboardingState>(
            listener: (context, state) {
              if (state is PostOnboardingState) {
                Navigator.of(
                  context,
                ).pushReplacementNamed(PostOnboardingScreen.routeName);
              }
            },
            child: BlocBuilder<OnboardingBloc, OnboardingState>(
              builder: (context, state) {
                if (state is QuizQuestionState) {
                  final q = state.question;
                  final List answers = q['answers'] as List;
                  return Column(mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: size.height * 0.1),
                      Expanded(
                        child: Center(
                          child: Container(
                            height: size.height * 0.3,
                            margin: const EdgeInsets.symmetric(horizontal: 34),
                            padding: const EdgeInsets.all(26),
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(
                                  'assets/bg_components/onboarding_item_bg.webp',
                                ),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                q['chickenQuestion'] as String,
                                textAlign: TextAlign.center,
                                style: AppStyles.onboardingMainText,
                              ),
                            ),
                          ),
                        ),
                      ),
                      ...answers.map((a) {
                        final id = a['id'] as String;
                        final selected = state.selectedId == id;
                        return _AnswerOption(
                          label: '${id}.  ${a['text']}',
                          selected: selected,
                          onTap: () => context.read<OnboardingBloc>().add(
                            SelectAnswer(index: state.index, selectedId: id),
                          ),
                        );
                      }),
                      const SizedBox(height: 12),
                      _ProgressDots(current: state.index, total: 5),
                      const SizedBox(height: 24),
                    ],
                  );
                }
                if (state is QuizAnswerState) {
                  final q = state.question;
                  final a =
                      (q['answers'] as List).firstWhere(
                            (e) => e['id'] == state.selectedId,
                          )
                          as Map;
                  return Column(
                    children: [
                      const SizedBox(height: 40),
                      Expanded(
                        child: Center(
                          child: Container(
                            height: size.height * 0.3,
                            margin: const EdgeInsets.symmetric(horizontal: 34),
                            padding: const EdgeInsets.all(26),
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(
                                  'assets/bg_components/onboarding_item_bg.webp',
                                ),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                a['chickenReply'] as String,
                                textAlign: TextAlign.center,
                                style: AppStyles.onboardingMainText,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Image.asset(
                        'assets/bg_in_game/character.webp',
                        height: size.height * 0.35,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 12),
                      GestureDetector(
                        onTap: () {
                          context.read<OnboardingBloc>().add(NextQuestion());
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Image.asset(
                              'assets/general_buttons/onboarding_button.webp',
                              width: size.width * 0.65,
                            ),
                            Text(
                              AppTexts.next,
                              style: AppStyles.onboardingNavButton,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _AnswerOption extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _AnswerOption({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                selected
                    ? 'assets/bg_components/quiz_item_active.webp'
                    : 'assets/bg_components/quiz_item.webp',
              ),
              fit: BoxFit.fill
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 14.0),
            child: Text(
              label,
              style: selected
                  ? AppStyles.addNoteCard.copyWith(color: AppColors.thirdText)
                  : AppStyles.addNoteCard,
            ),
          ),
        ),
      ),
    );
  }
}

class _ProgressDots extends StatelessWidget {
  final int current;
  final int total;

  const _ProgressDots({required this.current, required this.total});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(total, (i) {
        final active = i <= current;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3),
          child: Image.asset(
            active
                ? 'assets/general_buttons/progress_item_active.webp'
                : 'assets/general_buttons/progress_item.webp',
            width: 14,
            height: 14,
            fit: BoxFit.contain,
          ),
        );
      }),
    );
  }
}
