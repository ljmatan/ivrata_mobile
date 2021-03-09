import 'package:ivrata_mobile/data/auth/user_data.dart';
import 'package:ivrata_mobile/logic/api/models/videos_response_model.dart';
import 'package:ivrata_mobile/logic/api/videos_api.dart';
import 'package:ivrata_mobile/logic/cache/db.dart';
import 'package:ivrata_mobile/logic/cache/prefs.dart';
import 'package:ivrata_mobile/ui/screens/profile/video_player_option.dart';
import 'package:ivrata_mobile/ui/shared/future_builder_no_data.dart';
import 'package:ivrata_mobile/ui/shared/video_entry/video_entry.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  final Function(int) logoutSuccesful;

  ProfilePage({@required this.logoutSuccesful});

  @override
  State<StatefulWidget> createState() {
    return _ProfilePageState();
  }
}

class _ProfilePageState extends State<ProfilePage> {
  int _currentPage = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(User.instance.name),
        actions: [
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 16, 14, 14),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    'Default Video Player',
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                StatefulBuilder(
                  builder: (context, newState) => Row(
                    children: [
                      VideoPlayerOption(
                        UniqueKey(),
                        label: 'Native',
                        rebuild: () => newState(() => null),
                      ),
                      const SizedBox(width: 10),
                      VideoPlayerOption(
                        UniqueKey(),
                        label: 'VLC',
                        rebuild: () => newState(() => null),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: GestureDetector(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: Theme.of(context).accentColor,
                ),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 48,
                  child: const Center(
                    child: Text(
                      'Log Out',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              onTap: () async {
                showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) =>
                        Center(child: CircularProgressIndicator()));
                await DB.instance.rawDelete('DELETE * FROM Saved');
                for (var key in Prefs.instance.getKeys())
                  await Prefs.instance.remove(key);
                User.setInstance(null);
                widget.logoutSuccesful(1);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 0),
            child: FutureBuilder(
              builder: (context, videos) => FutureBuilder(
                future: VideosAPI.getChannelVideos(
                  User.instance.channelName,
                  _currentPage,
                ),
                builder: (context, AsyncSnapshot<VideosResponse> videos) =>
                    videos.connectionState != ConnectionState.done ||
                            videos.hasError ||
                            videos.hasData && videos.data.error != false ||
                            videos.hasData && videos.data.response.rows.isEmpty
                        ? SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height / 2,
                            child: videos.hasData &&
                                    videos.data.response.rows.isEmpty
                                ? Center(
                                    child: Text(
                                      'No videos found.',
                                      textAlign: TextAlign.center,
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  )
                                : FutureBuilderNoData(videos),
                          )
                        : Stack(
                            children: [
                              Column(
                                children: [
                                  for (var i = 0;
                                      i < videos.data.response.rows.length;
                                      i++)
                                    VideoEntry(
                                        video: videos.data.response.rows[i],
                                        index: i)
                                ],
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
                                    onTap: () =>
                                        setState(() => _currentPage -= 1),
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
                                    onTap: () =>
                                        setState(() => _currentPage += 1),
                                  ),
                                ),
                            ],
                          ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
