import 'package:ivrata_mobile/logic/api/models/videos_response_model.dart';
import 'package:ivrata_mobile/logic/api/videos_api.dart';
import 'package:ivrata_mobile/ui/shared/future_builder_no_data.dart';
import 'package:ivrata_mobile/ui/shared/video_view/video_view_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatelessWidget {
  static final Future<VideosResponse> _getVideos = VideosAPI.getLatest();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getVideos,
      builder: (context, AsyncSnapshot<VideosResponse> videos) => videos
                      .connectionState !=
                  ConnectionState.done ||
              videos.hasError ||
              videos.hasData && videos.data.error != false ||
              videos.hasData && videos.data.response.rows.isEmpty
          ? FutureBuilderNoData(videos)
          : ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: videos.data.response.rows.length,
              itemBuilder: (context, i) => Padding(
                padding: EdgeInsets.fromLTRB(14, i == 0 ? 16 : 0, 14, 14),
                child: GestureDetector(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      boxShadow: kElevationToShadow[2],
                      color: Colors.grey.shade200,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.width * 0.625,
                          child: Stack(
                            children: [
                              Hero(
                                tag: videos
                                    .data.response.rows[i].images.thumbsJpg,
                                child: Image.network(
                                  videos.data.response.rows[i].images.thumbsJpg,
                                  width: MediaQuery.of(context).size.width,
                                  height: MediaQuery.of(context).size.height,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 10, 10, 0),
                                child: Stack(
                                  children: [
                                    Text(
                                      videos.data.response.rows[i].title,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        foreground: Paint()
                                          ..style = PaintingStyle.stroke
                                          ..strokeWidth = 2,
                                      ),
                                    ),
                                    Text(
                                      videos.data.response.rows[i].title,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        DecoratedBox(
                          decoration: BoxDecoration(color: Colors.white),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.thumb_up, size: 20),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 8,
                                        right: 16,
                                      ),
                                      child: Text(
                                        NumberFormat.compact().format(
                                          videos.data.response.rows[i].likes,
                                        ),
                                      ),
                                    ),
                                    Icon(Icons.thumb_down, size: 20),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8),
                                      child: Text(
                                        NumberFormat.compact().format(
                                          videos.data.response.rows[i].dislikes,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  NumberFormat.compact().format(
                                        videos.data.response.rows[i].viewsCount,
                                      ) +
                                      ' views',
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => VideoViewScreen(
                          video: videos.data.response.rows[i]))),
                ),
              ),
            ),
    );
  }
}
