import 'package:flutter/material.dart';
import 'package:flutter_app/api/index.dart';
import '../widgets/VideoListBuilder.dart';
import '../widgets/VideoStreamPlayer.dart';
import '../../utils/videoInfo.dart';

class PlayPage extends StatelessWidget {
  Future<dynamic> _refresh;
  String videoId;

  @override
  Widget build(BuildContext context) {
    dynamic item = ModalRoute.of(context).settings.arguments;
    final String id = getVideoId(item);
    final String title = getVideoTitle(item);
    ;
    final String desc = getVideoTitle(item);
    final String pubTime = pubAt(item);
    final String count = viewCount(item);
    final String dur = duration(item);
    final String cid = getChannelId(item);
    final String ctitle = getChannelTitle(item);
    final cc = (cid.isNotEmpty && ctitle.isNotEmpty)
        ? Container(
          margin:  EdgeInsets.only(bottom: 10),
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
    videoId = id;
    refresh();
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: ListView(
        padding: EdgeInsets.all(10),
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          VideoStreamPlayer(videoId),
          cc,
          Row(
            children: [
              Text("发布于"+pubTime,style: TextStyle(height: 1),),
              SizedBox(width: 8,),
              Text(dur,style: TextStyle(height: 1,color: Colors.red),),
              SizedBox(width: 8,),
              Text(count,
                  style: TextStyle(
                      height: 1,
                      fontSize: 14,
                      color: Colors.black87,
                      decoration: TextDecoration.none)),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            desc,
            style: TextStyle(color: Colors.grey),
          ),
          SizedBox(
            height: 100,
          ),
          VideoListBuilder(_refresh, refresh).build(),
          SizedBox(
            height: 100,
          ),
        ],
      ),
    );
  }

  refresh() {
    if (true) {
      _refresh = api.relatedVideo(relatedToVideoId: videoId);
    } else {
      _refresh = api.playlistsInChannel(channelId: videoId);
    }
  }
}
