import 'package:flutter/material.dart';
import '../widgets/FavChannelList.dart';
import '../widgets/FavVideoList.dart';

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("我的收藏"),
          bottom: TabBar(
            tabs: [
              Tab(text: "视频"),
              Tab(text: "频道"),
            ],
          ),
        ),
        body: Container(
          margin: EdgeInsets.all(10),
          child: TabBarView(
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
