import 'package:flutter/material.dart';
import '../../api/index.dart';
import 'VideoGridWidget.dart';
import 'ChannalPlayList.dart';

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
  String nextPageToken = "";
  List listData = [];
  final ChannelTab ctype;
  Future _refresh;

  _ChannelTabViewState(this.ctype, this.channelId) {
    if (ctype == ChannelTab.PLAYLIST) {
      _refresh = api.playlistsInChannel(channelId:channelId);
    } else {
      _refresh = api.playlistItems(playlistId: channelId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return listData.length ==0 ? Center(child: CircularProgressIndicator(),):
    _body(listData);

    // return FutureBuilder(
    //     future: _refresh,
    //     builder: (context, AsyncSnapshot snapshot) {
    //       if (snapshot.connectionState == ConnectionState.done) {
    //         if (!snapshot.hasError) {
    //           return
    //         } else {
    //           return Center(
    //             child: FlatButton(
    //               child: Text("加载失败，点击重试"),
    //               onPressed: () => refresh(),
    //             ),
    //           );
    //         }
    //       } else {
    //         return Center(
    //           child: CircularProgressIndicator(),
    //         );
    //       }
    //     });
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
    if(data["items"] is List){
        final grid = ctype!=ChannelTab.PLAYLIST;
        var content = grid
            ?   VideoGridWidget(data["items"],grid: grid, )
            : ChannelPlayList(data["items"]);
        return content;
    }
    return Text("数据错误");

  }
}
