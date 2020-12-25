import 'package:flutter/material.dart';
import '../../utils/dataHelper.dart';
import '../../api/index.dart';
import '../widgets/VideoGridWidget.dart';

class FavVideoList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var ids = getFavVIds();
    ids = {"mrHqzfjdpX8"};

    if (ids.length < 1) {
      return Center(
        child: Text("无数据"),
      );
    }
    return ListView(
      children: ids.map((e) => buildItem(e)).toList(),
    );
  }

  Widget buildItem(String id) {
    final Future _refresh = api.videoInfo(id);
    return FutureBuilder(
        future: _refresh,
        builder: (context, AsyncSnapshot snapshot) {
          print(snapshot);
          if (snapshot.connectionState == ConnectionState.done) {
            if (!snapshot.hasError) {
              return _body(context, snapshot.data);
            } else {
              return Center(
                child: FlatButton(
                  child: Text("加载失败"),
                  onPressed: () => {},
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

  Widget _body(BuildContext context, dynamic res) {
    final item = res["items"][0];
    return buildSignleVideoItem(context, item);
  }
}
