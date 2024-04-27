import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:submissionyudhae01/db/auth_repository.dart';
import 'package:submissionyudhae01/provider/auth_provider.dart';
import 'package:submissionyudhae01/routes/router_delegate.dart';

import 'common/url_strategy.dart';
import 'routes/route_information_parser.dart';

void main() {
  /// todo 5: call the function before runApp()
  usePathUrlStrategy();
  runApp(const FluStoryOne());
}

class FluStoryOne extends StatefulWidget {
  const FluStoryOne({super.key});

  @override
  State<FluStoryOne> createState() => _QuotesAppState();
}

class _QuotesAppState extends State<FluStoryOne> {
  late MyRouterDelegate myRouterDelegate;
  late MyRouteInformationParser myRouteInformationParser;
  late AuthProvider authProvider;

  @override
  void initState() {
    super.initState();
    final authRepository = AuthRepository();

    authProvider = AuthProvider(authRepository);

    myRouterDelegate = MyRouterDelegate(authRepository);

    myRouteInformationParser = MyRouteInformationParser();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => authProvider,
      child: MaterialApp.router(
        title: 'Quotes App',
        routerDelegate: myRouterDelegate,
        routeInformationParser: myRouteInformationParser,
        backButtonDispatcher: RootBackButtonDispatcher(),
      ),
    );
  }
}
