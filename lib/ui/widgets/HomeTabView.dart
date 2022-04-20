// ignore_for_file: file_names

import 'package:flutter/material.dart';
import '../../api/index.dart';
import 'VideoGridWidget.dart';

class HomeTabView extends StatefulWidget {
  final int videoCategoryId;
  const HomeTabView(this.videoCategoryId, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _HomeTabViewState();
  }
}

class _HomeTabViewState extends State<HomeTabView> {
  late Future _refresh;

  _HomeTabViewState() {
    _refresh = api.mostPopularVideos(videoCategoryId: widget.videoCategoryId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _refresh,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (!snapshot.hasError) {
              return _body(snapshot.data);
            } else {
              return Center(
                child: TextButton(
                  child: const Text("加载失败，点击重试"),
                  onPressed: () => refresh(),
                ),
              );
            }
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  void refresh() {
    setState(() {
      _refresh = api.mostPopularVideos(videoCategoryId: widget.videoCategoryId);
    });
  }

  Widget _body(dynamic data) {
    final child = data["items"] is List
        ? VideoGridWidget(data["items"])
        : const Text("数据错误");
    return RefreshIndicator(
      onRefresh: () async => refresh(),
      child: child,
    );
  }
}
