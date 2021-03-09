import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class PlayPauseButton extends StatefulWidget {
  final VideoPlayerController videoPlayerController;
  final Function setVisibilityTimer;

  PlayPauseButton({
    @required this.videoPlayerController,
    @required this.setVisibilityTimer,
  });

  @override
  State<StatefulWidget> createState() {
    return _PlayPauseButtonState();
  }
}

class _PlayPauseButtonState extends State<PlayPauseButton> {
  bool _playing = true;

  void _action() {
    setState(() => _playing = !_playing);
    _playing
        ? widget.videoPlayerController.play()
        : widget.videoPlayerController.pause();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        _playing ? Icons.pause : Icons.play_arrow,
        color: Colors.white,
      ),
      onPressed: () {
        widget.setVisibilityTimer();
        _action();
      },
    );
  }
}
