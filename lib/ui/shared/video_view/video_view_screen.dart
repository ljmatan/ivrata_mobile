import 'dart:async';

import 'package:ivrata_mobile/logic/api/models/videos_response_model.dart';
import 'package:ivrata_mobile/logic/cache/prefs.dart';
import 'package:ivrata_mobile/ui/screens/channel/channel_screen.dart';
import 'package:ivrata_mobile/ui/shared/video_view/player/rating_section.dart';
import 'package:ivrata_mobile/ui/shared/video_view/save_video_dialog.dart';
import 'package:ivrata_mobile/ui/shared/vlc_player/vlc_player_screen.dart';
import 'bloc/buffering_controller.dart';
// import 'comments_display.dart';
import 'player/player_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:video_player/video_player.dart';

class VideoViewScreen extends StatefulWidget {
  final VideoData video;

  VideoViewScreen({@required this.video});

  @override
  State<StatefulWidget> createState() {
    return _VideoViewScreenState();
  }
}

class _VideoViewScreenState extends State<VideoViewScreen> {
  VideoPlayerController _videoPlayerController;

  int _currentPosition;

  StreamController _positionController;
  void _setPositionController(
      [int currenPosition = 0, VideoPlayerController controller]) {
    _currentPosition = currenPosition;
    _positionController = StreamController.broadcast();
    VideoPlayerController currentController =
        controller ?? _videoPlayerController;
    currentController.addListener(() {
      _currentPosition = currentController.value.position.inSeconds;
      _positionController.add(currentController.value.position.inSeconds);
      if (currentController.value.isBuffering && !BufferingController.buffering)
        BufferingController.change(true);
      else if (!currentController.value.isBuffering &&
          BufferingController.buffering) BufferingController.change(false);
    });
  }

  Set<String> _videoQualities;

  @override
  void initState() {
    super.initState();
    BufferingController.init();
    _videoQualities = {
      widget.video.videos.mp4.hd,
      widget.video.videos.mp4.sd,
      widget.video.videos.mp4.low
    };
    _videoQualities.removeWhere((element) => element == null);
    _videoPlayerController = VideoPlayerController.network(
      _videoQualities.elementAt(0) ?? '',
    );
    _videoPlayerController.addListener(() =>
        BufferingController.change(_videoPlayerController.value.isBuffering));
  }

  Future<bool> _getLargeImage() async {
    await precacheImage(
      NetworkImage(widget.video.images.poster),
      context,
    );
    return true;
  }

  Future<void> _changeVideoQuality(String videoURL) async {
    _videoPlayerController.pause();
    Navigator.pop(context);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );
    final int currentPositionInSecs =
        (_videoPlayerController.value.position.inMilliseconds / 1000).round();
    try {
      _videoPlayerController.removeListener(() {});
      final _newPlayerController = VideoPlayerController.network(videoURL);
      await _newPlayerController.initialize();
      await _newPlayerController
          .seekTo(Duration(seconds: currentPositionInSecs));
      _setPositionController(currentPositionInSecs, _newPlayerController);
      Navigator.pop(context);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => VideoPlayerScreen(
            UniqueKey(),
            videoPlayerController: _newPlayerController,
            positionController: _positionController,
            currentPosition: _currentPosition,
            videoQualities: _videoQualities,
            changeVideoQuality: _changeVideoQuality,
          ),
        ),
      );
      await _videoPlayerController.dispose();
      _videoPlayerController = _newPlayerController;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(widget.video.title),
        actions: [
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    GestureDetector(
                      child: Stack(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.width * 0.625,
                            child: FutureBuilder(
                              future: _getLargeImage(),
                              builder: (context, cached) => AnimatedCrossFade(
                                firstChild: Hero(
                                  tag: widget.video.images.thumbsJpg,
                                  child: Image.network(
                                    widget.video.images.thumbsJpg,
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.width *
                                        0.625,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                secondChild: Image.network(
                                  widget.video.images.poster,
                                  width: MediaQuery.of(context).size.width,
                                  height:
                                      MediaQuery.of(context).size.width * 0.625,
                                  fit: BoxFit.cover,
                                ),
                                crossFadeState: cached.hasData
                                    ? CrossFadeState.showSecond
                                    : CrossFadeState.showFirst,
                                duration: const Duration(milliseconds: 200),
                              ),
                            ),
                          ),
                          DecoratedBox(
                            decoration: BoxDecoration(color: Colors.black54),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.width * 0.625,
                              child: Center(
                                child: Icon(
                                  Icons.play_arrow,
                                  color: Colors.white,
                                  size: 64,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      onTap: (Prefs.instance.getBool('nativePlayer') ?? false)
                          ? () async {
                              bool error = false;
                              if (_currentPosition == null) {
                                showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    barrierColor: Colors.transparent,
                                    builder: (context) => Center(
                                        child: CircularProgressIndicator()));
                                try {
                                  await _videoPlayerController.initialize();
                                  _setPositionController();
                                } catch (e) {
                                  error = true;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('$e')));
                                }
                                Navigator.pop(context);
                              }
                              if (!error) {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        VideoPlayerScreen(
                                      UniqueKey(),
                                      videoPlayerController:
                                          _videoPlayerController,
                                      positionController: _positionController,
                                      currentPosition: _currentPosition,
                                      videoQualities: _videoQualities,
                                      changeVideoQuality: _changeVideoQuality,
                                    ),
                                  ),
                                );
                                FocusScope.of(context).previousFocus();
                              }
                            }
                          : () => Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  VLCPlayerScreen(video: widget.video))),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(14, 16, 14, 0),
                      child: DefaultTextStyle(
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                GestureDetector(
                                  child: Icon(
                                    Icons.add_to_photos_outlined,
                                    color: Colors.white,
                                  ),
                                  onTap: () => showDialog(
                                    context: context,
                                    barrierColor: Colors.transparent,
                                    builder: (context) => SaveVideoDialog(
                                      video: widget.video,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8),
                                  child: Text(
                                    NumberFormat.compact()
                                            .format(widget.video.viewsCount) +
                                        ' views',
                                  ),
                                ),
                              ],
                            ),
                            RatingSection(video: widget.video),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          DecoratedBox(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: Theme.of(context).accentColor,
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(24, 12, 24, 12),
                              child: Text(
                                'Subscribe',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: Text(
                                widget.video.name,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                  color: Theme.of(context).accentColor,
                                ),
                              ),
                            ),
                            onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        ChannelScreen(
                                            channelName: widget.video.name,
                                            channelIdentifier:
                                                widget.video.channelName))),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(14, 0, 14, 16),
                      child: Text(
                        widget.video.description,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // SizedBox(height: 64),
            ],
          ),
          // Uncomment below and line 8 and 283 for comment display
          /*
          CommentsDisplay(
            comments: widget.video.comments,
            videoID: widget.video.id,
          ),
          */
        ],
      ),
    );
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    BufferingController.dispose();
    super.dispose();
  }
}
