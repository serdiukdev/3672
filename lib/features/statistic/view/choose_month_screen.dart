import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:itd_2/core/constants/app_colors.dart';
import 'package:itd_2/core/services/app_navigator.dart';
import 'package:itd_2/features/statistic/view/statistic_screen.dart';

import '../../../core/constants/app_styles.dart';
import '../../../core/constants/app_text.dart';
import '../../../shared/components/month_picker_panel.dart';
import '../../../shared/components/nav_bar.dart';
import '../../settings/view/settings_screen.dart';
import '../bloc/statistic/bloc.dart';
import 'choose_period_screen.dart';

class ChooseMonthScreen extends StatefulWidget {
  static const routeName = 'chooseMonth';

  const ChooseMonthScreen({super.key});

  @override
  State<ChooseMonthScreen> createState() => _ChooseMonthScreenState();
}

class _ChooseMonthScreenState extends State<ChooseMonthScreen> {
  int _tab = 4;
  late int _year;
  int? _month;
  final _bloc = StatisticBloc();

  final List<int> _years = const [2023, 2024, 2025, 2026];
  final List<String> _monthNames = const [
    'JANUARY',
    'FEBRUARY',
    'MARCH',
    'APRIL',
    'MAY',
    'JUNE',
    'JULY',
    'AUGUST',
    'SEPTEMBER',
    'OCTOBER',
    'NOVEMBER',
    'DECEMBER',
  ];

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _year = now.year;
    _month = now.month;
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  Future<void> _onOk() async {
    await _bloc.selectMonth(_month ?? DateTime.now().month, _year);
    if (!mounted) return;
    context.push(ChoosePeriodScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Image.asset('assets/general_buttons/back_icon.webp'),
          onPressed: () =>
              context.pushNamedAndRemoveUntil(StatisticScreen.routeName),
        ),
        actions: [
          IconButton(
            onPressed: () =>
                context.pushNamedAndRemoveUntil(SettingsScreen.routeName),
            icon: Image.asset('assets/general_buttons/setting_icon.webp'),
          ),
        ],
      ),

      bottomNavigationBar: BottomNavBar(
        currentIndex: _tab,
        onTap: (i) => setState(() => _tab = i),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/bg_in_game/bg_3.webp'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
            child: Container(color: AppColors.mainBlack.withOpacity(0.2)),
          ),
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 12),
                SizedBox(
                  height: size.height * 0.07,
                  width: double.infinity,
                  child: Text(
                    AppTexts.choosePeriod,
                    style: AppStyles.categoryItem,
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: MonthPickerPanel(
                    years: _years,
                    year: _year,
                    month: _month,
                    onYearChanged: (y) => setState(() => _year = y),
                    onMonthChanged: (m) => setState(() => _month = m),
                  ),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: _onOk,
                  child: Image.asset(
                    'assets/general_buttons/ok_button.webp',
                    height: size.height * 0.06,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
