import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("设置"),
      ),
      body: Center(
        child: Column(
          children: [
            Text("设置页面"),
          ],
        ),
      ),
    );
  }
}
