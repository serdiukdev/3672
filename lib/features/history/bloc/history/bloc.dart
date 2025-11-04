import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../statistic/bloc/statistic/state.dart';
import 'state.dart';

class HistoryBloc extends Cubit<HistoryState> {
  static const String _kIncomeEntriesKey = 'income_entries';
  static const String _kExpenseEntriesKey = 'expense_entries';
  static const String _kSelectedPeriodKey = 'history_selected_period';

  HistoryBloc({String mode = 'expense'})
    : super(HistoryState.initial(mode: mode));

  Future<void> setMode(String mode) async {
    emit(state.copyWith(mode: mode));
    await loadEntries();
  }

  Future<void> selectMonth(int month, int year) async {
    final p = SelectedPeriod(year: year, month: month);
    await _savePeriod(p);
    emit(state.copyWith(period: p));
  }

  Future<void> selectPeriod(DateTime start, DateTime end) async {
    final s = DateTime(start.year, start.month, start.day);
    final e = DateTime(end.year, end.month, end.day);
    DateTime a = s, b = e;
    if (b.isBefore(a)) {
      final t = a;
      a = b;
      b = t;
    }
    final p = SelectedPeriod(
      year: state.period.year,
      month: state.period.month,
      startDate: a,
      endDate: b,
    );
    await _savePeriod(p);
    emit(state.copyWith(period: p));
  }

  Future<SelectedPeriod> getSelectedPeriod() async {
    final saved = await _loadPeriod();
    if (saved != null) {
      emit(state.copyWith(period: saved));
      return saved;
    }
    final now = DateTime.now();
    final p = SelectedPeriod(year: now.year, month: now.month);
    await _savePeriod(p);
    emit(state.copyWith(period: p));
    return p;
  }

  Future<void> loadEntries() async {
    emit(state.copyWith(loading: true));
    final prefs = await SharedPreferences.getInstance();
    final key = state.mode == 'income'
        ? _kIncomeEntriesKey
        : _kExpenseEntriesKey;
    final rawList = prefs.getStringList(key) ?? <String>[];

    final p = await _ensurePeriod();
    final range = _effectiveRange(p);

    final entries = <HistoryEntry>[];
    for (final s in rawList) {
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
        entries.add(HistoryEntry.fromJson(m, fallbackCategory: state.mode));
      } catch (_) {}
    }

    // group by date string and sort dates desc
    final Map<String, List<HistoryEntry>> grouped = {};
    for (final e in entries) {
      (grouped[e.date] ??= []).add(e);
    }
    final sortedDates = grouped.keys.toList()
      ..sort((a, b) => _parseDate(b).compareTo(_parseDate(a)));

    emit(
      state.copyWith(
        loading: false,
        entries: entries,
        groupedByDate: grouped,
        sortedDatesDesc: sortedDates,
      ),
    );
  }

  // Helpers
  Future<void> _savePeriod(SelectedPeriod p) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _kSelectedPeriodKey,
      jsonEncode({
        'year': p.year,
        'month': p.month,
        'startDate': p.startDate?.toIso8601String(),
        'endDate': p.endDate?.toIso8601String(),
      }),
    );
  }

  Future<SelectedPeriod?> _loadPeriod() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kSelectedPeriodKey);
    if (raw == null || raw.isEmpty) return null;
    try {
      final m = jsonDecode(raw) as Map<String, dynamic>;
      return SelectedPeriod(
        year: (m['year'] as num).toInt(),
        month: (m['month'] as num).toInt(),
        startDate: (m['startDate'] as String?) != null
            ? DateTime.tryParse(m['startDate'] as String)
            : null,
        endDate: (m['endDate'] as String?) != null
            ? DateTime.tryParse(m['endDate'] as String)
            : null,
      );
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

  (DateTime, DateTime) _effectiveRange(SelectedPeriod p) {
    final first = DateTime(p.year, p.month, 1);
    final last = DateTime(p.year, p.month + 1, 0);
    final start = p.startDate != null
        ? DateTime(p.startDate!.year, p.startDate!.month, p.startDate!.day)
        : first;
    final end = p.endDate != null
        ? DateTime(p.endDate!.year, p.endDate!.month, p.endDate!.day)
        : last;
    if (end.isBefore(start)) {
      return (end, start);
    }
    return (start, end);
  }

  DateTime _parseDate(String ddmmyyyy) {
    final parts = ddmmyyyy.split('-');
    if (parts.length != 3) return DateTime(1970, 1, 1);
    final d = int.tryParse(parts[0]) ?? 1;
    final m = int.tryParse(parts[1]) ?? 1;
    final y = int.tryParse(parts[2]) ?? 1970;
    return DateTime(y, m, d);
  }
}
