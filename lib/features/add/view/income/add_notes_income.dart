import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:itd_2/core/services/app_navigator.dart';
import '../../../../core/constants/app_styles.dart';
import '../../../../core/constants/app_text.dart';
import '../../../../core/services/finance_repository.dart';
import '../../../../core/services/sound_service.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../shared/components/nav_bar.dart';
import '../../../main/view/main_screen.dart';
import '../../../settings/view/settings_screen.dart';
import '../../models/income.dart';
import 'choose_category_income.dart';

class DateTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    final buffer = StringBuffer();
    for (var i = 0; i < digits.length && i < 8; i++) {
      buffer.write(digits[i]);
      if (i == 1 || i == 3) buffer.write('-');
    }
    final text = buffer.toString();
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}

class AddNotesIncome extends StatefulWidget {
  static const routeName = 'incomeNotes';

  const AddNotesIncome({super.key});

  @override
  State<AddNotesIncome> createState() => _AddNotesIncomeState();
}

class _AddNotesIncomeState extends State<AddNotesIncome> {
  int _tab = 2;
  final _dateController = TextEditingController();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();
  final _dateFocus = FocusNode();
  final _amountFocus = FocusNode();
  final _notesFocus = FocusNode();
  final _storage = StorageService();

  @override
  void initState() {
    super.initState();
    _dateController.text = _storage.getDraftIncomeDate() ?? '';
    _amountController.text = _storage.getDraftIncomeAmount() ?? '';
    _notesController.text = _storage.getDraftIncomeDescription() ?? '';
    _dateFocus.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _dateController.dispose();
    _amountController.dispose();
    _notesController.dispose();
    _dateFocus.dispose();
    _amountFocus.dispose();
    _notesFocus.dispose();
    super.dispose();
  }

  bool _isValidDate(String s) {
    final m = RegExp(r'^(\d{2})-(\d{2})-(\d{4})$').firstMatch(s);
    if (m == null) return false;
    final d = int.tryParse(m.group(1)!) ?? 0;
    final mo = int.tryParse(m.group(2)!) ?? 0;
    final y = int.tryParse(m.group(3)!) ?? 0;
    if (mo < 1 || mo > 12) return false;
    if (d < 1) return false;
    final lastDay = DateTime(y, mo + 1, 0).day;
    if (d > lastDay) return false;
    return true;
  }

  Future<void> _save() async {
    final date = _dateController.text.trim();
    final amount = _amountController.text.trim();
    final description = _notesController.text.trim();

    final datePatternOk = RegExp(r'^\d{2}-\d{2}-\d{4}$').hasMatch(date);
    final dateOk = datePatternOk && _isValidDate(date);
    final amountOk = RegExp(r'^\d{1,6}$').hasMatch(amount);

    if (!dateOk || !amountOk) {
      // Simple validation: keep focus on the first invalid field
      if (!dateOk)
        _dateFocus.requestFocus();
      else
        _amountFocus.requestFocus();
      return;
    }

    final category = _storage.getSelectedIncomeCategory() ?? 'income';
    final subCategory = _storage.getSelectedIncomeSubCategory() ?? '';
    final amt = double.tryParse(amount.replaceAll(',', '.')) ?? 0;

    final income = Income.create(
      category: category,
      subCategory: subCategory,
      date: date,
      amount: amt,
      description: description.isEmpty ? null : description,
    );

    final repo = FinanceRepository();
    await repo.addIncome(income);
    await _storage.clearSelectedIncome();
    await _storage.clearDraftIncome();
    await SoundService().playAsset(
      'sounds/money-counting-machine-sfx-406495.mp3',
    );

    if (!mounted) return;
    context.pushNamedAndRemoveUntil(MainScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: () =>
                context.pushNamedAndRemoveUntil(SettingsScreen.routeName),
            icon: Image.asset('assets/general_buttons/setting_icon.webp'),
          ),
        ],
        leading: IconButton(
          onPressed: () =>
              context.pushNamedAndRemoveUntil(ChooseCategoryIncome.routeName),
          icon: Image.asset('assets/general_buttons/back_icon.webp'),
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _tab,
        onTap: (index) {
          setState(() => _tab = index);
        },
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bg_in_game/bg_1.webp'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    Container(
                      height: size.height * 0.40,
                      width: size.width * 0.80,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                            'assets/bg_components/add_income_bg.webp',
                          ),
                          fit: BoxFit.fill,
                        ),
                      ),
                      child: Column(
                        //date
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: size.height * 0.08,
                            width: size.width * 0.7,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(
                                  'assets/bg_components/add_sum.webp',
                                ),
                                fit: BoxFit.fill,
                              ),
                            ),
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: TextField(
                              controller: _dateController,
                              focusNode: _dateFocus,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(10),
                                DateTextInputFormatter(),
                              ],
                              textAlign: TextAlign.center,
                              style: AppStyles.statList,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: _dateFocus.hasFocus
                                    ? ''
                                    : 'dd-mm-yyyy',
                                hintStyle: AppStyles.statList,
                                counterText: '',
                              ),
                              onChanged: (v) => _storage.setDraftIncomeDate(v),
                            ),
                          ),
                          SizedBox(height: 5),

                          Container(
                            height: size.height * 0.08,
                            width: size.width * 0.7,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(
                                  'assets/bg_components/add_sum.webp',
                                ),
                                fit: BoxFit.fill,
                              ),
                            ),
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: TextField(
                              controller: _amountController,
                              focusNode: _amountFocus,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(6),
                              ],
                              textAlign: TextAlign.center,
                              style: AppStyles.statList,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: '0',
                                hintStyle: AppStyles.statList,
                                counterText: '',
                              ),
                              onChanged: (v) =>
                                  _storage.setDraftIncomeAmount(v),
                            ),
                          ),

                          SizedBox(height: 15),
                          Container(
                            height: size.height * 0.12,
                            width: size.width * 0.7,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(
                                  'assets/bg_components/add_notes.webp',
                                ),
                                fit: BoxFit.fill,
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 14,
                            ),
                            child: TextField(
                              controller: _notesController,
                              focusNode: _notesFocus,
                              keyboardType: TextInputType.text,
                              maxLength: 45,
                              maxLines: 2,
                              style: AppStyles.statList,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: AppTexts.notes,
                                hintStyle: AppStyles.statList,
                                counterText: '',
                              ),
                              onChanged: (v) =>
                                  _storage.setDraftIncomeDescription(v),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: size.height * 0.08),

                    Center(
                      child: GestureDetector(
                        onTap: _save,
                        child: Image.asset(
                          'assets/general_buttons/save_button.webp',
                          height: size.height * 0.08,
                          width: size.width * 0.3,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
