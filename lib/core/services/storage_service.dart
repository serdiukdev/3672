import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  bool getSoundEnabled() => _prefs.getBool('sound_enabled') ?? true;
  Future<void> setSoundEnabled(bool enabled) => _prefs.setBool('sound_enabled', enabled);

  bool getVibrationEnabled() => _prefs.getBool('vibration_enabled') ?? true;
  Future<void> setVibrationEnabled(bool enabled) => _prefs.setBool('vibration_enabled', enabled);

  // Onboarding
  bool isOnboardingCompleted() => _prefs.getBool('onboarding_completed') ?? false;
  Future<void> setOnboardingCompleted(bool completed) => _prefs.setBool('onboarding_completed', completed);

  String? getSavingGoal() => _prefs.getString('goal_saving');
  Future<void> setSavingGoal(String value) => _prefs.setString('goal_saving', value);

  String? getLimitGoal() => _prefs.getString('goal_limit');
  Future<void> setLimitGoal(String value) => _prefs.setString('goal_limit', value);

  // Balance
  int getBalance() => _prefs.getInt('balance') ?? 500;
  Future<void> setBalance(int value) => _prefs.setInt('balance', value);

  bool isFirstOpening() => _prefs.getBool('is_first_opening') ?? true;
  Future<void> setFirstOpening(bool value) => _prefs.setBool('is_first_opening', value);

  // Daily bonus dates
  String? getLastClaimDate() => _prefs.getString('daily_last_claim_date');
  Future<void> setLastClaimDate(String date) => _prefs.setString('daily_last_claim_date', date);

  String? getLastOpenDate() => _prefs.getString('daily_last_open_date');
  Future<void> setLastOpenDate(String date) => _prefs.setString('daily_last_open_date', date);

  int getLoginStreak() => _prefs.getInt('login_streak') ?? 0;
  Future<void> setLoginStreak(int value) => _prefs.setInt('login_streak', value);

  String? getBonusDate() => _prefs.getString('daily_bonus_date');
  Future<void> setBonusDate(String date) => _prefs.setString('daily_bonus_date', date);

  int? getBonusIndex() => _prefs.getInt('daily_bonus_index');
  Future<void> setBonusIndex(int index) => _prefs.setInt('daily_bonus_index', index);

  String? getSelectedIncomeCategory() => _prefs.getString('selected_income_category');
  Future<void> setSelectedIncomeCategory(String value) => _prefs.setString('selected_income_category', value);

  String? getSelectedIncomeSubCategory() => _prefs.getString('selected_income_subcategory');
  Future<void> setSelectedIncomeSubCategory(String value) => _prefs.setString('selected_income_subcategory', value);

  Future<void> clearSelectedIncome() async {
    await _prefs.remove('selected_income_category');
    await _prefs.remove('selected_income_subcategory');
  }

  String? getDraftIncomeDate() => _prefs.getString('draft_income_date');
  Future<void> setDraftIncomeDate(String value) => _prefs.setString('draft_income_date', value);

  String? getDraftIncomeAmount() => _prefs.getString('draft_income_amount');
  Future<void> setDraftIncomeAmount(String value) => _prefs.setString('draft_income_amount', value);

  String? getDraftIncomeDescription() => _prefs.getString('draft_income_description');
  Future<void> setDraftIncomeDescription(String value) => _prefs.setString('draft_income_description', value);

  Future<void> clearDraftIncome() async {
    await _prefs.remove('draft_income_date');
    await _prefs.remove('draft_income_amount');
    await _prefs.remove('draft_income_description');
  }

  // Expense selection and drafts
  String? getSelectedExpenseCategory() => _prefs.getString('selected_expense_category');
  Future<void> setSelectedExpenseCategory(String value) => _prefs.setString('selected_expense_category', value);

  String? getSelectedExpenseSubCategory() => _prefs.getString('selected_expense_subcategory');
  Future<void> setSelectedExpenseSubCategory(String value) => _prefs.setString('selected_expense_subcategory', value);

  Future<void> clearSelectedExpense() async {
    await _prefs.remove('selected_expense_category');
    await _prefs.remove('selected_expense_subcategory');
  }

  String? getDraftExpenseDate() => _prefs.getString('draft_expense_date');
  Future<void> setDraftExpenseDate(String value) => _prefs.setString('draft_expense_date', value);

  String? getDraftExpenseAmount() => _prefs.getString('draft_expense_amount');
  Future<void> setDraftExpenseAmount(String value) => _prefs.setString('draft_expense_amount', value);

  String? getDraftExpenseDescription() => _prefs.getString('draft_expense_description');
  Future<void> setDraftExpenseDescription(String value) => _prefs.setString('draft_expense_description', value);

  Future<void> clearDraftExpense() async {
    await _prefs.remove('draft_expense_date');
    await _prefs.remove('draft_expense_amount');
    await _prefs.remove('draft_expense_description');
  }

  List<String> _getIncomeEntriesRaw() => _prefs.getStringList('income_entries') ?? <String>[];
  Future<void> _setIncomeEntriesRaw(List<String> entries) => _prefs.setStringList('income_entries', entries);

  Future<void> finalizeAndSaveIncome({
    required String date,
    required String amount,
    required String description,
  }) async {
    final category = getSelectedIncomeCategory() ?? 'income';
    final subCategory = getSelectedIncomeSubCategory() ?? '';
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final amt = double.tryParse(amount.replaceAll(',', '.'));
    final entry = {
      'id': id,
      'category': category,
      'subCategory': subCategory,
      'date': date,
      'amount': amt,
      'description': description,
    };
    final list = _getIncomeEntriesRaw();
    list.add(jsonEncode(entry));
    await _setIncomeEntriesRaw(list);
    await clearSelectedIncome();
    await clearDraftIncome();
  }
}