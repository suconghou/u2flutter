import 'package:flutter/material.dart';
import '../../api/index.dart';
import 'VideoGridWidget.dart';

class HomeTabView extends StatefulWidget {
  final int videoCategoryId;
  HomeTabView(this.videoCategoryId);

  @override
  State<StatefulWidget> createState() {
    return _HomeTabViewState(videoCategoryId);
  }
}

class _HomeTabViewState extends State {
  int videoCategoryId;
  Future _refresh;

  _HomeTabViewState(this.videoCategoryId) {
    _refresh = api.mostPopularVideos(videoCategoryId: videoCategoryId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _refresh,
        builder: (context, AsyncSnapshot snapshot) {
          print(snapshot);
          if (snapshot.connectionState == ConnectionState.done) {
            if (!snapshot.hasError) {
              return _body(snapshot.data);
            } else {
              return Center(
                child: FlatButton(
                  child: Text("加载失败，点击重试"),
                  onPressed: () => refresh(),
                ),
              );
            }
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  void refresh() {
    setState(() {
      _refresh = api.mostPopularVideos(videoCategoryId: videoCategoryId);
    });
  }

  Widget _body(dynamic data) {
    print(data["items"]);
    return RefreshIndicator(
      onRefresh: () async => refresh(),
      child:
          data["items"] is List ? VideoGridWidget(data["items"]) : Text("数据错误"),
    );
  }
}
