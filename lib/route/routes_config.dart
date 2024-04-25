import 'package:go_router/go_router.dart';

import '../data/models/story.dart';
import '../ui/addstory_page.dart';
import '../ui/detailstory_page.dart';
import '../ui/homestory_page.dart';
import '../ui/loginstory_page.dart';
import '../ui/registerstory_page.dart';
import '../ui/splashscreen_page.dart';

final routesConfig = GoRouter(
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      path: SplashscreenPage.path,
      name: SplashscreenPage.path,
      builder: (context, state) => const SplashscreenPage(),
    ),
    GoRoute(
      path: LoginstoryPage.path,
      name: LoginstoryPage.path,
      builder: (context, state) => const LoginstoryPage(),
    ),
    GoRoute(
      path: RegisterstoryPage.path,
      name: RegisterstoryPage.path,
      builder: (context, state) => const RegisterstoryPage(),
    ),
    GoRoute(
      path: HomestoryPage.path,
      name: HomestoryPage.path,
      builder: (context, state) => const HomestoryPage(),
      routes: [
        GoRoute(
          path: DetailstoryPage.path,
          name: DetailstoryPage.path,
          builder: (context, state) => DetailstoryPage(
            story: state.extra as Story,
          ),
        ),
        GoRoute(
          path: AddstoryPage.path,
          name: AddstoryPage.path,
          builder: (context, state) => const AddstoryPage(),
        ),
      ],
    ),
  ],
);
