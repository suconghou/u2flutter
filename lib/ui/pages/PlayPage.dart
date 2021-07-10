import 'package:flutter/material.dart';
import 'package:flutter_app/api/index.dart';
import 'package:flutter_app/ui/utils/toast.dart';
import 'package:flutter_app/utils/dataHelper.dart';
import '../widgets/VideoListBuilder.dart';
import '../widgets/VideoStreamPlayer.dart';
import '../../utils/videoInfo.dart';

enum VideoAction {
  fav,
  dlna,
  favchannel,
}

// ignore: must_be_immutable
class PlayPage extends StatelessWidget {
  late Future<dynamic> _refresh;
  String videoId = "";

  @override
  Widget build(BuildContext context) {
    dynamic item = ModalRoute.of(context)?.settings.arguments;
    videoId = getVideoId(item);

    final String title = getVideoTitle(item);
    final String desc = getVideoTitle(item);
    final String pubTime = pubAt(item);
    final String count = viewCount(item);
    final String dur = duration(item);
    final String cid = getChannelId(item);
    final String ctitle = getChannelTitle(item);
    final url = streambase + '$videoId.mpd';

    final player = VideoStreamPlayer(url, title);

    final cc = (cid.isNotEmpty && ctitle.isNotEmpty)
        ? Container(
            margin: EdgeInsets.only(bottom: 10),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(context, '/channel', arguments: cid);
              },
              child: Text(
                ctitle,
                style: TextStyle(fontSize: 14, color: Colors.blue),
              ),
            ),
          )
        : SizedBox(
            height: 2,
          );
    refresh(item["channel"] is bool);
    final full = MediaQuery.of(context).orientation == Orientation.landscape;

    final page = Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [RightMenu(videoId, cid)],
      ),
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          AspectRatio(
            aspectRatio: 1.7777,
            child: player,
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: Column(
              children: [
                Align(
                  child: cc,
                  alignment: Alignment.topLeft,
                ),
                Row(
                  children: [
                    Text(
                      "发布于" + pubTime,
                      style: TextStyle(height: 1),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      dur,
                      style: TextStyle(height: 1, color: Colors.red),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(count,
                        style: TextStyle(
                            height: 1,
                            fontSize: 14,
                            color: Colors.black87,
                            decoration: TextDecoration.none)),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Text(
                  desc,
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(
                  height: 20,
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "相关视频",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                VideoListBuilder(_refresh, refresh).build(),
                SizedBox(
                  height: 60,
                ),
              ],
            ),
          ),
        ],
      ),
    );
    return full
        ? Scaffold(
            body: Stack(fit: StackFit.expand, children: <Widget>[
            player,
          ]))
        : page;
  }

  refresh(bool channel) {
    if (channel) {
      _refresh = api.playlistsInChannel(channelId: videoId);
    } else {
      _refresh = api.relatedVideo(relatedToVideoId: videoId);
    }
  }
}

class RightMenu extends StatefulWidget {
  final String videoId;
  final String cid;

  RightMenu(this.videoId, this.cid);
  @override
  State<StatefulWidget> createState() {
    return _RightMenuState(videoId, cid);
  }
}

class _RightMenuState extends State<RightMenu> {
  late String videoId;
  late String cid;
  late Future future;
  _RightMenuState(this.videoId, this.cid);
  @override
  Widget build(BuildContext context) {
    future = myFav();
    return FutureBuilder(
        future: future,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (!snapshot.hasError) {
              final Set<String> vids = snapshot.data[0];
              final Set<String> cids = snapshot.data[1];
              final hasFav = vids.contains(videoId);
              final hasFavCid = cids.contains(cid);
              return PopupMenuButton(
                onSelected: (result) async {
                  if (result == VideoAction.dlna) {
                    Toast.toast(context, "投屏助手开发中");
                  } else if (result == VideoAction.fav) {
                    if (hasFav) {
                      await delFavVIds(videoId);
                      Toast.toast(context, "已取消收藏");
                    } else {
                      await addFavVIds(videoId);
                      Toast.toast(context, "已加入收藏");
                    }
                  } else if (result == VideoAction.favchannel) {
                    if (hasFavCid) {
                      await delFavCIds(cid);
                      Toast.toast(context, "已取消收藏此频道");
                    } else {
                      await addFavCIds(cid);
                      Toast.toast(context, "已收藏此频道");
                    }
                  }
                  setState(() {
                    future = myFav();
                  });
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                  PopupMenuItem<VideoAction>(
                    value: VideoAction.dlna,
                    child: Text('投屏助手'),
                  ),
                  PopupMenuItem<VideoAction>(
                    value: VideoAction.fav,
                    child: Text(hasFav ? '取消收藏此视频' : '收藏此视频'),
                  ),
                  PopupMenuItem<VideoAction>(
                    value: VideoAction.favchannel,
                    child: Text(hasFavCid ? '取消收藏此频道' : '收藏此频道'),
                  ),
                ],
              );
            } else {
              return Center(
                child: TextButton(
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

  myFav() async {
    final vids = await getFavVIds();
    final cids = await getFavCIds();
    return [vids, cids];
  }
}
