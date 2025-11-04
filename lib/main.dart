import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import './core/services/app_navigator.dart';
import './core/services/sound_service.dart';
import './core/services/storage_service.dart';
import './features/main/view/loading/loading_screen.dart';
import './features/onboarding/bloc/onboarding/bloc.dart';
import './features/main/bloc/main/bloc.dart';
import './features/main/bloc/daily_bonus/bloc.dart';

import './core/constants/app_colors.dart';
import './core/constants/app_text.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  final storageService = StorageService();
  await storageService.init();

  // Initialize SoundService with saved settings
  final soundService = SoundService();
  await soundService.init();

  runApp(MyApp(storageService: storageService));
}

class MyApp extends StatelessWidget {
  final StorageService storageService;
  const MyApp({super.key, required this.storageService});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => OnboardingBloc(storageService: storageService)),
        BlocProvider(create: (_) => MainBloc(storage: storageService)),
        BlocProvider(create: (_) => DailyBonusBloc(storage: storageService)),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: Platform.isAndroid
            ? AppTexts.appAndroidTitle
            : AppTexts.appIosTitle,
        theme: ThemeData(
          primarySwatch: Colors.brown,
          scaffoldBackgroundColor: AppColors.mainBLue,
          fontFamily: 'Knewave',
        ),
        initialRoute: LoadingScreen.routeName,
        onGenerateRoute: AppNavigator.generateRoutes,
      ),
    );
  }
}

