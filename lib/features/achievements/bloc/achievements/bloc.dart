import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../repository/achievement_service.dart';
import 'state.dart';
import '../../models/achievements.dart';

class AchievementsBloc extends Cubit<AchievementsState> {
  static const String prefsKey = 'achievements_progress';

  AchievementsBloc() : super(AchievementsState.empty);

  Future<void> load() async {
    emit(state.copyWith(loading: true));
    final base = AchievementService.loadBaseForUI();
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(prefsKey);
    Map<String, dynamic> saved = {};
    if (raw != null && raw.isNotEmpty) {
      try {
        saved = jsonDecode(raw) as Map<String, dynamic>;
      } catch (_) {}
    }

    final merged = base.map((b) {
      final v = saved[b.id];
      if (v is Map<String, dynamic>) {
        final a = Achievement.fromPrefs(v, b);
        final completed = a.currentValue >= a.goalValue;
        return a.copyWith(isCompleted: completed);
      }
      return b;
    }).toList();

    emit(AchievementsState(loading: false, achievements: merged));
  }

  Future<void> increment(String id, [int by = 1]) async {
    final current = state.achievements;
    final idx = current.indexWhere((e) => e.id == id);
    if (idx < 0) return;
    final a = current[idx];
    await setProgress(id, a.currentValue + by);
  }

  Future<void> setProgress(String id, int value) async {
    final list = [...state.achievements];
    final idx = list.indexWhere((e) => e.id == id);
    if (idx < 0) return;
    final a = list[idx];
    final newVal = value < 0 ? 0 : value;
    final completed = newVal >= a.goalValue;
    list[idx] = a.copyWith(currentValue: newVal, isCompleted: completed);
    emit(state.copyWith(achievements: list));
    await _persist(list);
  }

  Future<void> complete(String id) async {
    final list = [...state.achievements];
    final idx = list.indexWhere((e) => e.id == id);
    if (idx < 0) return;
    final a = list[idx];
    list[idx] = a.copyWith(currentValue: a.goalValue, isCompleted: true);
    emit(state.copyWith(achievements: list));
    await _persist(list);
  }

  Future<void> _persist(List<Achievement> list) async {
    final prefs = await SharedPreferences.getInstance();
    final map = <String, Map<String, dynamic>>{
      for (final a in list) a.id: a.toPrefs(),
    };
    await prefs.setString(prefsKey, jsonEncode(map));
  }
}
