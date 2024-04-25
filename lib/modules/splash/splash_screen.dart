import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../data/local/app_preferences.dart';
import '../home/home_screen.dart';
import '../login/login_screen.dart';

class SplashScreen extends StatefulWidget {
  static const path = '/';

  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  _navigateNext() async {
    try {
      await Future.delayed(const Duration(seconds: 3));

      final isLoggedIn = await AppPreferences.checkIsLoggedIn();

      if (mounted && !isLoggedIn) {
        context.pushReplacementNamed(LoginScreen.path);
        return;
      }

      if (mounted) {
        context.pushReplacementNamed(HomeScreen.path);
      }
    } catch (e) {
      log("Failed navigate from splash screen", name: "SPLASH SCREEN");
    }
  }

  @override
  void initState() {
    _navigateNext();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Text(
          AppLocalizations.of(context)!.titleApp,
          style: const TextStyle(
            fontSize: 24,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
