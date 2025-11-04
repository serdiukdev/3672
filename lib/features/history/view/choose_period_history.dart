import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:itd_2/core/constants/app_colors.dart';
import 'package:itd_2/core/services/app_navigator.dart';
import '../../../core/constants/app_styles.dart';
import '../../../core/constants/app_text.dart';
import '../../../shared/components/nav_bar.dart';
import '../../../shared/components/period_picker_panel.dart';
import '../bloc/history/bloc.dart';
import 'choose_month_history.dart';
import 'history_list_screen.dart';

class ChoosePeriodHistory extends StatefulWidget {
  static const routeName = 'history_choose_period';
  final String mode;

  const ChoosePeriodHistory({super.key, required this.mode});

  @override
  State<ChoosePeriodHistory> createState() => _ChoosePeriodHistoryState();
}

class _ChoosePeriodHistoryState extends State<ChoosePeriodHistory> {
  int _tab = 3;
  late final HistoryBloc _bloc;
  int _year = DateTime.now().year;
  int _month = DateTime.now().month;
  DateTime? _start;
  DateTime? _end;

  final List<int> _years = const [2023, 2024, 2025, 2026];

  @override
  void initState() {
    super.initState();
    _bloc = HistoryBloc(mode: widget.mode);
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
      final t = start;
      start = end;
      end = t;
    }
    await _bloc.selectPeriod(start, end);
    if (!mounted) return;
    context.pushNamedAndRemoveUntil(
      HistoryListScreen.routeName,
      arguments: widget.mode,
    );
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
          onPressed: () => context.pushNamedAndRemoveUntil(
            ChooseMonthHistory.routeName,
            arguments: widget.mode,
          ),
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
                            color: Colors.transparent,
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
                  const SizedBox(height: 8),
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
                  const Spacer(),
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
