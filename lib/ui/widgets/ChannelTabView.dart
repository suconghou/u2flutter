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
  final String channelId;
  final ChannelTab ctype;
  String nextPageToken = "";
  List listData = [];
  bool loading = false;
  bool nomore = false;

  Widget a = Container(
    margin: EdgeInsets.fromLTRB(0, 10, 0, 20),
    child: Center(
      child: Text("没有更多数据",
          style: TextStyle(color: const Color(0xFF999999), fontSize: 14.0)),
    ),
  );
  Widget b = Container(
    margin: EdgeInsets.fromLTRB(0, 10, 0, 20),
    child: Center(
      child: Text("正在加载中...",
          style: TextStyle(color: const Color(0xFF4483f6), fontSize: 14.0)),
    ),
  );

  final ScrollController _controller = ScrollController();

  _ChannelTabViewState(this.ctype, this.channelId) {
    _pullToRefresh();
    _controller.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _controller.removeListener(_scrollListener);
    super.dispose();
  }

  void _scrollListener() {
    if (_controller.position.extentAfter < 100 && nextPageToken.isNotEmpty) {
      if (!loading) {
        loadMoreData();
      }
    }
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
          nextPageToken = res["nextPageToken"];
        } else {
          nomore = true;
        }
      });
    }
  }

  loadMoreData() async {
    if (loading) {
      return;
    }
    loading = true;
    print("load more $nextPageToken");
    if (listData.length == 0 || nextPageToken.isNotEmpty) {
      setState(() {
        nomore = false;
      });
      dynamic res;
      if (ctype == ChannelTab.PLAYLIST) {
        res = await api.playlistsInChannel(
            channelId: channelId, pageToken: nextPageToken);
      } else {
        res = await api.playlistItems(
            playlistId: channelId, pageToken: nextPageToken);
      }
      if (res != null) {
        List origin = List.from(listData);
        List resList = (res["items"] is List) ? res["items"] : [];
        origin.addAll(resList);
        nextPageToken =
            res["nextPageToken"] is String ? res["nextPageToken"] : "";
        setState(() {
          listData = origin;
          nextPageToken = nextPageToken;
          if (nextPageToken.isEmpty) {
            nomore = true;
          }
        });
      }
    }
    loading = false;
  }

  Widget _body() {
    final grid = ctype != ChannelTab.PLAYLIST;

    final bottom = nomore ? a : b;

    if (grid) {
      return ListView(
        controller: _controller,
        cacheExtent: 500,
        children: [
          VideoGridWidget(
            listData,
            grid: grid,
            controller: ScrollController(),
          ),
          bottom,
        ],
      );
    }

    return ListView(
      controller: _controller,
      children: [
        ChannelPlayList(
          listData,
          controller: ScrollController(),
        ),
        bottom
      ],
    );
  }
}
