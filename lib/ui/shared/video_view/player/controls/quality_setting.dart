import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class QualitySettingButton extends StatefulWidget {
  final VideoPlayerController videoPlayerController;
  final Set<String> videoQualities;
  final Function changeVideoQuality, setVisibilityTimer;

  QualitySettingButton({
    @required this.videoPlayerController,
    @required this.videoQualities,
    @required this.changeVideoQuality,
    @required this.setVisibilityTimer,
  });

  @override
  State<StatefulWidget> createState() {
    return _QualitySettingButtonState();
  }
}

class _QualitySettingButtonState extends State<QualitySettingButton> {
  Widget _qualitySettingSelection(
    String filenameEndsWith,
    String label,
  ) {
    final String thisOption = widget.videoQualities
        .firstWhere((e) => e.contains(filenameEndsWith), orElse: () => null);
    return thisOption != null
        ? Column(
            children: [
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 64,
                  child: Center(child: Text(label + ' quality')),
                ),
                onTap: () {
                  Navigator.pop(context);
                  if (!widget.videoPlayerController.dataSource
                      .contains(filenameEndsWith))
                    widget.changeVideoQuality(thisOption);
                },
              ),
              const Divider(height: 0),
            ],
          )
        : const SizedBox();
  }

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
                elevation: 16,
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _qualitySettingSelection('HD.', '4k'),
                    _qualitySettingSelection('SD.', '1080p'),
                    _qualitySettingSelection('Low.', 'SD'),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
