import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class QualitySettingButton extends StatefulWidget {
  final VideoPlayerController videoPlayerController;
  final Set<String> videoQualities;
  final Function setVisibilityTimer;

  QualitySettingButton({
    @required this.videoPlayerController,
    @required this.videoQualities,
    @required this.setVisibilityTimer,
  });

  @override
  State<StatefulWidget> createState() {
    return _QualitySettingButtonState();
  }
}

class _QualitySettingButtonState extends State<QualitySettingButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.settings,
        color: Colors.white,
      ),
      onPressed: () {
        widget.setVisibilityTimer();
        widget.videoPlayerController.pause();
        showDialog(
          context: context,
          barrierColor: Colors.transparent,
          builder: (context) => Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Material(
                color: Colors.transparent,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
