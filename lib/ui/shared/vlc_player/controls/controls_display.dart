import 'dart:async';

import 'package:ivrata_mobile/ui/shared/vlc_player/controls/fullscreen.dart';
import 'package:ivrata_mobile/ui/shared/vlc_player/controls/play_pause_button.dart';
import 'package:ivrata_mobile/ui/shared/vlc_player/controls/position.dart';
import 'package:ivrata_mobile/ui/shared/vlc_player/controls/quality_setting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';

class VLCControlsDisplay extends StatelessWidget {
  final VlcPlayerController videoPlayerController;
  final Stream visibilityStream;
  final Set<String> videoQualities;
  final Function changeVideoQuality;
  final StreamController positionController;
  final int initialPosition;
  final Function setVisibilityTimer;

  VLCControlsDisplay({
    @required this.videoPlayerController,
    @required this.videoQualities,
    @required this.visibilityStream,
    @required this.changeVideoQuality,
    @required this.positionController,
    @required this.initialPosition,
    @required this.setVisibilityTimer,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: StreamBuilder(
        stream: visibilityStream,
        initialData: true,
        builder: (context, visible) => AnimatedOpacity(
          opacity: visible.data ? 1 : 0,
          duration: const Duration(milliseconds: 400),
          child: DecoratedBox(
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 56,
              child: Row(
                children: [
                  VLCPlayPauseButton(
                    videoPlayerController: videoPlayerController,
                    setVisibilityTimer: setVisibilityTimer,
                  ),
                  VLCPositionIndicator(
                    videoPlayerController: videoPlayerController,
                    positionController: positionController,
                    initialPosition: initialPosition,
                    setVisibilityTimer: setVisibilityTimer,
                  ),
                  VLCQualitySettingButton(
                    videoPlayerController: videoPlayerController,
                    videoQualities: videoQualities,
                    changeVideoQuality: changeVideoQuality,
                    setVisibilityTimer: setVisibilityTimer,
                  ),
                  VLCFullscreenButton(
                    setVisibilityTimer: setVisibilityTimer,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
