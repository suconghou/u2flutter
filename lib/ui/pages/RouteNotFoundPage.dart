// ignore_for_file: file_names

import 'package:flutter/material.dart';

class RouteNotFoundPage extends StatelessWidget {
  final String? page;

  const RouteNotFoundPage({Key? key, required this.page}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("404: $page"),
      ),
    );
  }
}
