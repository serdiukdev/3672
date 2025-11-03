import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:itd_2/services/app_navigator.dart';
import 'package:itd_2/services/sound_service.dart';
import 'package:itd_2/services/storage_service.dart';
import 'package:itd_2/view/loading/loading_screen.dart';
import 'blocs/onboarding/bloc.dart';
import 'blocs/main/bloc.dart';
import 'blocs/daily_bonus/bloc.dart';

import 'constants/app_colors.dart';
import 'constants/app_text.dart';

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
          primarySwatch: Colors.red,
          scaffoldBackgroundColor: AppColors.mainGreen,
          fontFamily: 'Knewave',
        ),
        initialRoute: LoadingScreen.routeName,
        onGenerateRoute: AppNavigator.generateRoutes,
      ),
    );
  }
}

