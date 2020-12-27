import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoStreamPlayer extends StatefulWidget {
  String videoId;
  VideoStreamPlayer(this.videoId);

  @override
  State<StatefulWidget> createState() {
    return _VideoStreamPlayerState(videoId);
  }
}

class _VideoStreamPlayerState extends State {
  VideoPlayerController _controller;
  String videoId;

  _VideoStreamPlayerState(this.videoId);

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
      'http://share.suconghou.cn/video/$videoId.mpd',
      formatHint: VideoFormat.dash,
    )..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: _controller.value.initialized
          ? AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: <Widget>[
                  VideoPlayer(_controller), //here it is!!
                  _PlayPauseOverlay(controller: _controller),
                  VideoProgressIndicator(_controller, allowScrubbing: true),
                ],
              ),
            )
          : Container(
              child: SizedBox(
                height: 300,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}

class _PlayPauseOverlay extends StatelessWidget {
  const _PlayPauseOverlay({Key key, this.controller}) : super(key: key);

  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AnimatedSwitcher(
          duration: Duration(milliseconds: 50),
          reverseDuration: Duration(milliseconds: 200),
          child: controller.value.isPlaying
              ? SizedBox.shrink()
              : Container(
                  color: Colors.black26,
                  child: Center(
                    child: Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 100.0,
                    ),
                  ),
                ),
        ),
        GestureDetector(
          onTap: () {
            controller.play(); //play on tap
          },
        ),
      ],
    );
  }
}
