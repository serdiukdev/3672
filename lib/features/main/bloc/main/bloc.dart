import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/services/finance_repository.dart';
import '../../../../core/services/storage_service.dart';
import 'event.dart';
import 'state.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  final StorageService storage;
  final FinanceRepository _repo = FinanceRepository();

  MainBloc({required this.storage}) : super(const MainState()) {
    on<MainStarted>((event, emit) async {
      emit(state.copyWith(loading: true));
      await storage.setFirstOpening(false);

      final savingStr = storage.getSavingGoal() ?? '0';
      final limitStr = storage.getLimitGoal() ?? '0';

      final finance = await _repo.getFinanceState();
      final savingGoal = double.tryParse(savingStr) ?? finance.savedGoal;
      final balance = finance.currentBalance;
      double percent = 0;
      if (savingGoal > 0) {
        percent = (balance / savingGoal).clamp(0, 1);
      }
      final pct100 = percent * 100;
      int fillLevelIndex = 0;
      if (pct100 > 0 && pct100 <= 15) {
        fillLevelIndex = 0;
      } else if (pct100 > 15 && pct100 <= 50) {
        fillLevelIndex = 1;
      } else if (pct100 > 50 && pct100 <= 65) {
        fillLevelIndex = 2;
      } else if (pct100 > 65 && pct100 < 100) {
        fillLevelIndex = 3;
      } else if (pct100 >= 100) {
        fillLevelIndex = 4;
      } else {
        fillLevelIndex = 5;
      }

      final prefs = await SharedPreferences.getInstance();
      final achievedStored = prefs.getBool('goal_achieved') ?? false;
      bool goalAchieved = achievedStored;
      bool justAchieved = false;

      if (savingGoal > 0 && balance >= savingGoal && !achievedStored) {
        final currentCoins = storage.getBalance();
        final newCoins = currentCoins + 500;
        await storage.setBalance(newCoins);
        await prefs.setBool('goal_achieved', true);
        goalAchieved = true;
        justAchieved = true;
      }

      emit(
        state.copyWith(
          savingGoal: savingStr,
          limitGoal: limitStr,
          savingPercent: percent,
          fillLevelIndex: fillLevelIndex,
          goalAchieved: goalAchieved,
          justAchieved: justAchieved,
          loading: false,
        ),
      );
    });
  }
}
