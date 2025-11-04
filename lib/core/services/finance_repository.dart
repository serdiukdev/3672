import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../features/add/models/expense.dart';
import '../../features/add/models/income.dart';
import '../../features/main/models/user_finance.dart';

class FinanceRepository {
  static const String _kFinanceStateKey = 'finance_state';
  static const String _kIncomeEntriesKey = 'income_entries';
  static const String _kExpenseEntriesKey = 'expense_entries';

  Future<void> addIncome(Income income) async {
    final prefs = await SharedPreferences.getInstance();

    final list = prefs.getStringList(_kIncomeEntriesKey) ?? <String>[];
    list.add(jsonEncode(income.toJson()));
    await prefs.setStringList(_kIncomeEntriesKey, list);

    final state = await getFinanceState();
    final updated = UserFinanceState(
      totalIncome: state.totalIncome + income.amount,
      totalExpense: state.totalExpense,
      savedGoal: state.savedGoal,
      expenseGoal: state.expenseGoal,
    );
    await _saveFinanceState(prefs, updated);
  }

  Future<void> addExpense(Expense expense) async {
    final prefs = await SharedPreferences.getInstance();

    final list = prefs.getStringList(_kExpenseEntriesKey) ?? <String>[];
    list.add(jsonEncode(expense.toJson()));
    await prefs.setStringList(_kExpenseEntriesKey, list);

    final state = await getFinanceState();
    final updated = UserFinanceState(
      totalIncome: state.totalIncome,
      totalExpense: state.totalExpense + expense.amount,
      savedGoal: state.savedGoal,
      expenseGoal: state.expenseGoal,
    );
    await _saveFinanceState(prefs, updated);
  }

  Future<UserFinanceState> getFinanceState() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kFinanceStateKey);
    if (raw != null && raw.isNotEmpty) {
      try {
        final json = jsonDecode(raw) as Map<String, dynamic>;
        return UserFinanceState.fromJson(json);
      } catch (_) {}
    }

    final incomeList = prefs.getStringList(_kIncomeEntriesKey) ?? <String>[];
    final expenseList = prefs.getStringList(_kExpenseEntriesKey) ?? <String>[];

    double sumIncome = 0;
    for (final s in incomeList) {
      try {
        final m = jsonDecode(s) as Map<String, dynamic>;
        final v = (m['amount'] as num?)?.toDouble() ?? 0;
        sumIncome += v;
      } catch (_) {}
    }

    double sumExpense = 0;
    for (final s in expenseList) {
      try {
        final m = jsonDecode(s) as Map<String, dynamic>;
        final v = (m['amount'] as num?)?.toDouble() ?? 0;
        sumExpense += v;
      } catch (_) {}
    }

    final savedGoal =
        double.tryParse(prefs.getString('goal_saving') ?? '') ?? 0;
    final expenseGoal =
        double.tryParse(prefs.getString('goal_limit') ?? '') ?? 0;

    final state = UserFinanceState(
      totalIncome: sumIncome,
      totalExpense: sumExpense,
      savedGoal: savedGoal,
      expenseGoal: expenseGoal,
    );
    await _saveFinanceState(prefs, state);
    return state;
  }

  Future<void> updateGoals(double savedGoal, double expenseGoal) async {
    final prefs = await SharedPreferences.getInstance();
    final current = await getFinanceState();
    final updated = UserFinanceState(
      totalIncome: current.totalIncome,
      totalExpense: current.totalExpense,
      savedGoal: savedGoal,
      expenseGoal: expenseGoal,
    );
    await _saveFinanceState(prefs, updated);

    await prefs.setString('goal_saving', savedGoal.toStringAsFixed(0));
    await prefs.setString('goal_limit', expenseGoal.toStringAsFixed(0));
  }

  Future<void> _saveFinanceState(
    SharedPreferences prefs,
    UserFinanceState state,
  ) async {
    await prefs.setString(_kFinanceStateKey, jsonEncode(state.toJson()));
  }
}
