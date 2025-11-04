import '../../models/achievements.dart';

class AchievementsState {
  final bool loading;
  final List<Achievement> achievements;

  const AchievementsState({required this.loading, required this.achievements});

  AchievementsState copyWith({
    bool? loading,
    List<Achievement>? achievements,
  }) => AchievementsState(
    loading: loading ?? this.loading,
    achievements: achievements ?? this.achievements,
  );

  static const empty = AchievementsState(loading: true, achievements: []);
}
