import 'package:flutter/material.dart';

class RouteNotFoundPage extends StatelessWidget {
  final String? page;

  const RouteNotFoundPage({required this.page});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("404: $page"),
      ),
    );
  }
}
