class MainState {
  final String savingGoal;
  final String limitGoal;
  final bool loading;
  final int tabIndex;
  final double savingPercent;
  final int fillLevelIndex;
  final bool goalAchieved;
  final bool justAchieved;

  const MainState({
    this.savingGoal = '0',
    this.limitGoal = '0',
    this.loading = true,
    this.tabIndex = 2,
    this.savingPercent = 0,
    this.fillLevelIndex = 0,
    this.goalAchieved = false,
    this.justAchieved = false,
  });

  MainState copyWith({
    String? savingGoal,
    String? limitGoal,
    bool? loading,
    int? tabIndex,
    double? savingPercent,
    int? fillLevelIndex,
    bool? goalAchieved,
    bool? justAchieved,
  }) => MainState(
        savingGoal: savingGoal ?? this.savingGoal,
        limitGoal: limitGoal ?? this.limitGoal,
        loading: loading ?? this.loading,
        tabIndex: tabIndex ?? this.tabIndex,
        savingPercent: savingPercent ?? this.savingPercent,
        fillLevelIndex: fillLevelIndex ?? this.fillLevelIndex,
        goalAchieved: goalAchieved ?? this.goalAchieved,
        justAchieved: justAchieved ?? this.justAchieved,
      );
}
