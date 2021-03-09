import 'dart:async';

import 'package:ivrata_mobile/logic/api/models/videos_response_model.dart';
import 'controls/controls_display.dart';
import 'controls/exit_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';

class VLCPlayerScreen extends StatefulWidget {
  final VideoData video;

  VLCPlayerScreen({@required this.video});

  @override
  State<StatefulWidget> createState() {
    return _VLCPlayerScreenState();
  }
}

class _VLCPlayerScreenState extends State<VLCPlayerScreen> {
  VlcPlayerController _currentVideoController;
  VlcPlayerController _videoPlayerController;

  int _currentPosition = 0;
  int get currentPosition => _currentPosition;

  final _positionController = StreamController.broadcast();

  StreamSubscription _positionSubscription;

  bool _controlsVisible = false;
  final _controlsController = StreamController.broadcast();

  void _addVideoControllerListener(VlcPlayerController controller) =>
      controller.addListener(() {
        if (controller.value.isPlaying) {
          if (!_controlsVisible &&
              controller.value.position.inMilliseconds > 0) {
            _controlsVisible = true;
            _controlsController.add(true);
            _setVisbilityTimer();
          }
          _positionController.add(controller.value.position.inSeconds);
        }
      });

  Set<String> _videoQualities;

  final _visibilityController = StreamController.broadcast();
  Timer _controlVisibilityTimer;
  void _setVisbilityTimer() => _controlVisibilityTimer = Timer(
        const Duration(seconds: 4),
        () => _visibilityController.add(false),
      );

  @override
  void initState() {
    super.initState();
    _videoQualities = {
      widget.video.videos.mp4.hd,
      widget.video.videos.mp4.sd,
      widget.video.videos.mp4.low
    };
    _videoQualities.removeWhere((element) => element == null);
    _videoPlayerController = VlcPlayerController.network(
      _videoQualities.elementAt(0) ?? '',
    );
    _addVideoControllerListener(_videoPlayerController);
    _positionSubscription =
        _positionController.stream.listen((value) => _currentPosition = value);
  }

  Key _playerKey = UniqueKey();

  void _changeVideoQuality(String newVideoURL) async {
    setState(() => _controlsVisible = false);
    if (_videoPlayerController != null) {
      setState(() {
        _playerKey = UniqueKey();
        _controlsVisible = true;
        _currentVideoController =
            VlcPlayerController.network(newVideoURL, onInit: () {
          _addVideoControllerListener(_currentVideoController);
          _currentVideoController.seekTo(Duration(seconds: currentPosition));
        });
      });
      await _videoPlayerController.stopRendererScanning();
      await _videoPlayerController.dispose();
      _videoPlayerController = null;
    } else {
      setState(() {
        _playerKey = UniqueKey();
        _videoPlayerController.dispose();
        _currentVideoController = null;
        _controlsVisible = true;
        _videoPlayerController =
            VlcPlayerController.network(newVideoURL, onInit: () {
          _addVideoControllerListener(_videoPlayerController);
          _currentVideoController.seekTo(Duration(seconds: currentPosition));
        });
      });
      _addVideoControllerListener(_videoPlayerController);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox.expand(),
              CircularProgressIndicator(),
              VlcPlayer(
                key: _playerKey,
                controller: _currentVideoController ?? _videoPlayerController,
                aspectRatio: _videoPlayerController?.value?.aspectRatio ??
                    _currentVideoController?.value?.aspectRatio ??
                    16 / 9,
                placeholder: const SizedBox(),
              ),
            ],
          ),
          ExitVLCPlayerButton(
            videoPlayerController:
                _currentVideoController ?? _videoPlayerController,
            visibilityStream: _visibilityController.stream,
          ),
          StreamBuilder(
            stream: _controlsController.stream,
            initialData: false,
            builder: (context, enabled) => enabled.data
                ? VLCControlsDisplay(
                    videoPlayerController:
                        _currentVideoController ?? _videoPlayerController,
                    visibilityStream: _visibilityController.stream,
                    positionController: _positionController,
                    videoQualities: _videoQualities,
                    changeVideoQuality: _changeVideoQuality,
                    initialPosition: currentPosition,
                    setVisibilityTimer: _setVisbilityTimer,
                  )
                : const SizedBox(),
          ),
          StreamBuilder(
            stream: _controlsController.stream,
            initialData: false,
            builder: (context, enabled) => enabled.data
                ? StreamBuilder(
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
                  )
                : const SizedBox(),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    _visibilityController?.close();
    _controlVisibilityTimer?.cancel();
    _positionSubscription?.cancel();
    _positionController?.close();
    _currentVideoController?.dispose();
    _videoPlayerController?.dispose();
    super.dispose();
  }
}
