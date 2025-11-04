import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:itd_2/core/services/app_navigator.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_styles.dart';
import '../../../core/constants/app_text.dart';
import '../../../shared/components/nav_bar.dart';
import '../../main/view/main_screen.dart';
import '../../settings/view/settings_screen.dart';
import '../bloc/achievements/bloc.dart';
import '../bloc/achievements/state.dart';

class AchievementsScreen extends StatefulWidget {
  static const routeName = 'achievements';

  const AchievementsScreen({super.key});

  @override
  State<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen> {
  int _tab = 0;
  late final AchievementsBloc _bloc;
  final Map<String, String> _imageById = {};

  static const _achImages = [
    'assets/achievements/ach_1.webp',
    'assets/achievements/ach_2.webp',
    'assets/achievements/ach_3.webp',
    'assets/achievements/ach_4.webp',
    'assets/achievements/ach_5.webp',
    'assets/achievements/ach_6.webp',
    'assets/achievements/ach_7.webp',
    'assets/achievements/ach_8.webp',
    'assets/achievements/ach_10.webp',
    'assets/achievements/ach_11.webp',
    'assets/achievements/ach_12.webp',
  ];

  @override
  void initState() {
    super.initState();
    _bloc = AchievementsBloc();
    _bloc.load();
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  void _ensureImages(List<String> ids) {
    if (_imageById.length == ids.length) return;
    final rng = Random();
    for (final id in ids) {
      _imageById.putIfAbsent(
        id,
        () => _achImages[rng.nextInt(_achImages.length)],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(AppTexts.achievements, style: AppStyles.achievementTitle),
        actions: [
          IconButton(
            onPressed: () =>
                context.pushNamedAndRemoveUntil(SettingsScreen.routeName),
            icon: Image.asset('assets/general_buttons/setting_icon.webp'),
          ),
        ],
        leading: IconButton(
          onPressed: () =>
              context.pushNamedAndRemoveUntil(MainScreen.routeName),
          icon: Image.asset('assets/general_buttons/back_icon.webp'),
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _tab,
        onTap: (index) {
          setState(() => _tab = index);
        },
      ),
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
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
            child: Container(color: Colors.black.withOpacity(0.2)),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: BlocBuilder<AchievementsBloc, AchievementsState>(
                bloc: _bloc,
                builder: (context, state) {
                  if (state.loading) {
                    return Center(
                      child: Text(
                        AppTexts.loading,
                        style: AppStyles.categoryItem,
                      ),
                    );
                  }

                  final ids = state.achievements
                      .map((e) => e.id)
                      .toList(growable: false);
                  _ensureImages(ids);

                  return ListView.separated(
                    itemCount: state.achievements.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final a = state.achievements[index];
                      final percent = a.goalValue == 0
                          ? 1.0
                          : (a.currentValue / a.goalValue).clamp(0.0, 1.0);
                      final rightImg = _imageById[a.id]!;
                      final locked = a.currentValue <= 0 && !a.isCompleted;

                      return Container(
                        height: size.height * 0.18,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          image: const DecorationImage(
                            image: AssetImage(
                              'assets/bg_components/achievement_bg.webp',
                            ),
                            fit: BoxFit.fill,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                child: Opacity(
                                  opacity: a.isCompleted
                                      ? 1.0
                                      : (locked ? 0.7 : 0.9),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              a.title,
                                              style: AppStyles.achievementTitle,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          const SizedBox(width: 6),
                                          Icon(
                                            a.isCompleted
                                                ? Icons.lock_open
                                                : (locked
                                                      ? Icons.lock
                                                      : Icons.lock_open),
                                            color: AppColors.secondText,
                                            size: 18,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        a.description,
                                        style: AppStyles.achievementDescription,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 8),
                                      LayoutBuilder(
                                        builder: (context, constraints) {
                                          final w = constraints.maxWidth;
                                          final fill = (w * percent).clamp(
                                            0.0,
                                            w,
                                          );
                                          return Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                height: 12,
                                                decoration: BoxDecoration(
                                                  color: AppColors.bottomNavBg,
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: Stack(
                                                  fit: StackFit.expand,
                                                  children: [
                                                    Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Container(
                                                        width: fill,
                                                        decoration: BoxDecoration(
                                                          gradient:
                                                              const LinearGradient(
                                                                colors: [
                                                                  Color(
                                                                    0xFFF29517,
                                                                  ),
                                                                  Color(
                                                                    0xFFFFF053,
                                                                  ),
                                                                ],
                                                                begin: Alignment
                                                                    .centerLeft,
                                                                end: Alignment
                                                                    .centerRight,
                                                              ),
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                8,
                                                              ),
                                                        ),
                                                      ),
                                                    ),
                                                    IgnorePointer(
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                          border: Border.all(
                                                            color: AppColors
                                                                .progressBorder,
                                                            width: 2,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                8,
                                                              ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: size.width * 0.25,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Image.asset(
                                    rightImg,
                                    height: size.height * 0.12,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
