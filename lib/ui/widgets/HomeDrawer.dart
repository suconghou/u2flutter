// ignore_for_file: file_names

import 'package:flutter/material.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DrawerHeader(
            padding: const EdgeInsets.all(0),
            margin: const EdgeInsets.all(0),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/player',
                );
              },
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
                  const Text("U2FLUTTER"),
                ],
              ),
            )),
        Expanded(
          child: ListView(
            children: [
              ListTile(
                leading: const Icon(
                  Icons.favorite,
                  color: Colors.blue,
                ),
                trailing: Icon(Icons.chevron_right,
                    color: Theme.of(context).primaryColor),
                title: const Text("我的收藏"),
                onTap: () {
                  Navigator.pushNamed(context, "/favorites");
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.cast,
                  color: Colors.blue,
                ),
                trailing: Icon(Icons.chevron_right,
                    color: Theme.of(context).primaryColor),
                title: const Text("投屏助手"),
                onTap: () {
                  Navigator.pushNamed(context, "/share");
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.settings,
                  color: Colors.blue,
                ),
                trailing: Icon(Icons.chevron_right,
                    color: Theme.of(context).primaryColor),
                title: const Text("系统设置"),
                onTap: () {
                  Navigator.pushNamed(context, "/settings");
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.info,
                  color: Colors.blue,
                ),
                trailing: Icon(Icons.chevron_right,
                    color: Theme.of(context).primaryColor),
                title: const Text("关于应用"),
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
