import 'package:flutter/material.dart';
import 'package:u2flutter_player/u2flutter_player.dart';

class VideoStreamPlayer extends StatefulWidget {
  final String url;
  final String title;
  VideoStreamPlayer(this.url, this.title);

  @override
  State<StatefulWidget> createState() {
    return _VideoStreamPlayerState(url, title);
  }
}

class _VideoStreamPlayerState extends State<VideoStreamPlayer>
    with AutomaticKeepAliveClientMixin {
  final String url;
  final String title;
  _VideoStreamPlayerState(this.url, this.title);

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return VideoPlayerUI(
      opts: PlayerOpts(url),
      title: title,
    );
  }

  @override
  void dispose() {
    Players.pause();
    super.dispose();
  }

  @override
  void deactivate() {
    Players.pause();
    super.deactivate();
  }

  @override
  bool get wantKeepAlive => true;
}
