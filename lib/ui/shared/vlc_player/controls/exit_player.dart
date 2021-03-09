import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';

class ExitVLCPlayerButton extends StatelessWidget {
  final VlcPlayerController videoPlayerController;
  final Stream visibilityStream;

  ExitVLCPlayerButton({
    @required this.videoPlayerController,
    @required this.visibilityStream,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 0,
      top: MediaQuery.of(context).padding.top,
      child: StreamBuilder(
        stream: visibilityStream,
        initialData: true,
        builder: (context, visible) => AnimatedOpacity(
          opacity: visible.data ? 1 : 0,
          duration: const Duration(milliseconds: 400),
          child: IconButton(
            icon: Icon(Icons.close, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
    );
  }
}
