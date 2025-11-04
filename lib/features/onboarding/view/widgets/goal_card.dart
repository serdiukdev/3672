import 'package:flutter/material.dart';
import 'package:itd_2/core/constants/app_text.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_styles.dart';

class GoalCard extends StatefulWidget {
  final String title;
  final String? value; // numeric as string
  final bool editing;
  final VoidCallback onTapTitle;
  final ValueChanged<String> onChanged;

  const GoalCard({
    required this.title,
    required this.value,
    required this.editing,
    required this.onTapTitle,
    required this.onChanged,
    Key? key,
  }) : super(key: key);

  @override
  State<GoalCard> createState() => _GoalCardState();
}

class _GoalCardState extends State<GoalCard> {
  late TextEditingController _controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value ?? '');
    _focusNode = FocusNode();

    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        widget.onChanged(_controller.text);
      }
    });
  }

  @override
  void didUpdateWidget(covariant GoalCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      _controller.text = widget.value ?? '';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
      child: Container(
        width: size.width * 0.95,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        decoration: BoxDecoration(
          image: const DecorationImage(
            image: AssetImage('assets/bg_components/after_onboarding_bg.webp'),
          ),
        ),
        child: GestureDetector(
          onTap: widget.onTapTitle,
          child: Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(widget.title, style: AppStyles.onboardingMainText),
                const SizedBox(height: 10),
                if (widget.editing)
                  Column(
                    children: [
                      SizedBox(
                        width: size.width * 0.55,
                        child: TextField(
                          controller: _controller,
                          focusNode: _focusNode,
                          autofocus: true,
                          textAlign: TextAlign.center,
                          keyboardType: const TextInputType.numberWithOptions(
                            signed: false,
                            decimal: false,
                          ),
                          maxLength: 6,
                          decoration: InputDecoration(
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
                            counterText: '',
                          ),
                          onChanged: widget.onChanged,
                        ),
                      ),
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: () {
                          FocusScope.of(context).unfocus();
                          widget.onChanged(_controller.text);
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Image.asset(
                              'assets/general_buttons/onboarding_button.webp',
                              width: size.width * 0.35,
                            ),
                            Text(
                              AppTexts.save,
                              style: AppStyles.onboardingNavButton,
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                else
                  GestureDetector(
                    onTap: widget.onTapTitle,
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
                        widget.value == null || widget.value!.isEmpty
                            ? AppTexts.yourGoal
                            : widget.value!,
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
