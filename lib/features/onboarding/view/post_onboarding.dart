import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_styles.dart';
import '../../../core/constants/app_text.dart';
import '../../main/view/main_screen.dart';
import '../bloc/onboarding/bloc.dart';
import '../bloc/onboarding/event.dart';
import '../bloc/onboarding/state.dart';

class PostOnboardingScreen extends StatefulWidget {
  static const routeName = '/post_onboarding';

  const PostOnboardingScreen({super.key});

  @override
  State<PostOnboardingScreen> createState() => _PostOnboardingScreenState();
}

class _PostOnboardingScreenState extends State<PostOnboardingScreen> {
  final _scroll = ScrollController();
  final _savingKey = GlobalKey();
  final _limitKey = GlobalKey();
  final _savingFocus = FocusNode();
  final _limitFocus = FocusNode();
  final _savingCtrl = TextEditingController();
  final _limitCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _savingFocus.addListener(() {
      if (_savingFocus.hasFocus) _ensureVisible(_savingKey);
    });
    _limitFocus.addListener(() {
      if (_limitFocus.hasFocus) _ensureVisible(_limitKey);
    });
  }

  @override
  void dispose() {
    _scroll.dispose();
    _savingFocus.dispose();
    _limitFocus.dispose();
    _savingCtrl.dispose();
    _limitCtrl.dispose();
    super.dispose();
  }

  void _ensureVisible(GlobalKey key) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctx = key.currentContext;
      if (ctx != null) {
        Scrollable.ensureVisible(
          ctx,
          duration: const Duration(milliseconds: 250),
          alignment: 0.3,
        );
      }
    });
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
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: Container(color: AppColors.mainBlack.withOpacity(0.25)),
          ),
          SafeArea(
            child: BlocBuilder<OnboardingBloc, OnboardingState>(
              builder: (context, state) {
                final s = state is PostOnboardingState
                    ? state
                    : PostOnboardingState();
                // keep controllers in sync with state
                final savingText = s.goalAmount ?? '';
                final limitText = s.limitAmount ?? '';
                if (_savingCtrl.text != savingText) {
                  _savingCtrl.text = savingText;
                  _savingCtrl.selection = TextSelection.collapsed(
                    offset: _savingCtrl.text.length,
                  );
                }
                if (_limitCtrl.text != limitText) {
                  _limitCtrl.text = limitText;
                  _limitCtrl.selection = TextSelection.collapsed(
                    offset: _limitCtrl.text.length,
                  );
                }
                // focus requested field and ensure visible
                if (s.goalType == GoalType.saving && !_savingFocus.hasFocus) {
                  _savingFocus.requestFocus();
                  _ensureVisible(_savingKey);
                } else if (s.goalType == GoalType.limit &&
                    !_limitFocus.hasFocus) {
                  _limitFocus.requestFocus();
                  _ensureVisible(_limitKey);
                }

                final saved = s.saved;
                final bottomInset = MediaQuery.of(context).viewInsets.bottom;

                return GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () => FocusScope.of(context).unfocus(),
                  child: SingleChildScrollView(
                    controller: _scroll,
                    padding: EdgeInsets.only(bottom: bottomInset + 24),
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    child: Column(
                      children: [
                        const SizedBox(height: 24),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32),
                          child: Text(
                            saved
                                ? AppTexts.postOnboardingTitle1
                                : AppTexts.postOnboardingTitle2,
                            textAlign: TextAlign.center,
                            style: AppStyles.yellowText.copyWith(fontSize: 20),
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 180,
                          child: KeyedSubtree(
                            key: _savingKey,
                            child: _GoalCard(
                              title: AppTexts.savingGoal,
                              controller: _savingCtrl,
                              focusNode: _savingFocus,
                              editing: s.goalType == GoalType.saving && !saved,
                              onTapTitle: () => context
                                  .read<OnboardingBloc>()
                                  .add(UpdateGoalType(GoalType.saving)),
                              onChanged: (v) => context
                                  .read<OnboardingBloc>()
                                  .add(UpdateGoalAmount(v)),
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),
                        SizedBox(
                          height: 180,
                          child: KeyedSubtree(
                            key: _limitKey,
                            child: _GoalCard(
                              title: AppTexts.spendingLimit,
                              controller: _limitCtrl,
                              focusNode: _limitFocus,
                              editing: s.goalType == GoalType.limit && !saved,
                              onTapTitle: () => context
                                  .read<OnboardingBloc>()
                                  .add(UpdateGoalType(GoalType.limit)),
                              onChanged: (v) => context
                                  .read<OnboardingBloc>()
                                  .add(UpdateLimitAmount(v)),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        if (!saved)
                          GestureDetector(
                            onTap: () {
                              context.read<OnboardingBloc>().add(SaveGoal());
                              FocusScope.of(context).unfocus();
                            },
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Image.asset(
                                  'assets/general_buttons/onboarding_button.webp',
                                  width: size.width * 0.5,
                                ),
                                Text(
                                  AppTexts.save,
                                  style: AppStyles.onboardingNavButton,
                                ),
                              ],
                            ),
                          )
                        else
                          GestureDetector(
                            onTap: () =>
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                  MainScreen.routeName,
                                  (route) => false,
                                ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Image.asset(
                                  'assets/general_buttons/onboarding_button.webp',
                                  width: size.width * 0.6,
                                ),
                                Text(
                                  AppTexts.main,
                                  style: AppStyles.onboardingNavButton,
                                ),
                              ],
                            ),
                          ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _GoalCard extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool editing;
  final VoidCallback onTapTitle;
  final ValueChanged<String> onChanged;

  const _GoalCard({
    required this.title,
    required this.controller,
    required this.focusNode,
    required this.editing,
    required this.onTapTitle,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
      child: Container(
        width: size.width * 0.95,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bg_components/after_onboarding_bg.webp'),
          ),
        ),
        child: GestureDetector(
          onTap: onTapTitle,
          child: Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(title, style: AppStyles.onboardingMainText),

                const SizedBox(height: 10),
                if (editing)
                  SizedBox(
                    width: size.width * 0.55,
                    child: TextField(
                      controller: controller,
                      focusNode: focusNode,
                      autofocus: true,
                      maxLength: 6,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      style: AppStyles.statList,
                      decoration: InputDecoration(
                        counterText: '',
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 12,
                        ),
                        filled: true,
                        fillColor: AppColors.secondItemBg,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged: onChanged,
                    ),
                  )
                else
                  GestureDetector(
                    onTap: onTapTitle,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.secondItemBg,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        controller.text.isEmpty
                            ? AppTexts.yourGoal
                            : controller.text,
                        style: AppStyles.onboardingMainText,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
