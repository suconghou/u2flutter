// ignore_for_file: file_names

import 'package:flutter/material.dart';
import '../../api/index.dart';
import 'VideoGridWidget.dart';
import 'ChannalPlayList.dart';

enum ChannelTab { upload, favorite, playlist }

class ChannelTabView extends StatefulWidget {
  final String channelId;
  final ChannelTab ctype;
  const ChannelTabView(this.ctype, this.channelId, {super.key});

  @override
  State<StatefulWidget> createState() {
    return _ChannelTabViewState();
  }
}

class _ChannelTabViewState extends State<ChannelTabView> {
  String nextPageToken = "";
  List listData = [];
  bool loading = false;
  bool nomore = false;

  Widget a = Container(
    margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
    child: const Center(
      child: Text(
        "没有更多数据",
        style: TextStyle(color: Color(0xFF999999), fontSize: 14.0),
      ),
    ),
  );
  Widget b = Container(
    margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
    child: const Center(
      child: Text(
        "正在加载中...",
        style: TextStyle(color: Color(0xFF4483f6), fontSize: 14.0),
      ),
    ),
  );

  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
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
    return listData.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : RefreshIndicator(onRefresh: _pullToRefresh, child: _body());
  }

  Future _pullToRefresh() async {
    if (!mounted) {
      return;
    }
    dynamic res;
    if (widget.ctype == ChannelTab.playlist) {
      res = await api.playlistsInChannel(channelId: widget.channelId);
    } else {
      res = await api.playlistItems(playlistId: widget.channelId);
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

  Future<void> loadMoreData() async {
    if (!mounted) {
      return;
    }
    if (loading) {
      return;
    }
    loading = true;
    if (listData.isEmpty || nextPageToken.isNotEmpty) {
      setState(() {
        nomore = false;
      });
      dynamic res;
      if (widget.ctype == ChannelTab.playlist) {
        res = await api.playlistsInChannel(
          channelId: widget.channelId,
          pageToken: nextPageToken,
        );
      } else {
        res = await api.playlistItems(
          playlistId: widget.channelId,
          pageToken: nextPageToken,
        );
      }
      if (res != null) {
        List origin = List.from(listData);
        List resList = (res["items"] is List) ? res["items"] : [];
        origin.addAll(resList);
        nextPageToken = res["nextPageToken"] is String
            ? res["nextPageToken"]
            : "";
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
    final grid = widget.ctype != ChannelTab.playlist;

    final bottom = nomore ? a : b;

    if (grid) {
      return ListView(
        controller: _controller,
        cacheExtent: 500,
        children: [
          VideoGridWidget(listData, controller: ScrollController()),
          bottom,
        ],
      );
    }

    return ListView(
      controller: _controller,
      children: [
        ChannelPlayList(listData, controller: ScrollController()),
        bottom,
      ],
    );
  }
}
