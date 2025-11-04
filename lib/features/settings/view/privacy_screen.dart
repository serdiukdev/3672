import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:itd_2/core/services/app_navigator.dart';
import 'package:itd_2/features/settings/view/settings_screen.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_styles.dart';
import '../../../core/constants/app_text.dart';
import '../../../shared/components/nav_bar.dart';

class PrivacyPolicy extends StatefulWidget {
  static const routeName = 'privacy';

  const PrivacyPolicy({super.key});

  @override
  State<PrivacyPolicy> createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  int _tab = 8;
  InAppWebViewController? webViewController;
  String? privacy;

  @override
  void initState() {
    privacy = Platform.isAndroid ? 'https://google.com' : 'https://google.com';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(AppTexts.privacy, style: AppStyles.achievementTitle),
        leading: IconButton(
          onPressed: () =>
              context.pushNamedAndRemoveUntil(SettingsScreen.routeName),
          icon: Image.asset('assets/general_buttons/back_icon.webp'),
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _tab,
        onTap: (index) {
          setState(() => _tab = index);
        },
      ),
      body: Container(
        width: size.width,
        height: size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bg_in_game/bg_1.webp'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Container(
            height: size.height * 0.7,
            width: size.width * 0.9,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/bg_components/privacy_terms_bg.webp'),
                fit: BoxFit.fill,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.chartBorder, width: 5),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: InAppWebView(
                initialUrlRequest: URLRequest(
                  url: WebUri.uri(Uri.parse(privacy.toString())),
                ),
                onWebViewCreated: (controller) {
                  webViewController = controller;
                },
                initialSettings: InAppWebViewSettings(
                  supportZoom: false,
                  disallowOverScroll: true,
                  javaScriptEnabled: true,
                  transparentBackground: true,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
