import 'package:flutter/material.dart';
import '../widgets/HomeDrawer.dart';
import '../widgets/VideoGridWidget.dart';
import '../widgets/HomeTabView.dart';
import '../pages/SearchPage.dart';

class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MainPageState();
  }
}

class _MainPageState extends State with SingleTickerProviderStateMixin {
  TabController _controller;
  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 6, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("首页"),
          actions: [
            IconButton(
                onPressed: () {
                  showSearch(context: context, delegate: SearchPageDelegate());
                },
                icon: Icon(Icons.search))
          ],
          bottom: TabBar(
            controller: _controller,
            tabs: [
              Tab(text: "音乐"),
              Tab(text: "电影"),
              Tab(text: "动物"),
              Tab(text: "体育"),
              Tab(text: "游戏"),
              Tab(text: "科技"),
            ],
          ),
        ),
        drawer: HomeDrawer(),
        body: TabBarView(
          controller: _controller,
          children: [
            HomeTabView(10),
            HomeTabView(1),
            HomeTabView(15),
            HomeTabView(17),
            HomeTabView(20),
            HomeTabView(28),
          ],
        ));
  }
}
