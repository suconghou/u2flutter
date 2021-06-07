import 'package:flutter/material.dart';
import 'package:u2flutter_player/u2flutter_player.dart';

class VideoStreamPlayer extends StatefulWidget {
  final String videoId;
  final String title;
  VideoStreamPlayer(this.videoId, this.title);

  @override
  State<StatefulWidget> createState() {
    return _VideoStreamPlayerState(videoId, title);
  }
}

class _VideoStreamPlayerState extends State<VideoStreamPlayer>
    with AutomaticKeepAliveClientMixin {
  final String videoId;
  final String title;
  _VideoStreamPlayerState(this.videoId, this.title);

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final url = 'http://share.suconghou.cn/video/$videoId.mpd';
    return VideoPlayerUI.network(
      url: url,
      title: title,
    );
  }

  @override
  bool get wantKeepAlive => true;
}
