import 'package:flutter/material.dart';

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("我的收藏"),
      ),
      body: Center(
        child: Column(
          children: [
            Text("这里分两类收藏,一类是视频,一类是channel"),
          ],
        ),
      ),
    );
  }
}
