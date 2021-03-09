import 'dart:async';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class PositionIndicator extends StatefulWidget {
  final VideoPlayerController videoPlayerController;
  final StreamController positionController;
  final int initialPosition;

  PositionIndicator({
    @required this.videoPlayerController,
    @required this.positionController,
    @required this.initialPosition,
  });

  @override
  State<StatefulWidget> createState() {
    return _PositionIndicatorState();
  }
}

class _PositionIndicatorState extends State<PositionIndicator> {
  bool _isSeeking = false;

  double _seekValue;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: StreamBuilder(
        stream: widget.positionController.stream,
        initialData: widget.initialPosition,
        builder: (context, currentPosition) => Slider(
          value: _isSeeking
              ? _seekValue
              : (currentPosition.data /
                  widget.videoPlayerController.value.duration.inSeconds),
          onChanged: (value) => setState(() => _seekValue = value),
          onChangeStart: (value) => setState(() {
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
