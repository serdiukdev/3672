import 'package:flutter/material.dart';
import 'package:itd_2/constants/app_colors.dart';
import 'package:itd_2/services/app_navigator.dart';
import 'package:itd_2/view/add/add_screen.dart';
import '../../../constants/app_styles.dart';
import '../../../general_components/nav_bar.dart';
import '../../settings/settings_screen.dart';
import 'add_notes_income.dart';
import 'package:itd_2/services/storage_service.dart';

class ChooseCategoryIncome extends StatefulWidget {
  static const routeName = 'categoryIncome';

  const ChooseCategoryIncome({super.key});

  @override
  State<ChooseCategoryIncome> createState() => _ChooseCategoryIncomeState();
}

class _ChooseCategoryIncomeState extends State<ChooseCategoryIncome> {
  int _tab = 2;

  void _onCategoryTap(String subCategory) async {
    final storage = StorageService();
    await storage.setSelectedIncomeCategory('income');
    await storage.setSelectedIncomeSubCategory(subCategory);
    if (!mounted) return;
    context.pushNamedAndRemoveUntil(AddNotesIncome.routeName);
  }

  @override
  Widget build(BuildContext context) {
    const categories = <String>[
      'Salary',
      'Investments',
      'Part_Time',
      'Bonus',
      'Other',
    ];

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Image.asset('assets/general_buttons/back_icon.webp'),
          onPressed: () => context.pushNamedAndRemoveUntil(AddScreen.routeName),
        ),
        actions: [
          IconButton(
            icon: Image.asset('assets/general_buttons/setting_icon.webp'),
            onPressed:
                () => context.pushNamedAndRemoveUntil(SettingsScreen.routeName),
          ),
        ],
      ),
      bottomNavigationBar: GameNavBar(
        currentIndex: _tab,
        onTap: (index) => setState(() => _tab = index),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bg_in_game/bg_1.webp'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Container(
                  width: double.infinity,
                  // padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 6),
                  decoration: BoxDecoration(color: AppColors.topGreenBg),
                  child: Center(child: Text('INCOME', style: AppStyles.categoryItem)),
                ),
              ),
              SizedBox(height: 20,),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: GridView.builder(
                    itemCount: categories.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 1.1,
                        ),
                    itemBuilder: (context, index) {
                      final title = categories[index];
                      return InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () => _onCategoryTap(title),
                        child: Container(
                          decoration: BoxDecoration(
                            image: const DecorationImage(
                              image: AssetImage(
                                'assets/bg_components/income_item_bg.webp',
                              ),
                              fit: BoxFit.contain,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            title.toUpperCase(),
                            style: AppStyles.categoryItem.copyWith(
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
