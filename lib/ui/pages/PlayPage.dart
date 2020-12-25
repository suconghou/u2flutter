import 'package:flutter/material.dart';
import 'package:flutter_app/api/index.dart';
import '../widgets/VideoListBuilder.dart';
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
          margin:  EdgeInsets.symmetric(vertical: 10),
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
          SizedBox(
            height: 300,
          ),
          cc,
          Row(
            children: [
              Text(pubTime),
              SizedBox(width: 4,),
              Text(dur),
              SizedBox(width: 4,),
              Text(count,
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
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
