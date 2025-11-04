import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'state.dart';

class StatisticBloc extends Cubit<StatisticState> {
  static const _kSelectedPeriodKey = 'selected_period';
  static const _kExpenseEntriesKey = 'expense_entries';

  StatisticBloc()
      : super(
          StatisticState(
            period: SelectedPeriod(year: DateTime.now().year, month: DateTime.now().month),
            categories: const [],
            total: 0,
            loading: false,
          ),
        );

  Future<void> selectMonth(int month, int year) async {
    final period = SelectedPeriod(year: year, month: month, startDate: null, endDate: null);
    await _savePeriod(period);
    emit(state.copyWith(period: period));
  }

  Future<void> selectPeriod(DateTime start, DateTime end) async {
    final fixed = _normalizeRange(start, end);
    final period = SelectedPeriod(
      year: state.period.year,
      month: state.period.month,
      startDate: fixed.$1,
      endDate: fixed.$2,
    );
    await _savePeriod(period);
    emit(state.copyWith(period: period));
  }

  Future<SelectedPeriod> getSelectedPeriod() async {
    final saved = await _loadPeriod();
    if (saved != null) {
      emit(state.copyWith(period: saved));
      return saved;
    }
    return state.period;
  }

  Future<void> loadStatistics() async {
    emit(state.copyWith(loading: true));
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_kExpenseEntriesKey) ?? <String>[];

    final period = await _ensurePeriod();
    final range = _effectiveRange(period);

    final Map<String, double> byCategory = {};
    for (final s in raw) {
      try {
        final m = jsonDecode(s) as Map<String, dynamic>;
        final dateStr = (m['date'] as String?) ?? '';
        final parts = dateStr.split('-');
        if (parts.length != 3) continue;
        final d = int.tryParse(parts[0]) ?? 1;
        final mo = int.tryParse(parts[1]) ?? 1;
        final y = int.tryParse(parts[2]) ?? 1970;
        final dt = DateTime(y, mo, d);
        if (dt.isBefore(range.$1) || dt.isAfter(range.$2)) continue;

        final name = (m['subCategory'] as String?)?.trim();
        if (name == null || name.isEmpty) continue;
        final v = (m['amount'] as num?)?.toDouble() ?? 0;
        if (v <= 0) continue;
        byCategory.update(name, (p) => p + v, ifAbsent: () => v);
      } catch (_) {}
    }

    final total = byCategory.values.fold<double>(0, (a, b) => a + b);
    final categories = byCategory.entries
        .map((e) => CategoryStat(name: e.key, amount: e.value, percent: total == 0 ? 0 : e.value / total))
        .toList()
      ..sort((a, b) => b.amount.compareTo(a.amount));

    emit(state.copyWith(categories: categories, total: total, loading: false));
  }

  // Helpers
  Future<void> _savePeriod(SelectedPeriod p) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kSelectedPeriodKey, jsonEncode(p.toJson()));
  }

  Future<SelectedPeriod?> _loadPeriod() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kSelectedPeriodKey);
    if (raw == null || raw.isEmpty) return null;
    try {
      return SelectedPeriod.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  Future<SelectedPeriod> _ensurePeriod() async {
    final saved = await _loadPeriod();
    if (saved != null) return saved;
    final now = DateTime.now();
    final p = SelectedPeriod(year: now.year, month: now.month);
    await _savePeriod(p);
    return p;
  }

  (DateTime, DateTime) _normalizeRange(DateTime a, DateTime b) {
    final d1 = DateTime(a.year, a.month, a.day);
    final d2 = DateTime(b.year, b.month, b.day);
    if (d1.isBefore(d2) || d1.isAtSameMomentAs(d2)) return (d1, d2);
    return (d2, d1);
  }

  (DateTime, DateTime) _effectiveRange(SelectedPeriod period) {
    final first = DateTime(period.year, period.month, 1);
    final last = DateTime(period.year, period.month + 1, 0);
    final start = period.startDate != null ? DateTime(period.startDate!.year, period.startDate!.month, period.startDate!.day) : first;
    final end = period.endDate != null ? DateTime(period.endDate!.year, period.endDate!.month, period.endDate!.day) : last;
    return _normalizeRange(start, end);
  }
}
