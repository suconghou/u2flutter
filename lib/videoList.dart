import 'package:flutter/material.dart';

List<Container> _buildGridTileList(int count) {
  return new List<Container>.generate(
      count, (int index) => Container(child: Text("hello")));
}

Widget buildGrid() {
  return GridView.extent(
      maxCrossAxisExtent: 150.0,
      padding: const EdgeInsets.all(4.0),
      mainAxisSpacing: 4.0,
      crossAxisSpacing: 4.0,
      children: _buildGridTileList(30));
}
