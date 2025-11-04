import 'package:flutter/foundation.dart';

enum GoalType { saving, limit }

abstract class OnboardingState {}

class PreOnboardingState extends OnboardingState {}

class QuizQuestionState extends OnboardingState {
  final int index;
  final Map<String, dynamic> question;
  final String? selectedId;
  QuizQuestionState({required this.index, required this.question, this.selectedId});
}

class QuizAnswerState extends OnboardingState {
  final int index;
  final Map<String, dynamic> question;
  final String selectedId;
  QuizAnswerState({required this.index, required this.question, required this.selectedId});
}

class PostOnboardingState extends OnboardingState {
  final GoalType? goalType;
  final String? goalAmount;
  final String? limitAmount;
  final bool saved;
  PostOnboardingState({this.goalType, this.goalAmount, this.limitAmount, this.saved = false});
  PostOnboardingState copyWith({GoalType? goalType, String? goalAmount, String? limitAmount, bool? saved}) {
    return PostOnboardingState(
      goalType: goalType ?? this.goalType,
      goalAmount: goalAmount ?? this.goalAmount,
      limitAmount: limitAmount ?? this.limitAmount,
      saved: saved ?? this.saved,
    );
  }
}
