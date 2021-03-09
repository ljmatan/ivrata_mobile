import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class VLCFullscreenButton extends StatefulWidget {
  final Function setVisibilityTimer;

  VLCFullscreenButton({@required this.setVisibilityTimer});

  @override
  State<StatefulWidget> createState() {
    return _VLCFullscreenButtonState();
  }
}

class _VLCFullscreenButtonState extends State<VLCFullscreenButton>
    with WidgetsBindingObserver {
  bool _fullscreen = false;

  void _goFullscreen() => SystemChrome.setEnabledSystemUIOverlays([]);
  void _exitFullscreen() =>
      SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _fullscreen) _goFullscreen();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.fullscreen,
        color: Colors.white,
      ),
      onPressed: () {
        widget.setVisibilityTimer();
        _fullscreen = !_fullscreen;
        _fullscreen ? _goFullscreen() : _exitFullscreen();
      },
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
