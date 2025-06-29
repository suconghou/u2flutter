// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:u2flutter_player/u2flutter_player.dart';

class VideoStreamPlayer extends StatefulWidget {
  final String url;
  final String title;
  const VideoStreamPlayer(this.url, this.title, {super.key});

  @override
  State<StatefulWidget> createState() {
    return _VideoStreamPlayerState();
  }
}

class _VideoStreamPlayerState extends State<VideoStreamPlayer>
    with AutomaticKeepAliveClientMixin {
  _VideoStreamPlayerState();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return VideoPlayerUI(opts: PlayerOpts(widget.url), title: widget.title);
  }

  @override
  bool get wantKeepAlive => true;
}
