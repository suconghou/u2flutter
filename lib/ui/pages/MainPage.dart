import 'package:flutter/material.dart';
import '../widgets/HomeDrawer.dart';
import '../pages/SearchPage.dart';

class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MainPageState();
  }
}
class _MainPageState extends State with SingleTickerProviderStateMixin{
  TabController _controller;
  @override
  void initState(){
    super.initState();
    _controller = TabController(length: 6, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("首页"),
        actions: [
          IconButton(onPressed: (){
            showSearch(context: context,delegate:SearchPageDelegate());
          },icon:Icon(Icons.search))
        ],
        bottom: TabBar(
            controller:_controller,
          tabs: [
            Tab(text:"音乐"),
            Tab(text:"科技"),
            Tab(text:"社会"),
            Tab(text:"影视"),
          ],
        ),
      ),
      drawer:HomeDrawer(),
      body: Center(
        child: Column(
          children: [
            Text("Main Page"),

          ],
        ),
      ),

    );
  }

}
