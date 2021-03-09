import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';

class VLCPositionIndicator extends StatefulWidget {
  final VlcPlayerController videoPlayerController;
  final StreamController positionController;
  final int initialPosition;
  final Function setVisibilityTimer;

  VLCPositionIndicator({
    @required this.videoPlayerController,
    @required this.positionController,
    @required this.initialPosition,
    @required this.setVisibilityTimer,
  });

  @override
  State<StatefulWidget> createState() {
    return _VLCPositionIndicatorState();
  }
}

class _VLCPositionIndicatorState extends State<VLCPositionIndicator> {
  bool _isSeeking = false;

  double _seekValue;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: widget.positionController.stream,
      initialData: widget.initialPosition,
      builder: (context, currentPosition) => Expanded(
        child: Slider(
          value: _isSeeking
              ? _seekValue
              : (currentPosition.data /
                  widget.videoPlayerController.value.duration.inSeconds),
          onChanged: (value) {
            widget.setVisibilityTimer();
            setState(() => _seekValue = value);
          },
          onChangeStart: (value) => setState(() {
            widget.setVisibilityTimer();
            _seekValue = value;
            _isSeeking = true;
          }),
          onChangeEnd: (value) => widget.videoPlayerController
              .seekTo(Duration(
                  seconds: (value *
                          widget.videoPlayerController.value.duration.inSeconds)
                      .round()))
              .whenComplete(() => setState(() => _isSeeking = false)),
        ),
      ),
    );
  }
}
