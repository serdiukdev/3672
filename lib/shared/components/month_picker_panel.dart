import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_styles.dart';

class MonthPickerPanel extends StatelessWidget {
  final List<int> years;
  final int year;
  final int? month; // 1-12
  final ValueChanged<int> onYearChanged;
  final ValueChanged<int> onMonthChanged;

  const MonthPickerPanel({
    super.key,
    required this.years,
    required this.year,
    required this.month,
    required this.onYearChanged,
    required this.onMonthChanged,
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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        Container(
          height: size.height * 0.04,
          width: double.infinity,
          decoration: BoxDecoration(color: AppColors.topOrangeBG),
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: years.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (_, idx) {
              final y = years[idx];
              final selected = y == year;
              return GestureDetector(
                onTap: () => onYearChanged(y),
                child: Container(
                  color: Colors.transparent,
                  child: Text(
                    '$y',
                    style: selected
                        ? AppStyles.categoryItem.copyWith(fontSize: 18)
                        : AppStyles.categoryItem.copyWith(
                            fontSize: 18,
                            color: AppColors.mainWhite.withOpacity(0.5),
                          ),
                    textAlign: TextAlign.left,
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GridView.builder(
              itemCount: 12,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.8,
              ),
              itemBuilder: (_, idx) {
                final m = idx + 1;
                final selected = m == month;
                return GestureDetector(
                  onTap: () => onMonthChanged(m),
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                          'assets/bg_components/'
                          '${selected ? 'selected_month_bg' : 'month_bg'}.webp',
                        ),
                        fit: BoxFit.fill,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      _monthNames[idx],
                      textAlign: TextAlign.center,
                      style: AppStyles.categoryItem.copyWith(fontSize: 16),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
