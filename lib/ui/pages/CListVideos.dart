// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_app/utils/videoInfo.dart';
import 'package:flutter_app/api/index.dart';
import '../widgets/VideoGridWidget.dart';

class CListVideos extends StatelessWidget {
  const CListVideos({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    dynamic item = ModalRoute.of(context)?.settings.arguments;
    String title = getVideoTitle(item);
    String playlistId = item["id"];
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: VideosList(playlistId),
    );
  }
}

class VideosList extends StatefulWidget {
  final String playlistId;
  const VideosList(this.playlistId, {Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _VideosListState();
  }
}

class _VideosListState extends State<VideosList> {
  List videoList = [];
  bool loading = false;
  String nextPageToken = "";

  bool nomore = false;

  Widget a = Container(
    margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
    child: const Center(
      child: Text("没有更多数据",
          style: TextStyle(color: Color(0xFF999999), fontSize: 14.0)),
    ),
  );
  Widget b = Container(
    margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
    child: const Center(
      child: Text("正在加载中...",
          style: TextStyle(color: Color(0xFF4483f6), fontSize: 14.0)),
    ),
  );

  TextStyle loadMoreTextStyle =
      const TextStyle(color: Color(0xFF999999), fontSize: 14.0);
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
    final bottom = nomore ? a : b;

    return videoList.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : RefreshIndicator(
            onRefresh: _pullToRefresh,
            child: ListView(
              controller: _controller,
              children: [
                VideoGridWidget(
                  videoList,
                  controller: ScrollController(),
                ),
                bottom,
              ],
            ));
  }

  Future _pullToRefresh() async {
    final res = await api.playlistItems(playlistId: widget.playlistId);
    if (res == null) {
      return;
    }
    setState(() {
      videoList = res["items"] is List ? res["items"] : [];
      if (res["nextPageToken"] is String) {
        nextPageToken = res["nextPageToken"];
      } else {
        nomore = true;
      }
    });
  }

  loadMoreData() async {
    if (loading) {
      return;
    }
    loading = true;
    if (videoList.isEmpty || nextPageToken.isNotEmpty) {
      final res = await api.playlistItems(
          playlistId: widget.playlistId, pageToken: nextPageToken);
      if (res != null) {
        final origin = List.from(videoList);
        List resList = (res["items"] is List) ? res["items"] : [];
        origin.addAll(resList);
        nextPageToken =
            res["nextPageToken"] is String ? res["nextPageToken"] : "";
        setState(() {
          videoList = origin;
          nextPageToken = nextPageToken;
          if (nextPageToken.isEmpty) {
            nomore = true;
          }
        });
      }
    }
    loading = false;
  }
}
