import 'package:flutter/material.dart';

import '../../core/constants/app_styles.dart';

class PeriodPickerPanel extends StatelessWidget {
  final int year;
  final int month; // 1-12
  final DateTime? start;
  final DateTime? end;
  final ValueChanged<int> onDayTap; // day number 1..N

  const PeriodPickerPanel({
    super.key,
    required this.year,
    required this.month,
    required this.start,
    required this.end,
    required this.onDayTap,
  });

  static const List<String> _monthNames = [
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

  int get _daysInMonth => DateTime(year, month + 1, 0).day;

  int get _firstWeekdayMonBased {
    final wd = DateTime(year, month, 1).weekday; // 1=Mon..7=Sun
    return wd;
  }

  bool _inRange(DateTime d) {
    if (start == null && end == null) return false;
    final s = DateTime(
      (start ?? DateTime(year, month, 1)).year,
      (start ?? DateTime(year, month, 1)).month,
      (start ?? DateTime(year, month, 1)).day,
    );
    final e = DateTime(
      (end ?? DateTime(year, month + 1, 0)).year,
      (end ?? DateTime(year, month + 1, 0)).month,
      (end ?? DateTime(year, month + 1, 0)).day,
    );
    final x = DateTime(d.year, d.month, d.day);
    return (x.isAfter(s) || x.isAtSameMomentAs(s)) &&
        (x.isBefore(e) || x.isAtSameMomentAs(e));
  }

  @override
  Widget build(BuildContext context) {
    final totalCells = 42; // 6 weeks
    final leadingBlanks = (_firstWeekdayMonBased - 1) % 7;
    final items = <Widget>[];

    for (int i = 0; i < leadingBlanks; i++) {
      items.add(const SizedBox.shrink());
    }
    for (int day = 1; day <= _daysInMonth; day++) {
      final d = DateTime(year, month, day);
      final selected = _inRange(d);
      items.add(
        GestureDetector(
          onTap: () => onDayTap(day),
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

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/bg_components/calendar_bg.webp'),
          fit: BoxFit.fill,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${_monthNames[month - 1]} $year',
            style: AppStyles.categoryItem.copyWith(fontSize: 20),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: weekdays
                .map(
                  (w) => Expanded(
                    child: Center(
                      child: Text(
                        w,
                        style: AppStyles.categoryItem.copyWith(fontSize: 16),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                crossAxisSpacing: 6,
                mainAxisSpacing: 6,
              ),
              itemCount: items.length,
              itemBuilder: (_, idx) => items[idx],
            ),
          ),
        ],
      ),
    );
  }
}
