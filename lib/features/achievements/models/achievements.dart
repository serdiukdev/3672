import 'dart:convert';

class AchievementBase {
  final String title;
  final String description;
  const AchievementBase({required this.title, required this.description});
}

class Achievement {
  final String id;
  final String title;
  final String description;
  final int goalValue;
  final int currentValue;
  final bool isCompleted;

  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.goalValue,
    required this.currentValue,
    required this.isCompleted,
  });

  Achievement copyWith({
    int? goalValue,
    int? currentValue,
    bool? isCompleted,
  }) => Achievement(
        id: id,
        title: title,
        description: description,
        goalValue: goalValue ?? this.goalValue,
        currentValue: currentValue ?? this.currentValue,
        isCompleted: isCompleted ?? this.isCompleted,
      );

  static String idFromTitle(String title) =>
      title
          .trim()
          .toLowerCase()
          .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
          .replaceAll(RegExp(r'_+'), '_')
          .replaceAll(RegExp(r'^_|_$'), '');

  static int goalFromDescription(String description, {int fallback = 1}) {
    final m = RegExp(r'(\d+)').firstMatch(description);
    if (m != null) return int.tryParse(m.group(1)!) ?? fallback;
    return fallback;
  }

  Map<String, dynamic> toPrefs() => {
        'id': id,
        'goalValue': goalValue,
        'currentValue': currentValue,
        'isCompleted': isCompleted,
      };

  factory Achievement.fromPrefs(Map<String, dynamic> json, Achievement base) => Achievement(
        id: base.id,
        title: base.title,
        description: base.description,
        goalValue: (json['goalValue'] as num?)?.toInt() ?? base.goalValue,
        currentValue: (json['currentValue'] as num?)?.toInt() ?? base.currentValue,
        isCompleted: (json['isCompleted'] as bool?) ?? base.isCompleted,
      );

  static Map<String, dynamic> decodePrefs(String raw) {
    try {
      return jsonDecode(raw) as Map<String, dynamic>;
    } catch (_) {
      return {};
    }
  }

  static String encodePrefs(Map<String, dynamic> m) => jsonEncode(m);

  static Achievement fromBase(AchievementBase b) {
    final id = idFromTitle(b.title);
    final goal = goalFromDescription(b.description, fallback: 1);
    return Achievement(
      id: id,
      title: b.title,
      description: b.description,
      goalValue: goal,
      currentValue: 0,
      isCompleted: false,
    );
  }
}
