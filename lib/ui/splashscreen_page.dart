import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../data/local/app_preferences.dart';
import 'homestory_page.dart';
import 'loginstory_page.dart';

class SplashscreenPage extends StatefulWidget {
  static const path = '/';

  const SplashscreenPage({super.key});

  @override
  State<SplashscreenPage> createState() => _SplashscreenPageState();
}

class _SplashscreenPageState extends State<SplashscreenPage> {
  _navigateNext() async {
    try {
      await Future.delayed(const Duration(seconds: 3));

      final isLoggedIn = await AppPreferences.checkIsLoggedIn();

      if (mounted && !isLoggedIn) {
        context.pushReplacementNamed(LoginstoryPage.path);
        return;
      }

      if (mounted) {
        context.pushReplacementNamed(HomestoryPage.path);
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
