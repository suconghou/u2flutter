import 'package:flutter/material.dart';

Column ButtonColumn(BuildContext ctx, IconData icon, String label) {
  Color color = Theme.of(ctx).primaryColor;
  return new Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      new Icon(icon, color: color),
      new Container(
        margin: const EdgeInsets.only(top: 8.0),
        child: new Text(
          label,
          style: new TextStyle(
            fontSize: 12.0,
            fontWeight: FontWeight.w400,
            color: color,
          ),
        ),
      ),
    ],
  );
}

Widget ButtomSection(BuildContext ctx) {
  return new Container(
      child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      ButtonColumn(ctx, Icons.favorite, "首页"),
      ButtonColumn(ctx, Icons.search, '搜索'),
      ButtonColumn(ctx, Icons.settings, '设置'),
    ],
  ));
}
