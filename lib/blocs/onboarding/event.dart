import 'state.dart';

abstract class OnboardingEvent {}

class StartQuiz extends OnboardingEvent {}

class SelectAnswer extends OnboardingEvent {
  final int index;
  final String selectedId;
  SelectAnswer({required this.index, required this.selectedId});
}

class NextQuestion extends OnboardingEvent {}

class UpdateGoalType extends OnboardingEvent {
  final GoalType type;
  UpdateGoalType(this.type);
}

class UpdateGoalAmount extends OnboardingEvent {
  final String amount;
  UpdateGoalAmount(this.amount);
}

class UpdateLimitAmount extends OnboardingEvent {
  final String amount;
  UpdateLimitAmount(this.amount);
}

class SaveGoal extends OnboardingEvent {}
