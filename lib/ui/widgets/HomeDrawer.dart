import 'package:flutter/material.dart';

class HomeDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DrawerHeader(
            padding: EdgeInsets.all(0),
            margin: EdgeInsets.all(0),
            child: InkWell(
              onTap: () {},
              child: Column(
                children: [
                  Container(
                    height: 16,
                  ),
                  ClipOval(
                    child: Image.network(
                      "https://flutter.cn/favicon.ico",
                      width: 80,
                      height: 80,
                    ),
                  ),
                  Container(height:10),
                  Text("登陆/注册"),
                ],
              ),
            )),
        Expanded(
          child: ListView(
            children: [
              ListTile(
                leading: Icon(Icons.favorite),
                title:Text("我的收藏"),
                onTap:(){
                  Navigator.pushNamed(context, "/favorites");
              },
              ),

              ListTile(
                leading: Icon(Icons.file_download),
                title:Text("下载管理"),
                onTap:(){
                  Navigator.pushNamed(context, "/download");
                },
              ),

              ListTile(
                leading: Icon(Icons.favorite),
                title:Text("我的收藏"),
                onTap:(){
                  Navigator.pushNamed(context, "/favorites");
                },
              ),


            ],
          ),
        )
      ],
    ));
  }
}
