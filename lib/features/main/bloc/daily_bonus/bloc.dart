import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/storage_service.dart';
import '../../models/daily_bonus.dart';
import 'event.dart';
import 'state.dart';

class DailyBonusBloc extends Bloc<DailyBonusEvent, DailyBonusState> {
  final StorageService storage;

  DailyBonusBloc({required this.storage}) : super(const DailyBonusState()) {
    on<DailyBonusStarted>((event, emit) async {
      final now = DateTime.now();
      final dateKey =
          "${now.year.toString().padLeft(4, '0')}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

      // Ensure we always show a proverb for the day (deterministic per day)
      final List proverbs = dailyBonusData['proverbs'] as List;
      int? storedIdx;
      final storedDate = storage.getBonusDate();
      if (storedDate == dateKey) {
        storedIdx = storage.getBonusIndex();
      }
      storedIdx ??= Random(dateKey.hashCode).nextInt(proverbs.length);
      storage.setBonusDate(dateKey);
      storage.setBonusIndex(storedIdx);
      final Map<String, dynamic> proverb = Map<String, dynamic>.from(
        proverbs[storedIdx] as Map,
      );

      // Balance and reward logic
      int balance = storage.getBalance();
      bool credited = false;
      final lastClaim = storage.getLastClaimDate();
      const reward = 60;
      if (lastClaim != dateKey) {
        balance += reward;
        await storage.setBalance(balance);
        await storage.setLastClaimDate(dateKey);
        credited = true;
      }
      await storage.setLastOpenDate(dateKey);

      emit(
        state.copyWith(
          loading: false,
          balance: balance,
          reward: reward,
          proverb: proverb,
          creditedToday: credited,
          dateKey: dateKey,
        ),
      );
    });
  }
}
