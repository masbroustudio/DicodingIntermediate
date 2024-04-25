import 'package:go_router/go_router.dart';

import '../data/models/story.dart';
import '../modules/add/add_screen.dart';
import '../modules/detail/detail_screen.dart';
import '../modules/home/home_screen.dart';
import '../modules/login/login_screen.dart';
import '../modules/register/register_screen.dart';
import '../modules/splash/splash_screen.dart';

final routerConfig = GoRouter(
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      path: SplashScreen.path,
      name: SplashScreen.path,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: LoginScreen.path,
      name: LoginScreen.path,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: RegisterScreen.path,
      name: RegisterScreen.path,
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: HomeScreen.path,
      name: HomeScreen.path,
      builder: (context, state) => const HomeScreen(),
      routes: [
        GoRoute(
          path: DetailScreen.path,
          name: DetailScreen.path,
          builder: (context, state) => DetailScreen(
            story: state.extra as Story,
          ),
        ),
        GoRoute(
          path: AddScreen.path,
          name: AddScreen.path,
          builder: (context, state) => const AddScreen(),
        ),
      ],
    ),
  ],
);
