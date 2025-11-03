class SettingsState {
  final bool loading;
  final String? avatarPath;
  final bool soundEnabled;
  final bool notificationsEnabled;

  const SettingsState({
    required this.loading,
    required this.avatarPath,
    required this.soundEnabled,
    required this.notificationsEnabled,
  });

  SettingsState copyWith({
    bool? loading,
    String? avatarPath,
    bool? soundEnabled,
    bool? notificationsEnabled,
  }) => SettingsState(
        loading: loading ?? this.loading,
        avatarPath: avatarPath ?? this.avatarPath,
        soundEnabled: soundEnabled ?? this.soundEnabled,
        notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      );

  static const initial = SettingsState(
    loading: true,
    avatarPath: null,
    soundEnabled: true,
    notificationsEnabled: false,
  );

  @override
  String toString() =>
      'SettingsState(loading: ' 
      '$loading, avatarPath: $avatarPath, soundEnabled: $soundEnabled, notificationsEnabled: $notificationsEnabled)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SettingsState &&
        other.loading == loading &&
        other.avatarPath == avatarPath &&
        other.soundEnabled == soundEnabled &&
        other.notificationsEnabled == notificationsEnabled;
  }

  @override
  int get hashCode => Object.hash(
        loading,
        avatarPath,
        soundEnabled,
        notificationsEnabled,
      );
}
