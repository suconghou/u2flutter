import 'package:flutter/material.dart';
import 'package:flutter_app/utils/videoInfo.dart';
import 'package:flutter_app/api/index.dart';
import '../widgets/VideoGridWidget.dart';

class CListVideos extends StatelessWidget {
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
  VideosList(this.playlistId);
  @override
  State<StatefulWidget> createState() {
    return _VideosListState(playlistId);
  }
}

class _VideosListState extends State<VideosList> {
  String playlistId;
  List videoList = [];
  bool loading = false;
  String nextPageToken = "";

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

  TextStyle loadMoreTextStyle =
      TextStyle(color: const Color(0xFF999999), fontSize: 14.0);
  ScrollController _controller = ScrollController();

  _VideosListState(this.playlistId) {
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

    return videoList.length == 0
        ? new Center(child: new CircularProgressIndicator())
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
    final res = await api.playlistItems(playlistId: playlistId);
    if (res == null) {
      return;
    }
    setState(() {
      print(res);
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
    print("load more $nextPageToken");
    if (videoList.length == 0 || nextPageToken.isNotEmpty) {
      final res = await api.playlistItems(
          playlistId: playlistId, pageToken: nextPageToken);
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
