import 'package:flutter/material.dart';
import 'ui/pages/RouteNotFoundPage.dart';
import 'ui/routes.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: routes,
      navigatorKey: navigatorKey,
      onUnknownRoute: (settings) => MaterialPageRoute(
        builder: (BuildContext context) {
          return RouteNotFoundPage(page: settings.name);
        },
      ),
    );
  }
}
