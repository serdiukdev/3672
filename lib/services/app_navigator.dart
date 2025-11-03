
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import '../view/achievements/achievemets_screen.dart';
import '../view/add/add_screen.dart';
import '../view/add/expense/add_notes_expense.dart';
import '../view/add/expense/choose_category_expense.dart';
import '../view/add/income/add_notes_income.dart';
import '../view/add/income/choose_category_income.dart';
import '../view/history/choose_month_history.dart';
import '../view/history/choose_period_history.dart';
import '../view/history/history_list_screen.dart';
import '../view/history/history_screen_main.dart';
import '../view/loading/loading_screen.dart';
import '../view/main/daily_bonus/daily_bonus_screen.dart';
import '../view/main/main_screen.dart';
import '../view/onboarding/pre_onboarding_screen.dart';
import '../view/onboarding/onboarding_quiz.dart';
import '../view/onboarding/post_onboarding.dart';
import '../view/settings/privacy_screen.dart';
import '../view/settings/settings_screen.dart';
import '../view/settings/terms_screen.dart';
import '../view/shop/shop_screen.dart';
import '../view/statistic/choose_month_screen.dart';
import '../view/statistic/choose_period_screen.dart';
import '../view/statistic/result_statistic_screen.dart';
import '../view/statistic/statistic_screen.dart';


sealed class AppNavigator {
  const AppNavigator._();

  static Route<dynamic> generateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return PageTransition(
          child: const LoadingScreen(),
          opaque: false,
          duration: Durations.medium2,
          type: PageTransitionType.fade,
        );

      case LoadingScreen.routeName:
        return PageTransition(
          child: const LoadingScreen(),
          opaque: false,
          duration: Durations.medium2,
          type: PageTransitionType.fade,
        );

      case PreOnboardingScreen.routeName:
        return PageTransition(
          child: const PreOnboardingScreen(),
          opaque: false,
          duration: Durations.medium2,
          type: PageTransitionType.fade,
        );

      case OnboardingQuiz.routeName:
        return PageTransition(
          child: const OnboardingQuiz(),
          opaque: false,
          duration: Durations.medium2,
          type: PageTransitionType.fade,
        );

      case PostOnboardingScreen.routeName:
        return PageTransition(
          child: const PostOnboardingScreen(),
          opaque: false,
          duration: Durations.medium2,
          type: PageTransitionType.fade,
        );

      case MainScreen.routeName:
        return PageTransition(
          child: const MainScreen(),
          opaque: false,
          duration: Durations.medium2,
          type: PageTransitionType.fade,
        );


      case DailyBonusScreen.routeName:
        return PageTransition(
          child: const DailyBonusScreen(),
          opaque: false,
          duration: Durations.medium2,
          type: PageTransitionType.fade,
        );

      case AddScreen.routeName:
        return PageTransition(
          child: AddScreen(),
          opaque: false,
          duration: Durations.medium2,
          type: PageTransitionType.fade,
        );

      case ShopScreen.routeName:
        return PageTransition(
          child: const ShopScreen(),
          opaque: false,
          duration: Durations.medium2,
          type: PageTransitionType.fade,
        );

        case AchievementsScreen.routeName:
        return PageTransition(
          child: const AchievementsScreen(),
          opaque: false,
          duration: Durations.medium2,
          type: PageTransitionType.fade,
        );

      case HistoryMain.routeName:
        return PageTransition(
          child: const HistoryMain(),
          opaque: false,
          duration: Durations.medium2,
          type: PageTransitionType.fade,
        );

      case HistoryListScreen.routeName:
        {
          final arg = settings.arguments;
          final mode = (arg is String && (arg == 'income' || arg == 'expense')) ? arg : 'expense';
          return PageTransition(
            child: HistoryListScreen(mode: mode),
            opaque: false,
            duration: Durations.medium2,
            type: PageTransitionType.fade,
          );
        }

