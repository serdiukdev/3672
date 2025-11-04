import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../statistic/bloc/statistic/state.dart';

class HistoryEntry {
  final String id;
  final String category; // 'income' or 'expense'
  final String subCategory;
  final String date; // dd-mm-yyyy
  final double amount;
  final String? description;

  const HistoryEntry({
    required this.id,
    required this.category,
    required this.subCategory,
    required this.date,
    required this.amount,
    this.description,
  });

  factory HistoryEntry.fromJson(
    Map<String, dynamic> json, {
    required String fallbackCategory,
  }) {
    return HistoryEntry(
      id:
          (json['id'] as String?) ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      category: (json['category'] as String?) ?? fallbackCategory,
      subCategory: (json['subCategory'] as String?) ?? '',
      date: (json['date'] as String?) ?? '',
      amount: (json['amount'] is num)
          ? (json['amount'] as num).toDouble()
          : double.tryParse('${json['amount']}') ?? 0,
      description: json['description'] as String?,
    );
  }
}

class HistoryState {
  final String mode; // 'income' | 'expense'
  final SelectedPeriod period;
  final bool loading;
  final List<HistoryEntry> entries;
  final Map<String, List<HistoryEntry>> groupedByDate;
  final List<String> sortedDatesDesc; // dd-mm-yyyy, sorted by actual date desc

  const HistoryState({
    required this.mode,
    required this.period,
    required this.loading,
    required this.entries,
    required this.groupedByDate,
    required this.sortedDatesDesc,
  });

  Color get accentColor =>
      mode == 'income' ?  AppColors.mainBLue :  AppColors.topOrangeBG;

  HistoryState copyWith({
    String? mode,
    SelectedPeriod? period,
    bool? loading,
    List<HistoryEntry>? entries,
    Map<String, List<HistoryEntry>>? groupedByDate,
    List<String>? sortedDatesDesc,
  }) => HistoryState(
    mode: mode ?? this.mode,
    period: period ?? this.period,
    loading: loading ?? this.loading,
    entries: entries ?? this.entries,
    groupedByDate: groupedByDate ?? this.groupedByDate,
    sortedDatesDesc: sortedDatesDesc ?? this.sortedDatesDesc,
  );

  factory HistoryState.initial({String mode = 'expense'}) {
    final now = DateTime.now();
    return HistoryState(
      mode: mode,
      period: SelectedPeriod(year: now.year, month: now.month),
      loading: false,
      entries: const [],
      groupedByDate: const {},
      sortedDatesDesc: const [],
    );
  }
}
