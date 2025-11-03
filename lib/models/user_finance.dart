class UserFinanceState {
  final double totalIncome;
  final double totalExpense;
  final double savedGoal; // target saving goal
  final double expenseGoal; // target spending goal

  const UserFinanceState({
    required this.totalIncome,
    required this.totalExpense,
    required this.savedGoal,
    required this.expenseGoal,
  });

  double get currentBalance => totalIncome - totalExpense;

  Map<String, dynamic> toJson() => {
        'totalIncome': totalIncome,
        'totalExpense': totalExpense,
        'savedGoal': savedGoal,
        'expenseGoal': expenseGoal,
      };

  factory UserFinanceState.fromJson(Map<String, dynamic> json) => UserFinanceState(
        totalIncome: (json['totalIncome'] as num?)?.toDouble() ?? 0,
        totalExpense: (json['totalExpense'] as num?)?.toDouble() ?? 0,
        savedGoal: (json['savedGoal'] as num?)?.toDouble() ?? 0,
        expenseGoal: (json['expenseGoal'] as num?)?.toDouble() ?? 0,
      );
}
