import 'package:flutter/material.dart';
import 'package:u2flutter_player/u2flutter_player.dart';

class VideoStreamPlayer extends StatelessWidget {
  final String videoId;
  VideoStreamPlayer(this.videoId);

  @override
  Widget build(BuildContext context) {
    final url = 'http://share.suconghou.cn/video/$videoId.mpd';
    return VideoPlayerUI.network(url: url);
  }
}
