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
                    height: 20,
                  ),
                  ClipOval(
                    child: Image.network(
                      "https://assets.suconghou.cn/u2web/static/dist/favicon.ico",
                      width: 80,
                      height: 80,
                    ),
                  ),
                  Container(height: 20),
                  Text("U2FLUTTER"),
                ],
              ),
            )),
        Expanded(
          child: ListView(
            children: [
              ListTile(
                leading: Icon(
                  Icons.favorite,
                  color: Colors.blue,
                ),
                trailing: Icon(Icons.chevron_right,
                    color: Theme.of(context).primaryColor),
                title: Text("我的收藏"),
                onTap: () {
                  Navigator.pushNamed(context, "/favorites");
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.file_download,
                  color: Colors.blue,
                ),
                trailing: Icon(Icons.chevron_right,
                    color: Theme.of(context).primaryColor),
                title: Text("投屏助手"),
                onTap: () {
                  Navigator.pushNamed(context, "/share");
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.info,
                  color: Colors.blue,
                ),
                trailing: Icon(Icons.chevron_right,
                    color: Theme.of(context).primaryColor),
                title: Text("未知导航"),
                onTap: () {
                  Navigator.pushNamed(context, "/about");
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.settings,
                  color: Colors.blue,
                ),
                trailing: Icon(Icons.chevron_right,
                    color: Theme.of(context).primaryColor),
                title: Text("系统设置"),
                onTap: () {
                  Navigator.pushNamed(context, "/settings");
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.info,
                  color: Colors.blue,
                ),
                trailing: Icon(Icons.chevron_right,
                    color: Theme.of(context).primaryColor),
                title: Text("关于应用"),
                onTap: () {
                  Navigator.pushNamed(context, "/about");
                },
              ),
            ],
          ),
        )
      ],
    ));
  }
}
