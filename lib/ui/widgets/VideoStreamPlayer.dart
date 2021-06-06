import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoStreamPlayer extends StatefulWidget {
  final String videoId;
  VideoStreamPlayer(this.videoId);

  @override
  State<StatefulWidget> createState() {
    return _VideoStreamPlayerState(videoId);
  }
}

class _VideoStreamPlayerState extends State {
  late VideoPlayerController _controller;
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
      child: _controller.value.isInitialized
          ? AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: <Widget>[
                  VideoPlayer(_controller), //here it is!!
                  _PlayerController(_controller),
                  VideoProgressIndicator(_controller,
                      allowScrubbing: true,
                      colors: VideoProgressColors(playedColor: Colors.blue)),
                ],
              ),
            )
          : Container(
              child: SizedBox(
                height: 200,
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

class _PlayerController extends StatelessWidget {
  final VideoPlayerController controller;

  _PlayerController(this.controller);

  @override
  Widget build(BuildContext context) {
    return _PlayPauseOverlay(controller);
  }
}

class _PlayPauseOverlay extends StatefulWidget {
  final VideoPlayerController controller;

  const _PlayPauseOverlay(this.controller);

  @override
  State<StatefulWidget> createState() {
    return _PlayPauseOverlayState(controller);
  }
}

class _PlayPauseOverlayState extends State {
  late final VideoPlayerController controller;
  bool playing = false;

  _PlayPauseOverlayState(this.controller);

  @override
  Widget build(BuildContext context) {
    playing = controller.value.isPlaying;
    return Stack(
      children: <Widget>[
        AnimatedSwitcher(
          duration: Duration(milliseconds: 50),
          reverseDuration: Duration(milliseconds: 200),
          child: playing
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
            if (controller.value.isPlaying) {
              controller.pause();
            } else {
              controller.play(); //play on tap
            }
            setState(() {
              playing = controller.value.isPlaying;
            });
          },
          onLongPress: () {},
          onDoubleTap: () {},
        ),
      ],
    );
  }
}
