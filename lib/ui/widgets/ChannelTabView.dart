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
  bool loading = false;
  String nexPageToken = "";
  String loadMoreText = "没有更多数据";
  TextStyle loadMoreTextStyle =
      TextStyle(color: const Color(0xFF999999), fontSize: 14.0);

  ScrollController _controller = ScrollController();

  _ChannelTabViewState(this.ctype, this.channelId) {
    _pullToRefresh();
    _controller.addListener(() {
      var maxScroll = _controller.position.maxScrollExtent;
      var pixel = _controller.position.pixels;
      if (maxScroll == pixel && nexPageToken.isNotEmpty) {
        setState(() {
          loadMoreText = "正在加载中...";
          loadMoreTextStyle =
              new TextStyle(color: const Color(0xFF4483f6), fontSize: 14.0);
        });
        if (!loading) {
          loadMoreData();
        }
      } else {
        setState(() {
          loadMoreText = "没有更多数据";
          loadMoreTextStyle =
              new TextStyle(color: const Color(0xFF999999), fontSize: 14.0);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return listData.length == 0
        ? new Center(child: new CircularProgressIndicator())
        : RefreshIndicator(onRefresh: _pullToRefresh, child: _body());
  }

  Future _pullToRefresh() async {
    dynamic res;
    if (ctype == ChannelTab.PLAYLIST) {
      res = await api.playlistsInChannel(channelId: channelId);
    } else {
      res = await api.playlistItems(playlistId: channelId);
    }
    if (res != null && res["items"] is List) {
      setState(() {
        listData = res["items"];
        if (res["nextPageToken"] is String) {
          nexPageToken = res["nextPageToken"];
        }
      });
    }
  }

  loadMoreData() async {
    print("load more");
    if (nexPageToken.isNotEmpty) {
      loading = true;
      dynamic res;
      if (ctype == ChannelTab.PLAYLIST) {
        res = await api.playlistsInChannel(
            channelId: channelId, pageToken: nextPageToken);
      } else {
        res = await api.playlistItems(
            playlistId: channelId, pageToken: nextPageToken);
      }
      List resList = (res["items"] is List) ? res["items"] : [];
      listData.addAll(resList);
      setState(() {
        nexPageToken = res["nextPageToken"];
      });
      loading = false;
    }
  }

  Widget _body() {
    final grid = ctype != ChannelTab.PLAYLIST;

    if (grid) {
      return ListView(
        children: [
          VideoGridWidget(
            listData,
            grid: grid,
            controller: _controller,
          ),
          Center(
            child: Text(loadMoreText, style: loadMoreTextStyle),
          )
        ],
      );
    }

    return ListView(
      children: [
        ChannelPlayList(
          listData,
          controller: _controller,
        ),
        Center(
          child: Text(loadMoreText, style: loadMoreTextStyle),
        )
      ],
    );
  }
}
