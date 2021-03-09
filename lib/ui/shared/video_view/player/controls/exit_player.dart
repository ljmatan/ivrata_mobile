import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class ExitPlayerButton extends StatelessWidget {
  final VideoPlayerController videoPlayerController;

  ExitPlayerButton({@required this.videoPlayerController});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.arrow_back,
        color: Colors.white,
      ),
      onPressed: () {
        SystemChrome.setPreferredOrientations([]);
        SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
        videoPlayerController.pause();
        Navigator.pop(context);
      },
    );
  }
}
