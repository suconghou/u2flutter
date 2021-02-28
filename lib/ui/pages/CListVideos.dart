import 'package:flutter/material.dart';
import 'package:flutter_app/utils/videoInfo.dart';
import 'package:flutter_app/api/index.dart';
import '../widgets/VideoGridWidget.dart';

class CListVideos extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    dynamic item = ModalRoute.of(context).settings.arguments;
    String title = getVideoTitle(item);
    String playlistId = item["id"];
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: videosList(playlistId),
    );
  }
}

class videosList extends StatefulWidget {
  String playlistId;
  videosList(this.playlistId);
  @override
  State<StatefulWidget> createState() {
    return _videosListState(playlistId);
  }
}

class _videosListState extends State<videosList> {
  String playlistId;
  List videoList = [];
  bool loading = false;
  String nexPageToken = "";
  String loadMoreText = "没有更多数据";
  TextStyle loadMoreTextStyle =
      TextStyle(color: const Color(0xFF999999), fontSize: 14.0);
  ScrollController _controller = ScrollController();

  _videosListState(this.playlistId) {
    _pullToRefresh();
    _controller.addListener(() {
      var maxScroll = _controller.position.maxScrollExtent;
      var pixel = _controller.position.pixels;
      if (maxScroll == pixel && nexPageToken != null) {
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
    return videoList.length == 0
        ? new Center(child: new CircularProgressIndicator())
        : RefreshIndicator(
            onRefresh: _pullToRefresh,
            child: ListView(
              children: [
                VideoGridWidget(
                  videoList,
                  controller: _controller,
                ),
                Center(
                  child: Text(loadMoreText, style: loadMoreTextStyle),
                )
              ],
            ));
  }

  Future _pullToRefresh() async {
    final res = await api.playlistItems(playlistId: playlistId);
    setState(() {
      videoList = res["items"];
      nexPageToken = res["nextPageToken"];
    });
  }

  loadMoreData() async {
    if (nexPageToken != null) {
      loading = true;
      final res = await api.playlistItems(
          playlistId: playlistId, pageToken: nexPageToken);
      List resList = (res["items"] is List) ? res["items"] : [];
      setState(() {
        videoList.addAll(resList);
        nexPageToken = res["nextPageToken"];
      });
      loading = false;
    }
  }
}
