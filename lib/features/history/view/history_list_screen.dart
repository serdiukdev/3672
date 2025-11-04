import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:itd_2/core/services/app_navigator.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_styles.dart';
import '../../../shared/components/nav_bar.dart';
import '../bloc/history/bloc.dart';
import '../bloc/history/state.dart';
import 'choose_month_history.dart';
import 'history_screen_main.dart';

class HistoryListScreen extends StatefulWidget {
  static const routeName = 'history_list';
  final String mode;

  const HistoryListScreen({super.key, required this.mode});

  @override
  State<HistoryListScreen> createState() => _HistoryListScreenState();
}

class _HistoryListScreenState extends State<HistoryListScreen> {
  int _tab = 3;
  late final HistoryBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = HistoryBloc(mode: widget.mode);
    Future.microtask(() async {
      await _bloc.getSelectedPeriod();
      await _bloc.loadEntries();
    });
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  void _openPicker() {
    context.pushNamedAndRemoveUntil(
      ChooseMonthHistory.routeName,
      arguments: widget.mode,
    );
  }

  void _showEntryPopup(BuildContext context, HistoryEntry e) {
    final size = MediaQuery.of(context).size;
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: AppColors.mainBlack.withOpacity(0.5),
      builder: (_) => Center(
        child: Container(
          width: size.width * 0.9,
          height: size.height * 0.45,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                e.category == 'expense'
                    ? 'assets/bg_components/stat_expense_bg.webp'
                    : 'assets/bg_components/stat_income_bg.webp',
              ),
              fit: BoxFit.fill,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: size.height * 0.03),
              Container(
                height: size.height * 0.1,
                width: size.width * 0.55,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      e.category == 'expense'
                          ? 'assets/bg_components/expense_popup.webp'
                          : 'assets/bg_components/income_popup.webp',
                    ),
                    fit: BoxFit.fill,
                  ),
                ),
                child: Center(
                  child: Text(
                    e.subCategory.toUpperCase(),
                    style: AppStyles.categoryItem.copyWith(fontSize: 25),
                  ),
                ),
              ),
              const SizedBox(height: 3),
              Center(
                child: Text(
                  e.date,
                  style: AppStyles.statList.copyWith(
                    color: AppColors.popupYellowText,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Center(
                child: Text(
                  '${e.category == 'expense' ? '-' : '+'}${e.amount.toStringAsFixed(2)}',
                  style: AppStyles.statList.copyWith(fontSize: 20),
                ),
              ),
              const SizedBox(height: 8),
              if ((e.description ?? '').isNotEmpty)
                Container(
                  padding: EdgeInsets.all(8),
                  height: size.height * 0.15,
                  width: size.width * 0.75,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/bg_components/add_notes.webp'),
                      fit: BoxFit.fill,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      e.description ?? '',
                      style: AppStyles.statList,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
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
            onPressed: _openPicker,
            icon: Image.asset('assets/general_buttons/select_icon.webp'),
          ),
        ],
        leading: IconButton(
          onPressed: () =>
              context.pushNamedAndRemoveUntil(HistoryMain.routeName),
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
        width: size.width,
        height: size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bg_in_game/bg_1.webp'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: BlocBuilder<HistoryBloc, HistoryState>(
            bloc: _bloc,
            builder: (context, state) {
              if (state.loading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state.sortedDatesDesc.isEmpty) {
                return Center(
                  child: Text(
                    'No ${widget.mode} entries for selected period',
                    style: AppStyles.categoryItem,
                    textAlign: TextAlign.center,
                  ),
                );
              }
              final accent = state.accentColor;
              return Container(
                height: size.height * 0.85,
                width: size.width * 0.75,
                padding: EdgeInsets.all(24),
                margin: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: state.mode == 'expense'
                        ? AssetImage(
                            'assets/bg_components/stat_expense_bg.webp',
                          )
                        : AssetImage(
                            'assets/bg_components/stat_income_bg.webp',
                          ),
                    fit: BoxFit.fill,
                  ),
                ),
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 18,
                  ),
                  itemCount: state.sortedDatesDesc.length,
                  itemBuilder: (_, idx) {
                    final date = state.sortedDatesDesc[idx];
                    final items =
                        state.groupedByDate[date] ?? const <HistoryEntry>[];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 3,
                            horizontal: 12,
                          ),
                          decoration: BoxDecoration(
                            color: accent.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              date,
                              style: AppStyles.statList.copyWith(
                                color: AppColors.popupYellowText,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 3),
                        ...items.map(
                          (e) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: InkWell(
                              onTap: () => _showEntryPopup(context, e),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          'assets/general_buttons/history_icon.webp',
                                        ),
                                        SizedBox(width: 5),
                                        SizedBox(
                                          width: size.width * 0.4,
                                          child: Text(
                                            e.description?.isNotEmpty == true
                                                ? e.description!
                                                : e.subCategory,
                                            style: AppStyles.statList.copyWith(
                                              color: AppColors.popupYellowText,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    (state.mode == 'expense' ? '-' : '+') +
                                        e.amount.toStringAsFixed(0),
                                    style: AppStyles.statList.copyWith(
                                      color: AppColors.popupYellowText,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        //   ),
                        const SizedBox(height: 12),
                      ],
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
