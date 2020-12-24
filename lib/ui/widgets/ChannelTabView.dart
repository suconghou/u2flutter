import 'package:flutter/material.dart';
import '../../api/index.dart';
import 'VideoGridWidget.dart';

enum ChannelTab { UPLOAD, FAVORITE, PLAYLIST }

class ChannelTabView extends StatefulWidget {
  final String channelId;
  final ChannelTab ctype;
  ChannelTabView(this.ctype, this.channelId);

  @override
  State<StatefulWidget> createState() {
    return _ChannelTabViewState(ctype, channelId);
  }
}

class _ChannelTabViewState extends State {
  String channelId;
  final ChannelTab ctype;
  Future _refresh;

  _ChannelTabViewState(this.ctype, this.channelId) {
    debugPrint(channelId);
    debugPrint("$ctype");
    if (ctype == ChannelTab.PLAYLIST) {
      _refresh = api.playlistsInChannel(channelId:channelId);
    } else {
      _refresh = api.playlistItems(playlistId: channelId);
    }
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
      if (ctype == ChannelTab.PLAYLIST) {
        _refresh = api.playlistsInChannel(channelId:channelId);
      } else {
        _refresh = api.playlistItems(playlistId: channelId);
      }
    });
  }

  Widget _body(dynamic data) {
    final grid = ctype!=ChannelTab.PLAYLIST;
    var content = data["items"] is List
        ? VideoGridWidget(data["items"],grid: grid,)
        : Text("数据错误");
    return grid?content:ListView(
      padding: EdgeInsets.all(10),
      children: [content],
    );
  }
}
