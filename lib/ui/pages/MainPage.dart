// ignore_for_file: file_names

import 'package:flutter/material.dart';
import '../widgets/HomeDrawer.dart';
import '../widgets/HomeTabView.dart';
import '../pages/SearchPage.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MainPageState();
  }
}

class _MainPageState extends State with SingleTickerProviderStateMixin {
  late TabController _controller;
  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 5, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("首页"),
        actions: [
          IconButton(
            onPressed: () {
              showSearch(context: context, delegate: SearchPageDelegate());
            },
            icon: const Icon(Icons.search),
          ),
        ],
        bottom: TabBar(
          controller: _controller,
          tabs: const [
            Tab(text: "音乐"),
            Tab(text: "电影"),
            Tab(text: "动物"),
            Tab(text: "游戏"),
            Tab(text: "科技"),
          ],
        ),
      ),
      drawer: const HomeDrawer(),
      body: TabBarView(
        controller: _controller,
        children: const [
          HomeTabView(10),
          HomeTabView(1),
          HomeTabView(15),
          HomeTabView(20),
          HomeTabView(28),
        ],
      ),
    );
  }
}
