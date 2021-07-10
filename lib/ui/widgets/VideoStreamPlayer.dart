import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
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
    final controller = Players.getInstance(url);
    return VideoPlayerUI(
      controller: controller,
      title: title,
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}

class Players {
  static VideoPlayerController? player;
  static VideoPlayerController getInstance(String url) {
    if (player == null) {
      player = VideoPlayerController.network(url, formatHint: VideoFormat.dash);
    }
    // 已经存在实例了,判断是否相同
    if (player?.dataSource != url) {
      player?.pause();
      player?.dispose();
      player = VideoPlayerController.network(url, formatHint: VideoFormat.dash);
    }
    return player!;
  }
}
