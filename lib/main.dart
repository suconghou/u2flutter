import 'package:flutter/material.dart';
import 'ui/pages/RouteNotFoundPage.dart';
import 'ui/routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: routes,
      onUnknownRoute: (settings) => MaterialPageRoute(
        builder: (BuildContext context) {
          return RouteNotFoundPage(page: settings.name);
        },
      ),
    );
  }
}
