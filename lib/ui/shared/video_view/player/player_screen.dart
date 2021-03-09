import 'dart:async';

import 'package:flutter/services.dart';

import 'controls/exit_player.dart';
import 'controls/fullscreen.dart';
import 'controls/position.dart';
import 'controls/quality_setting.dart';

import '../bloc/buffering_controller.dart';
import 'controls/custom_divider.dart';
import 'controls/play_pause_button.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  final VideoPlayerController videoPlayerController;
  final StreamController positionController;
  final int currentPosition;
  final Set<String> videoQualities;
  final Function changeVideoQuality;

  VideoPlayerScreen(
    Key key, {
    @required this.videoPlayerController,
    @required this.positionController,
    @required this.currentPosition,
    @required this.videoQualities,
    @required this.changeVideoQuality,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _VideoPlayerScreenState();
  }
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations(
      widget.videoPlayerController.value.aspectRatio > 1
          ? [DeviceOrientation.landscapeRight, DeviceOrientation.landscapeLeft]
          : [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
    );
    WidgetsBinding.instance
        .addPostFrameCallback((_) => widget.videoPlayerController.play());
  }

  final _visibilityController = StreamController.broadcast();
  Timer _controlVisibilityTimer;
  void _setVisbilityTimer() {
    _controlVisibilityTimer?.cancel();
    _controlVisibilityTimer = Timer(
      const Duration(seconds: 4),
      () => _visibilityController.add(false),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: AspectRatio(
              aspectRatio: widget.videoPlayerController.value.aspectRatio,
              child: VideoPlayer(widget.videoPlayerController),
            ),
          ),
          StreamBuilder(
            stream: BufferingController.stream,
            initialData: false,
            builder: (context, isBuffering) =>
                isBuffering.hasData && isBuffering.data
                    ? Center(child: CircularProgressIndicator())
                    : const SizedBox(),
          ),
          if (widget.videoPlayerController?.value?.isInitialized)
            Positioned(
              bottom: 14,
              left: 0,
              right: 0,
              child: StreamBuilder(
                stream: _visibilityController.stream,
                initialData: true,
                builder: (context, visible) => AnimatedOpacity(
                  opacity: visible.data ? 1 : 0,
                  duration: const Duration(milliseconds: 400),
                  child: Column(
                    children: [
                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(28),
                        ),
                        child: SizedBox(
                          height: 56,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ExitPlayerButton(
                                  videoPlayerController:
                                      widget.videoPlayerController,
                                ),
                                ControlsDivider(),
                                PlayPauseButton(
                                  videoPlayerController:
                                      widget.videoPlayerController,
                                  setVisibilityTimer: _setVisbilityTimer,
                                ),
                                ControlsDivider(),
                                QualitySettingButton(
                                  videoPlayerController:
                                      widget.videoPlayerController,
                                  videoQualities: widget.videoQualities,
                                  setVisibilityTimer: _setVisbilityTimer,
                                  changeVideoQuality: widget.changeVideoQuality,
                                ),
                                ControlsDivider(),
                                FullscreenButton(
                                  setVisibilityTimer: _setVisbilityTimer,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: PositionIndicator(
                          videoPlayerController: widget.videoPlayerController,
                          positionController: widget.positionController,
                          initialPosition: widget
                              .videoPlayerController.value.position.inSeconds,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          StreamBuilder(
            stream: _visibilityController.stream,
            initialData: false,
            builder: (context, visible) => visible.data
                ? const SizedBox()
                : GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    child: SizedBox.expand(),
                    onTap: () {
                      _visibilityController.add(true);
                      _setVisbilityTimer();
                    },
                  ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([]);
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    _visibilityController.close();
    _controlVisibilityTimer?.cancel();
    super.dispose();
  }
}
