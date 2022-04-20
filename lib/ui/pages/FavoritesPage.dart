// ignore_for_file: file_names

import 'package:flutter/material.dart';
import '../widgets/FavChannelList.dart';
import '../widgets/FavVideoList.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("我的收藏"),
          bottom: const TabBar(
            tabs: [
              Tab(text: "视频"),
              Tab(text: "频道"),
            ],
          ),
        ),
        body: Container(
          color: Colors.grey[100],
          child: const TabBarView(
            children: [
              FavVideoList(),
              FavChannelList(),
            ],
          ),
        ),
      ),
    );
  }
}
