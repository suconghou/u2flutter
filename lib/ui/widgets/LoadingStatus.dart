// ignore_for_file: file_names

import 'package:flutter/material.dart';

enum LoadingStatus { none, loading, nomore, error }
Widget getWidgetByLoadingStatus(LoadingStatus status, VoidCallback onRefresh,
    {String errText = "数据加载失败，点击重试"}) {
  switch (status) {
    case LoadingStatus.loading:
      return const Center(child: CircularProgressIndicator());
    case LoadingStatus.error:
      return Center(
        child: TextButton(
            onPressed: onRefresh, child: Center(child: Text(errText))),
      );
    case LoadingStatus.nomore:
      return const Center(
          child: Padding(
        padding: EdgeInsets.all(10),
        child: Text("---   到底了   ---"),
      ));
    case LoadingStatus.none:
      return Container();
  }
}
