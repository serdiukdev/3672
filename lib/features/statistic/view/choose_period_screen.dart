import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:itd_2/core/services/app_navigator.dart';
import 'package:itd_2/features/statistic/view/result_statistic_screen.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_styles.dart';
import '../../../core/constants/app_text.dart';
import '../../../shared/components/nav_bar.dart';
import '../../../shared/components/period_picker_panel.dart';
import '../../settings/view/settings_screen.dart';
import '../bloc/statistic/bloc.dart';
import 'choose_month_screen.dart';

class ChoosePeriodScreen extends StatefulWidget {
  static const routeName = 'choosePeriod';

  const ChoosePeriodScreen({super.key});

  @override
  State<ChoosePeriodScreen> createState() => _ChoosePeriodScreenState();
}

class _ChoosePeriodScreenState extends State<ChoosePeriodScreen> {
  int _tab = 4;
  final _bloc = StatisticBloc();
  int _year = DateTime.now().year;
  int _month = DateTime.now().month;
  DateTime? _start;
  DateTime? _end;

  @override
  void initState() {
    super.initState();
    _initFromSaved();
  }

  Future<void> _initFromSaved() async {
    final p = await _bloc.getSelectedPeriod();
    setState(() {
      _year = p.year;
      _month = p.month;
      _start = p.startDate;
      _end = p.endDate;
    });
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  int get _daysInMonth => DateTime(_year, _month + 1, 0).day;

  int get _firstWeekdayMonBased {
    final wd = DateTime(_year, _month, 1).weekday; // 1=Mon..7=Sun
    return wd; // already Mon-based
  }

  bool _inRange(DateTime d) {
    if (_start == null && _end == null) return false;
    final start = _start ?? DateTime(_year, _month, 1);
    final end = _end ?? DateTime(_year, _month + 1, 0);
    final s = DateTime(start.year, start.month, start.day);
    final e = DateTime(end.year, end.month, end.day);
    final x = DateTime(d.year, d.month, d.day);
    return (x.isAfter(s) || x.isAtSameMomentAs(s)) &&
        (x.isBefore(e) || x.isAtSameMomentAs(e));
  }

  void _onTapDay(int day) {
    final picked = DateTime(_year, _month, day);
    setState(() {
      if (_start == null || (_start != null && _end != null)) {
        _start = picked;
        _end = null;
      } else {
        if (picked.isBefore(_start!)) {
          _end = _start;
          _start = picked;
        } else {
          _end = picked;
        }
      }
    });
  }

  Future<void> _onOk() async {
    DateTime start = _start ?? DateTime(_year, _month, 1);
    DateTime end = _end ?? DateTime(_year, _month + 1, 0);
    if (end.isBefore(start)) {
      final tmp = start;
      start = end;
      end = tmp;
    }
    await _bloc.selectPeriod(start, end);
    if (!mounted) return;
    context.push(ResultStatisticScreen.routeName);
  }

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
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final totalCells = 42; // 6 weeks
    final leadingBlanks = (_firstWeekdayMonBased - 1) % 7;
    final items = <Widget>[];

    for (int i = 0; i < leadingBlanks; i++) {
      items.add(const SizedBox.shrink());
    }
    for (int day = 1; day <= _daysInMonth; day++) {
      final d = DateTime(_year, _month, day);
      final selected = _inRange(d);
      items.add(
        GestureDetector(
          onTap: () => _onTapDay(day),
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  selected
                      ? 'assets/bg_components/selected_period_bg.webp'
                      : 'assets/bg_components/calendar_bg.webp',
                ),
                fit: BoxFit.fill,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: Text('$day', style: AppStyles.categoryItem),
          ),
        ),
      );
    }
    while (items.length < totalCells) {
      items.add(const SizedBox.shrink());
    }

    final weekdays = const ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Image.asset('assets/general_buttons/back_icon.webp'),
          onPressed: () =>
              context.pushNamedAndRemoveUntil(ChooseMonthScreen.routeName),
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
            child: Container(color: Colors.black.withOpacity(0.2)),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                children: [
                  SizedBox(
                    height: size.height * 0.07,
                    width: double.infinity,
                    child: Text(
                      AppTexts.choosePeriod,
                      style: AppStyles.categoryItem,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    height: size.height * 0.04,
                    width: double.infinity,
                    decoration: BoxDecoration(color: AppColors.topOrangeBG),
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _years.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (_, idx) {
                        final y = _years[idx];
                        final selected = y == _year;
                        return GestureDetector(
                          onTap: () => setState(() => _year = y),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                            ),
                            child: Text(
                              '$y',
                              style: selected
                                  ? AppStyles.categoryItem.copyWith(
                                      fontSize: 18,
                                    )
                                  : AppStyles.categoryItem.copyWith(
                                      fontSize: 18,
                                      color: AppColors.mainWhite.withOpacity(
                                        0.5,
                                      ),
                                    ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 8),
                  SizedBox(
                    height: size.height * 0.4,
                    width: size.width * 0.90,
                    child: PeriodPickerPanel(
                      year: _year,
                      month: _month,
                      start: _start,
                      end: _end,
                      onDayTap: _onTapDay,
                    ),
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: _onOk,
                    child: Image.asset(
                      'assets/general_buttons/ok_button.webp',
                      height: size.height * 0.06,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
