import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/storage_service.dart';
import 'event.dart';
import 'state.dart';
import '../../models/onboarding.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  final List<dynamic> _questions = List<dynamic>.from(
    onboardingData["questions"] as List,
  );
  final StorageService storageService;
  int _index = 0;

  OnboardingBloc({required this.storageService}) : super(PreOnboardingState()) {
    on<StartQuiz>((event, emit) {
      _index = 0;
      emit(
        QuizQuestionState(
          index: _index,
          question: _questions[_index] as Map<String, dynamic>,
        ),
      );
    });

    on<SelectAnswer>((event, emit) async {
      final q = _questions[_index] as Map<String, dynamic>;
      emit(
        QuizQuestionState(
          index: _index,
          question: q,
          selectedId: event.selectedId,
        ),
      );
      await Future.delayed(const Duration(milliseconds: 500));
      emit(
        QuizAnswerState(
          index: _index,
          question: q,
          selectedId: event.selectedId,
        ),
      );
    });

    on<NextQuestion>((event, emit) {
      if (_index + 1 < _questions.length) {
        _index += 1;
        emit(
          QuizQuestionState(
            index: _index,
            question: _questions[_index] as Map<String, dynamic>,
          ),
        );
      } else {
        emit(PostOnboardingState());
      }
    });

    on<UpdateGoalType>((event, emit) {
      final s = state is PostOnboardingState
          ? state as PostOnboardingState
          : PostOnboardingState();
      emit(s.copyWith(goalType: event.type));
    });

    on<UpdateGoalAmount>((event, emit) {
      final s = state is PostOnboardingState
          ? state as PostOnboardingState
          : PostOnboardingState();
      emit(s.copyWith(goalAmount: event.amount));
    });

    on<UpdateLimitAmount>((event, emit) {
      final s = state is PostOnboardingState
          ? state as PostOnboardingState
          : PostOnboardingState();
      emit(s.copyWith(limitAmount: event.amount));
    });

    on<SaveGoal>((event, emit) async {
      final s = state is PostOnboardingState
          ? state as PostOnboardingState
          : PostOnboardingState();
      // Persist goals if provided
      if ((s.goalAmount ?? '').isNotEmpty) {
        await storageService.setSavingGoal(s.goalAmount!);
      }
      if ((s.limitAmount ?? '').isNotEmpty) {
        await storageService.setLimitGoal(s.limitAmount!);
      }
      await storageService.setOnboardingCompleted(true);
      emit(s.copyWith(saved: true));
    });
  }
}
