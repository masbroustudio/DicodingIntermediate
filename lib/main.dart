import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:story_app/data/api/api_service.dart';
import 'package:story_app/data/db/auth_repository.dart';
import 'package:story_app/provider/api_provider.dart';
import 'package:story_app/provider/auth_provider.dart';
import 'package:story_app/provider/home_provider.dart';
import 'package:story_app/provider/story_provider.dart';
import 'package:story_app/screen/add_story_page.dart';
import 'package:story_app/screen/picker_screen.dart';
import 'package:story_app/screen/splash_screen.dart';
import 'package:story_app/screen/story_detail_page.dart';
import 'package:story_app/screen/home_page.dart';
import 'package:story_app/screen/login_page.dart';
import 'package:story_app/screen/register_page.dart';
import 'package:story_app/utils/custom_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late AuthProvider authProvider;
  late StoryProvider storyProvider;
  GoRouter? router;

  @override
  void initState() {
    super.initState();
    final authRepository = AuthRepository();
    final apiProvider = ApiProvider(StoryApiService(authRepository));

    authProvider = AuthProvider(authRepository, apiProvider);
    storyProvider = StoryProvider(StoryApiService(authRepository));
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: authProvider,
        ),
        ChangeNotifierProvider.value(
          value: storyProvider,
        ),
        ChangeNotifierProvider.value(
          value: HomeProvider(),
        ),
      ],
      child: MaterialApp(
        theme: CustomTheme.appTheme,
        debugShowCheckedModeBanner: false,
        home: FutureBuilder<void>(
          future: authProvider.initialize(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              // Initialize router here
              router = GoRouter(
                routes: [
                  // Routes configuration remains the same
                  GoRoute(
                    path: '/splash',
                    name: 'splash',
                    builder: (context, state) => const SplashScreen(),
                  ),
                  GoRoute(
                    path: '/login',
                    name: 'login',
                    builder: (context, state) => const LoginPage(),
                    routes: [
                      GoRoute(
                        path: 'register',
                        name: 'register',
                        builder: (context, state) => const RegisterPage(),
                      )
                    ],
                  ),
                  GoRoute(
                      path: '/',
                      name: 'home',
                      builder: (context, state) => const HomePage(),
                      routes: [
                        GoRoute(
                            path: 'detail/:id',
                            name: 'detail',
                            builder: (context, state) {
                              String storyId =
                                  state.pathParameters['id'] ?? 'no id';
                              return StoryDetailPage(storyId: storyId);
                            }),
                        GoRoute(
                            path: 'add',
                            name: 'add',
                            builder: (context, state) {
                              Object? object = state.extra;
                              if (object != null && object is LatLng) {
                                return AddStoryPage(
                                  inputLang: object,
                                );
                              } else {
                                return const AddStoryPage();
                              }
                            },
                            routes: [
                              GoRoute(
                                path: 'picker',
                                name: 'picker',
                                builder: (context, state) {
                                  return const PickerScreen();
                                },
                              )
                            ])
                      ]),
                ],
                redirect: (context, state) {
                  if (router == null) {
                    return '/splash';
                  } else {
                    return null;
                  }
                },
                initialLocation: authProvider.isLoggedIn ? '/' : '/login',
                debugLogDiagnostics: true,
                routerNeglect: true,
              );

              return MaterialApp.router(
                theme: CustomTheme.appTheme,
                routeInformationParser: router?.routeInformationParser,
                routerDelegate: router?.routerDelegate,
                routeInformationProvider: router?.routeInformationProvider,
                backButtonDispatcher: RootBackButtonDispatcher(),
                debugShowCheckedModeBanner: false,
              );
            } else {
              return const SplashScreen(); // Show a loading screen while initializing
            }
          },
        ),
      ),
    );
  }
}
