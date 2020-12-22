import 'package:flutter/material.dart';
import 'VideoGridWidget.dart';

class VideoListBuilder {
  Future<dynamic> _refresh;
  Function refresh;

  VideoListBuilder(this._refresh, this.refresh);

  Widget build() {
    return FutureBuilder(
        future: _refresh,
        builder: (context, AsyncSnapshot snapshot) {
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

  Widget _body(dynamic data) {
    return VideoGridWidget(data["items"],grid: false,);
  }
}
