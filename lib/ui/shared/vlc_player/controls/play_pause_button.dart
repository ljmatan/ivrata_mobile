import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';

class VLCPlayPauseButton extends StatefulWidget {
  final VlcPlayerController videoPlayerController;
  final Function setVisibilityTimer;

  VLCPlayPauseButton({
    @required this.videoPlayerController,
    @required this.setVisibilityTimer,
  });

  @override
  State<StatefulWidget> createState() {
    return _VLCPlayPauseButtonState();
  }
}

class _VLCPlayPauseButtonState extends State<VLCPlayPauseButton> {
  bool _playing = true;

  void _action() {
    widget.setVisibilityTimer();
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
      onPressed: () => _action(),
    );
  }
}
