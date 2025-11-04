import 'dart:ui';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:itd_2/core/services/app_navigator.dart';
import 'package:itd_2/features/main/view/widgets/goal_pill.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_styles.dart';
import '../../../core/constants/app_text.dart';
import '../../../core/services/finance_repository.dart';
import '../../../shared/components/nav_bar.dart';
import '../../settings/view/settings_screen.dart';
import '../../shop/bloc/shop/event.dart';
import '../../shop/models/shop.dart';
import '../bloc/main/bloc.dart';
import '../bloc/main/event.dart';
import '../bloc/main/state.dart';
import '../models/user_finance.dart';
import 'daily_bonus/daily_bonus_screen.dart';

class MainScreen extends StatefulWidget {
  static const routeName = '/main';

  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  int _tab = 7; // center selected by default
  late final TextEditingController _savingController;
  final _repo = FinanceRepository();
  UserFinanceState? _finance;
  late final FocusNode _savingFocus;
  late final TextEditingController _limitController;
  late final FocusNode _limitFocus;
  String? _savingOverride;
  String? _limitOverride;
  String _selectedBasketAsset = ShopCatalog.defaultBasketAsset;
  String _selectedBasketMaskAsset = ShopCatalog.defaultBasketMaskAsset;
  String _selectedBackgroundAsset = ShopCatalog.defaultBackgroundAsset;
  StreamSubscription? _shopSub;
  late final AnimationController _glowCtrl;
  bool _showCelebrate = false;
  bool _showDailyBonusHint = false;

  @override
  void initState() {
    super.initState();
    _savingController = TextEditingController();
    _savingFocus = FocusNode();
    _limitController = TextEditingController();
    _limitFocus = FocusNode();
    context.read<MainBloc>().add(MainStarted());
    Future.microtask(_loadFinance);
    _loadShopSelections();
    _loadDailyBonusHint();
    _shopSub = ShopEvents.stream.listen((_) => _loadShopSelections());
    _glowCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Future.microtask(() => context.read<MainBloc>().add(MainStarted()));
  }

