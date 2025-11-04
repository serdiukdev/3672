class DailyBonusState {
  final bool loading;
  final int balance;
  final int reward; // daily reward amount
  final Map<String, dynamic>? proverb; // selected daily proverb
  final bool creditedToday; // whether today's reward was just credited on open
  final String dateKey; // yyyy-MM-dd

  const DailyBonusState({
    this.loading = true,
    this.balance = 0,
    this.reward = 60,
    this.proverb,
    this.creditedToday = false,
    this.dateKey = '',
  });

  DailyBonusState copyWith({
    bool? loading,
    int? balance,
    int? reward,
    Map<String, dynamic>? proverb,
    bool? creditedToday,
    String? dateKey,
  }) => DailyBonusState(
    loading: loading ?? this.loading,
    balance: balance ?? this.balance,
    reward: reward ?? this.reward,
    proverb: proverb ?? this.proverb,
    creditedToday: creditedToday ?? this.creditedToday,
    dateKey: dateKey ?? this.dateKey,
  );
}
