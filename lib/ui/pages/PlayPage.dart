import 'package:flutter/material.dart';

class PlayPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Play Page Title"),
      ),
      body: Center(
        child: Column(
          children: [
            Text("Play Page"),
          ],
        ),
      ),
    );
  }
}