      case ChooseMonthHistory.routeName:
        {
          final arg = settings.arguments;
          final mode = (arg is String && (arg == 'income' || arg == 'expense')) ? arg : 'expense';
          return PageTransition(
            child: ChooseMonthHistory(mode: mode),
            opaque: false,
            duration: Durations.medium2,
            type: PageTransitionType.fade,
          );
        }

      case ChoosePeriodHistory.routeName:
        {
          final arg = settings.arguments;
          final mode = (arg is String && (arg == 'income' || arg == 'expense')) ? arg : 'expense';
          return PageTransition(
            child: ChoosePeriodHistory(mode: mode),
            opaque: false,
            duration: Durations.medium2,
            type: PageTransitionType.fade,
          );
        }

        case StatisticScreen.routeName:
        return PageTransition(
          child: const StatisticScreen(),
          opaque: false,
          duration: Durations.medium2,
          type: PageTransitionType.fade,
        );
      case ChooseMonthScreen.routeName:
        return PageTransition(
          child: const ChooseMonthScreen(),
          opaque: false,
          duration: Durations.medium2,
          type: PageTransitionType.fade,
        );
      case ChoosePeriodScreen.routeName:
        return PageTransition(
          child: const ChoosePeriodScreen(),
          opaque: false,
          duration: Durations.medium2,
          type: PageTransitionType.fade,
        );
      case ResultStatisticScreen.routeName:
        return PageTransition(
          child: const ResultStatisticScreen(),
          opaque: false,
          duration: Durations.medium2,
          type: PageTransitionType.fade,
        );

        case ChooseCategoryIncome.routeName:
        return PageTransition(
          child: const ChooseCategoryIncome(),
          opaque: false,
          duration: Durations.medium2,
          type: PageTransitionType.fade,
        );

      case AddNotesIncome.routeName:
        return PageTransition(
          child: AddNotesIncome(),
          opaque: false,
          duration: Durations.medium2,
          type: PageTransitionType.fade,
        );

      case ChooseCategoryExpense.routeName:
        return PageTransition(
          child: const ChooseCategoryExpense(),
          opaque: false,
          duration: Durations.medium2,
          type: PageTransitionType.fade,
        );

      case AddNotesExpense.routeName:
        return PageTransition(
          child: AddNotesExpense(),
          opaque: false,
          duration: Durations.medium2,
          type: PageTransitionType.fade,
        );

      case SettingsScreen.routeName:
        return PageTransition(
          child: const SettingsScreen(),
          opaque: false,
          duration: Durations.medium2,
          type: PageTransitionType.fade,
        );

      case TermsOfUse.routeName:
        return PageTransition(
          child: const TermsOfUse(),
          opaque: false,
          duration: Durations.medium2,
          type: PageTransitionType.fade,
        );

      case PrivacyPolicy.routeName:
        return PageTransition(
          child: const PrivacyPolicy(),
          opaque: false,
          duration: Durations.medium2,
          type: PageTransitionType.fade,
        );


//
//       case ShopScreen.routeName:
//         return PageTransition(
//           child: ShopScreen(),
//           opaque: false,
//           duration: Durations.medium2,
//           type: PageTransitionType.fade,
//         );
//
      default:
        throw Exception('Invalid route: ${settings.name}');
    }
  }
}

extension NavigationExtension on BuildContext {
  void pop<T extends Object?>([T? result]) {
    Navigator.of(this).pop(result);
  }

  Future<T?> push<T extends Object?>(String routeName, {Object? arguments}) {
    return Navigator.of(this).pushNamed<T>(routeName, arguments: arguments);
  }

  Future<T?> pushNamedAndRemoveUntil<T extends Object?>(
      String routeName, {
        Object? arguments,
        bool Function(Route<dynamic>)? predicate,
      }) {
    return Navigator.of(this).pushNamedAndRemoveUntil<T>(
      routeName,
      predicate ?? (route) => false,
      arguments: arguments,
    );
  }
 }