  @override
  void dispose() {
    _savingController.dispose();
    _savingFocus.dispose();
    _limitController.dispose();
    _limitFocus.dispose();
    _shopSub?.cancel();
    _glowCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadFinance() async {
    final state = await _repo.getFinanceState();
    if (mounted) setState(() => _finance = state);
  }

  Future<void> _loadShopSelections() async {
    final prefs = await SharedPreferences.getInstance();
    final selectedBasketId = prefs.getString('selected_basket');
    final selectedBackgroundId = prefs.getString('selected_background');
    String basketAsset = ShopCatalog.defaultBasketAsset;
    String basketMaskAsset = ShopCatalog.defaultBasketMaskAsset;
    if (selectedBasketId != null) {
      final match = ShopCatalog.baskets.where((e) => e.id == selectedBasketId);
      if (match.isNotEmpty) {
        basketAsset = match.first.assetPath;
        basketMaskAsset =
            match.first.maskAssetPath ?? ShopCatalog.defaultBasketMaskAsset;
      }
    }
    String bgAsset = ShopCatalog.defaultBackgroundAsset;
    if (selectedBackgroundId != null) {
      final matchBg = ShopCatalog.backgrounds.where(
        (e) => e.id == selectedBackgroundId,
      );
      if (matchBg.isNotEmpty) {
        bgAsset = matchBg.first.assetPath;
      }
    }
    if (mounted) {
      setState(() {
        _selectedBasketAsset = basketAsset;
        _selectedBasketMaskAsset = basketMaskAsset;
        _selectedBackgroundAsset = bgAsset;
      });
    }
  }

  Future<void> _loadDailyBonusHint() async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();
    final dateKey =
        "${now.year.toString().padLeft(4, '0')}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
    final last = prefs.getString('daily_last_claim_date');
    if (mounted) {
      setState(() {
        _showDailyBonusHint = last != dateKey;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset(_selectedBackgroundAsset, fit: BoxFit.cover),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 0.0, sigmaY: 0.0),
            child: Container(color: AppColors.mainBlack.withOpacity(0.25)),
          ),
          SafeArea(
            child: BlocListener<MainBloc, MainState>(
              listener: (context, state) {
                if (state.justAchieved) {
                  _showCelebrate = true;
                  Future.delayed(const Duration(seconds: 3), () {
                    if (mounted) setState(() => _showCelebrate = false);
                  });
                }
              },
              child: BlocBuilder<MainBloc, MainState>(
                builder: (context, state) {
                  return Column(
                    children: [
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Settings button
                            GestureDetector(
                              onTap: () {
                                context.pushNamedAndRemoveUntil(
                                  SettingsScreen.routeName,
                                );
                              },
                              child: Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                      'assets/general_buttons/setting_icon.webp',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            // Daily bonus button + text
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    await Navigator.of(
                                      context,
                                    ).pushNamed(DailyBonusScreen.routeName);
                                    await _loadDailyBonusHint();
                                  },
                                  child: Image.asset(
                                    'assets/general_buttons/daily_bonus_button.webp',
                                    height: 58,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Visibility(
                                  visible: _showDailyBonusHint,
                                  child: Text(
                                    AppTexts.getBonus,
                                    textAlign: TextAlign.center,
                                    style: AppStyles.yellowText.copyWith(
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),

                      // Basket with dynamic fill
                      SizedBox(
                        height: size.height * 0.32,
                        child: state.loading
                            ? Center(
                                child: ScaleTransition(
                                  scale: Tween(begin: 0.95, end: 1.05).animate(
                                    CurvedAnimation(
                                      parent: _glowCtrl,
                                      curve: Curves.easeInOut,
                                    ),
                                  ),
                                  child: Opacity(
                                    opacity: 0.5,
                                    child: Image.asset(
                                      _selectedBasketAsset,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              )
                            : TweenAnimationBuilder<double>(
                                duration: const Duration(milliseconds: 1000),
                                curve: Curves.easeOut,
                                tween: Tween<double>(
                                  begin: 0,
                                  end: state.savingPercent,
                                ),
                                builder: (_, value, __) {
                                  final eff = value.clamp(0.0, 1.0).toDouble();
                                  final maskAsset = _selectedBasketMaskAsset;
                                  return Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      Image.asset(
                                        maskAsset,
                                        fit: BoxFit.contain,
                                      ),
                                      ShaderMask(
                                        shaderCallback: (Rect bounds) {
                                          final stop = eff.clamp(0.0, 1.0);
                                          return LinearGradient(
                                            begin: Alignment.bottomCenter,
                                            end: Alignment.topCenter,
                                            stops: [0.0, stop, stop, 1.0],
                                            colors: [
                                              AppColors.mainWhite,
                                              AppColors.mainWhite,
                                              Colors.transparent,
                                              Colors.transparent,
                                            ],
                                          ).createShader(bounds);
                                        },
                                        blendMode: BlendMode.dstIn,
                                        child: Image.asset(
                                          _selectedBasketAsset,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                      if (state.goalAchieved)
                                        IgnorePointer(
                                          child: AnimatedBuilder(
                                            animation: _glowCtrl,
                                            builder: (_, __) => Container(
                                              decoration: BoxDecoration(
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.yellow
                                                        .withOpacity(
                                                          0.4 +
                                                              0.3 *
                                                                  _glowCtrl
                                                                      .value,
                                                        ),
                                                    blurRadius:
                                                        30 +
                                                        20 * _glowCtrl.value,
                                                    spreadRadius:
                                                        4 + 2 * _glowCtrl.value,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      if (_showCelebrate)
                                        Positioned.fill(
                                          child: Center(
                                            child: AnimatedOpacity(
                                              opacity: _showCelebrate ? 1 : 0,
                                              duration: const Duration(
                                                milliseconds: 300,
                                              ),
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 16,
                                                      vertical: 8,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: AppColors.mainBlack
                                                      .withOpacity(0.5),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: Text(
                                                  AppTexts.goalAchieved,
                                                  style: AppStyles.categoryItem,
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  );
                                },
                              ),
                      ),

                      const Spacer(),

                      // Current Balance
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 6,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            image: const DecorationImage(
                              image: AssetImage(
                                'assets/bg_components/income_item_bg.webp',
                              ),
                              fit: BoxFit.fill,
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 20,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                AppTexts.currentBalance,
                                style: AppStyles.yellowText.copyWith(
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                (_finance?.currentBalance ?? 0).toStringAsFixed(
                                  0,
                                ),
                                style: AppStyles.yellowText.copyWith(
                                  fontSize: 22,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Goals row
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 6,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GoalPill(
                              onTap: () => _openGoalEditor(
                                title: AppTexts.savingGoal,
                                controller: _savingController,
                                focusNode: _savingFocus,
                                initialValue:
                                    _savingOverride ?? state.savingGoal,
                                onSave: (value) async {
                                  await context
                                      .read<MainBloc>()
                                      .storage
                                      .setSavingGoal(value);
                                  setState(() => _savingOverride = value);
                                  final savedGoal =
                                      double.tryParse(value) ??
                                      (_finance?.savedGoal ?? 0);
                                  final expenseGoal =
                                      double.tryParse(
                                        _limitOverride ?? state.limitGoal,
                                      ) ??
                                      (_finance?.expenseGoal ?? 0);
                                  await _repo.updateGoals(
                                    savedGoal,
                                    expenseGoal,
                                  );
                                  await _loadFinance();
                                  final prefs =
                                      await SharedPreferences.getInstance();
                                  await prefs.setBool('goal_achieved', false);
                                  if (mounted)
                                    context.read<MainBloc>().add(MainStarted());
                                },
                              ),
                              title: AppTexts.savingMoney,
                              amount: (_savingOverride ?? state.savingGoal),
                            ),
                            GoalPill(
                              onTap: () => _openGoalEditor(
                                title: AppTexts.spendingLimit,
                                controller: _limitController,
                                focusNode: _limitFocus,
                                initialValue: _limitOverride ?? state.limitGoal,
                                onSave: (value) async {
                                  await context
                                      .read<MainBloc>()
                                      .storage
                                      .setLimitGoal(value);
                                  setState(() => _limitOverride = value);
                                  final savedGoal =
                                      double.tryParse(
                                        _savingOverride ?? state.savingGoal,
                                      ) ??
                                      (_finance?.savedGoal ?? 0);
                                  final expenseGoal =
                                      double.tryParse(value) ??
                                      (_finance?.expenseGoal ?? 0);
                                  await _repo.updateGoals(
                                    savedGoal,
                                    expenseGoal,
                                  );
                                  await _loadFinance();
                                },
                              ),
                              title: AppTexts.spendingMoney,
                              amount: (_limitOverride ?? state.limitGoal),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 110), // space for nav bar overlay
                    ],
                  );
                },
              ),
            ),
          ),
          // Bottom navigation bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: BottomNavBar(
              currentIndex: _tab,
              onTap: (index) {
                setState(() => _tab = index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openGoalEditor({
    required String title,
    required TextEditingController controller,
    required FocusNode focusNode,
    required String initialValue,
    required Future<void> Function(String) onSave,
  }) async {
    controller.text = initialValue;
    bool didFocus = false;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        String? error;
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            if (!didFocus) {
              didFocus = true;
              Future.microtask(
                () => FocusScope.of(ctx).requestFocus(focusNode),
              );
            }

            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => FocusScope.of(ctx).unfocus(),
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(ctx).viewInsets.bottom,
                ),
                child: Container(
                  height: 280,
                  decoration: BoxDecoration(
                    color: AppColors.topOrangeBG,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  child: Center(
                    child: Container(
                      width: 320,
                      height: 250,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                            'assets/bg_components/daily_bonus_bg.webp',
                          ),
                          fit: BoxFit.fill,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 20,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            title,
                            textAlign: TextAlign.center,
                            style: AppStyles.yellowText.copyWith(fontSize: 20),
                          ),
                          const SizedBox(height: 20),
                          Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(
                                  'assets/bg_components/add_sum.webp',
                                ),
                                fit: BoxFit.fill,
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: TextField(
                              maxLength: 7,
                              controller: controller,
                              focusNode: focusNode,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                  RegExp('[0-9.]'),
                                ),
                              ],
                              textAlign: TextAlign.center,
                              style: AppStyles.yellowText.copyWith(
                                fontSize: 18,
                              ),
                              decoration: InputDecoration(
                                counterText: '',
                                border: InputBorder.none,
                                hintText: '0',
                                hintStyle: AppStyles.yellowText.copyWith(
                                  color: Colors.white70,
                                ),
                                errorText: error,
                              ),
                              onSubmitted: (_) async {
                                final value = controller.text.trim();
                                final isValid =
                                    value.isNotEmpty &&
                                    RegExp(r'^\d+(?:\.\d+)?$').hasMatch(value);
                                if (!isValid) {
                                  setModalState(
                                    () => error = 'Enter a valid number',
                                  );
                                  return;
                                }
                                await onSave(value);
                                if (mounted) Navigator.of(ctx).pop();
                              },
                            ),
                          ),

                          const SizedBox(height: 24),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GestureDetector(
                                onTap: () => Navigator.of(ctx).pop(),
                                child: Container(
                                  width: 120,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(
                                        'assets/bg_components/expense_item_bg.webp',
                                      ),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    AppTexts.cancel,
                                    style: AppStyles.yellowText.copyWith(
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  final value = controller.text.trim();
                                  final isValid =
                                      value.isNotEmpty &&
                                      RegExp(
                                        r'^\d+(?:\.\d+)?$',
                                      ).hasMatch(value);
                                  if (!isValid) {
                                    setModalState(
                                      () => error = 'Enter a valid number',
                                    );
                                    return;
                                  }
                                  await onSave(value);
                                  if (mounted) Navigator.of(ctx).pop();
                                },
                                child: Container(
                                  width: 120,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(
                                        'assets/bg_components/expense_item_bg.webp',
                                      ),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    AppTexts.save,
                                    style: AppStyles.yellowText.copyWith(
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
