// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_app/api/index.dart';
import 'package:flutter_app/ui/utils/toast.dart';
import 'package:flutter_app/utils/dataHelper.dart';
import '../widgets/VideoListBuilder.dart';
import '../widgets/VideoStreamPlayer.dart';
import '../widgets/DlnaDeviceList.dart';
import '../../utils/videoInfo.dart';
import '../../stream/http.dart';

enum VideoAction {
  fav,
  dlna,
  favchannel,
}

late final CacheService cacheproxy;
int serverport = 0;

// ignore: must_be_immutable
class PlayPage extends StatelessWidget {
  late String videoId;

  PlayPage({Key? key}) : super(key: key);

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
    final player = videoplayer(videoId, title);

    final cc = (cid.isNotEmpty && ctitle.isNotEmpty)
        ? InkWell(
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              child: Text(
                ctitle,
                style: const TextStyle(fontSize: 14, color: Colors.blue),
              ),
            ),
            onTap: () {
              Navigator.pushNamed(context, '/channel', arguments: cid);
            },
          )
        : const SizedBox(
            height: 2,
          );

    final full = MediaQuery.of(context).orientation == Orientation.landscape;

    Future<dynamic> fn() async {
      return refresh(item["channel"] is bool);
    }

    final page = Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [RightMenu(videoId, cid)],
      ),
      body: ListView(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(10, 15, 0, 10),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          AspectRatio(
            aspectRatio: 1.7777,
            child: player,
          ),
          Container(
            color: Colors.grey[100],
            padding: const EdgeInsets.fromLTRB(10, 15, 0, 0),
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
                      style: const TextStyle(height: 1),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Text(
                      dur,
                      style: const TextStyle(height: 1, color: Colors.red),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Text(count,
                        style: const TextStyle(
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
            color: Colors.grey[100],
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 10),
                  child: Align(
                    child: Text(
                      desc,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    alignment: Alignment.topLeft,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  padding: const EdgeInsets.only(left: 10),
                  child: const Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "相关视频",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                VideoListBuilder(fn),
                const SizedBox(
                  height: 30,
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

  Future<dynamic> refresh(bool channel) {
    if (channel) {
      return api.playlistsInChannel(channelId: videoId);
    }
    return api.relatedVideo(relatedToVideoId: videoId);
  }

  videoplayer(String videoId, String title) {
    if (serverport == 0) {
      final arr = streambase.split(";");
      arr.removeWhere((element) => element.isEmpty);
      cacheproxy = CacheService(arr);
    }
    String url = "http://127.0.0.1:";
    return FutureBuilder(
      future: () async {
        if (serverport == 0) {
          serverport = await cacheproxy.start();
          cacheproxy.listen();
        }
        return url + "$serverport/$videoId.mpd";
      }(),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (!snapshot.hasError) {
            return VideoStreamPlayer(snapshot.data, title);
          }
          return Center(
            child: TextButton(
              child: const Text("加载失败"),
              onPressed: () =>
                  {Toast.toast(context, snapshot.error.toString())},
            ),
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

class RightMenu extends StatefulWidget {
  final String videoId;
  final String cid;

  const RightMenu(this.videoId, this.cid, {Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _RightMenuState();
  }
}

class _RightMenuState extends State<RightMenu> {
  late Future future;
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
              final hasFav = vids.contains(widget.videoId);
              final hasFavCid = cids.contains(widget.cid);
              return PopupMenuButton(
                onSelected: (result) async {
                  if (result == VideoAction.dlna) {
                    showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return DlnaDeviceList(videoId: widget.videoId);
                        });
                  } else if (result == VideoAction.fav) {
                    if (hasFav) {
                      await delFavVIds(widget.videoId);
                      Toast.toast(context, "已取消收藏");
                    } else {
                      await addFavVIds(widget.videoId);
                      Toast.toast(context, "已加入收藏");
                    }
                  } else if (result == VideoAction.favchannel) {
                    if (hasFavCid) {
                      await delFavCIds(widget.cid);
                      Toast.toast(context, "已取消收藏此频道");
                    } else {
                      await addFavCIds(widget.cid);
                      Toast.toast(context, "已收藏此频道");
                    }
                  }
                  setState(() {
                    future = myFav();
                  });
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                  const PopupMenuItem<VideoAction>(
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
            }
            return Center(
              child: TextButton(
                child: const Text("加载失败"),
                onPressed: () =>
                    {Toast.toast(context, snapshot.error.toString())},
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  myFav() async {
    final vids = await getFavVIds();
    final cids = await getFavCIds();
    return [vids, cids];
  }
}
