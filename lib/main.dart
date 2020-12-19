import 'package:flutter/material.dart';
import 'ui/routes.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: ROUTES,
    );
  }
}
