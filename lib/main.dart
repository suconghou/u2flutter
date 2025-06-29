import 'package:flutter/material.dart';
import 'ui/pages/RouteNotFoundPage.dart';
import 'ui/routes.dart';

void main() {
  runApp(
    MaterialApp(
      routes: routes,
      onUnknownRoute: (settings) => MaterialPageRoute(
        builder: (BuildContext context) {
          return RouteNotFoundPage(page: settings.name);
        },
      ),
    ),
  );
}
