import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_styles.dart';
import '../../../../core/constants/app_text.dart';
import '../../../../core/services/storage_service.dart';
import '../../../onboarding/view/pre_onboarding_screen.dart';
import '../../../achievements/repository/achievement_service.dart';
import '../main_screen.dart';

class LoadingScreen extends StatefulWidget {
  static const routeName = '/';

  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2))
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed && mounted) {
              final first = StorageService().isFirstOpening();
              final nextRoute = first
                  ? PreOnboardingScreen.routeName
                  : MainScreen.routeName;
              Navigator.of(context).pushReplacementNamed(nextRoute);
            }
          })
          ..addListener(() => setState(() {}))
          ..forward();

    Future.microtask(
      () => AchievementService.updateLoginStreakForToday(StorageService()),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final progress = _controller.value; // 0..1

    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: size.width,
            height: size.height,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/bg_in_game/bg_1.webp'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Container(
              width: size.width * 0.8,
              height: size.height * 0.6,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/bg_in_game/character.webp'),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 80,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(AppTexts.loading, style: AppStyles.titleMainText),
                const SizedBox(height: 12),
                _GradientProgressBar(
                  width: size.width * 0.7,
                  height: 32,
                  value: progress,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GradientProgressBar extends StatelessWidget {
  final double value; // 0..1
  final double width;
  final double height;

  const _GradientProgressBar({
    required this.value,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    final trackRadius = BorderRadius.circular(height / 2);
    final fillWidth = (width - 4) * value; // padding accounted

    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: AppColors.mainBlack.withOpacity(0.25),
        borderRadius: trackRadius,
        border: Border.all(
          color: AppColors.mainWhite.withOpacity(0.6),
          width: 2,
        ),
      ),
      child: ClipRRect(
        borderRadius: trackRadius,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Container(
            width: fillWidth.clamp(0.0, width),
            height: double.infinity,
            decoration: const BoxDecoration(gradient: AppColors.loader),
          ),
        ),
      ),
    );
  }
}
