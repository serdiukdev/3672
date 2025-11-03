class SelectedPeriod {
  int year;
  int month;
  DateTime? startDate;
  DateTime? endDate;

  SelectedPeriod({
    required this.year,
    required this.month,
    this.startDate,
    this.endDate,
  });

  Map<String, dynamic> toJson() => {
        'year': year,
        'month': month,
        'startDate': startDate?.toIso8601String(),
        'endDate': endDate?.toIso8601String(),
      };

  factory SelectedPeriod.fromJson(Map<String, dynamic> json) => SelectedPeriod(
        year: (json['year'] as num).toInt(),
        month: (json['month'] as num).toInt(),
        startDate: json['startDate'] != null ? DateTime.tryParse(json['startDate'] as String) : null,
        endDate: json['endDate'] != null ? DateTime.tryParse(json['endDate'] as String) : null,
      );
}

class CategoryStat {
  final String name;
  final double amount;
  final double percent;

  const CategoryStat({required this.name, required this.amount, required this.percent});
}

class StatisticState {
  final SelectedPeriod period;
  final List<CategoryStat> categories;
  final double total;
  final bool loading;

  const StatisticState({
    required this.period,
    required this.categories,
    required this.total,
    required this.loading,
  });

  StatisticState copyWith({
    SelectedPeriod? period,
    List<CategoryStat>? categories,
    double? total,
    bool? loading,
  }) => StatisticState(
        period: period ?? this.period,
        categories: categories ?? this.categories,
        total: total ?? this.total,
        loading: loading ?? this.loading,
      );
}
