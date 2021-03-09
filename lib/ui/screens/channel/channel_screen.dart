import 'package:ivrata_mobile/logic/api/models/videos_response_model.dart';
import 'package:ivrata_mobile/logic/api/videos_api.dart';
import 'package:ivrata_mobile/ui/shared/future_builder_no_data.dart';
import 'package:ivrata_mobile/ui/shared/video_entry/video_entry.dart';
import 'package:flutter/material.dart';

class ChannelScreen extends StatefulWidget {
  final String channelName, channelIdentifier;

  ChannelScreen({@required this.channelName, @required this.channelIdentifier});

  @override
  State<StatefulWidget> createState() {
    return _ChannelScreenState();
  }
}

class _ChannelScreenState extends State<ChannelScreen> {
  int _currentPage = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(widget.channelName),
        actions: [
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: FutureBuilder(
        future: VideosAPI.getChannelVideos(
          widget.channelIdentifier,
          _currentPage,
        ),
        builder: (context, AsyncSnapshot<VideosResponse> videos) =>
            videos.connectionState != ConnectionState.done ||
                    videos.hasError ||
                    videos.hasData && videos.data.error != false ||
                    videos.hasData && videos.data.response.rows.isEmpty
                ? videos.hasData && videos.data.response.rows.isEmpty
                    ? Center(
                        child: Text(
                          'No videos found.',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.white),
                        ),
                      )
                    : FutureBuilderNoData(videos)
                : Stack(
                    children: [
                      ListView.builder(
                        itemCount: videos.data.response.rows.length,
                        itemBuilder: (context, i) => VideoEntry(
                            video: videos.data.response.rows[i], index: i),
                      ),
                      if (_currentPage != 1)
                        Positioned(
                          bottom: 16,
                          left: 16,
                          child: GestureDetector(
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: kElevationToShadow[2],
                                color: Theme.of(context).accentColor,
                              ),
                              child: SizedBox(
                                width: 56,
                                height: 56,
                                child: Center(
                                  child: Icon(
                                    Icons.keyboard_arrow_left_outlined,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            onTap: () => setState(() => _currentPage -= 1),
                          ),
                        ),
                      if (videos.data.response.rows.length == 60)
                        Positioned(
                          bottom: 16,
                          right: 16,
                          child: GestureDetector(
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: kElevationToShadow[2],
                                color: Theme.of(context).accentColor,
                              ),
                              child: SizedBox(
                                width: 56,
                                height: 56,
                                child: Center(
                                  child: Icon(
                                    Icons.keyboard_arrow_right,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            onTap: () => setState(() => _currentPage += 1),
                          ),
                        ),
                    ],
                  ),
      ),
    );
  }
}
